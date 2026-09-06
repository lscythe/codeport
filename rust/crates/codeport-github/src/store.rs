use crate::client::GithubClient;
use crate::{cicd, issues, repos};
use codeport_core::entities::{CiJob, Commit, Issue, IssueComment, Pipeline, Repo};
use codeport_core::error::CodeportError;

pub trait HttpClient {
    fn get(&self, url: &str, auth: &str) -> Result<HttpResponse, CodeportError>;
    fn post_empty(&self, url: &str, auth: &str) -> Result<HttpResponse, CodeportError>;
    fn post_json(&self, url: &str, auth: &str, body: &str) -> Result<HttpResponse, CodeportError>;
    fn patch_json(&self, url: &str, auth: &str, body: &str) -> Result<HttpResponse, CodeportError>;
}

#[derive(Debug)]
pub struct HttpResponse {
    pub status: u16,
    pub body: String,
    pub rate_reset_at: Option<String>,
    pub next_page: Option<u32>,
}

pub struct GithubStore<C> {
    auth: String,
    http: C,
}

impl<C> std::fmt::Debug for GithubStore<C> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("GithubStore").finish_non_exhaustive()
    }
}

impl<C: HttpClient> GithubStore<C> {
    pub fn new(token: String, http: C) -> Result<Self, CodeportError> {
        let client = GithubClient::new(token)?;
        Ok(Self {
            auth: client.auth_header(),
            http,
        })
    }

    fn result<T>(
        &self,
        res: HttpResponse,
        parse: impl FnOnce(String) -> Result<T, CodeportError>,
    ) -> Result<T, CodeportError> {
        if res.status == 200 {
            return parse(res.body);
        }
        Err(GithubClient::map_status(
            res.status,
            &res.body,
            res.rate_reset_at,
        ))
    }

    pub fn list_repos(&self, page: u32) -> Result<(Vec<Repo>, Option<u32>), CodeportError> {
        if page == 0 {
            return Err(CodeportError::Validation(
                "page must start at 1".to_string(),
            ));
        }
        let url = repos::list_repos_url(page);
        let res = self.http.get(&url, &self.auth)?;
        if res.status != 200 {
            return Err(GithubClient::map_status(
                res.status,
                &res.body,
                res.rate_reset_at,
            ));
        }
        let next = res.next_page;
        Ok((repos::parse_repos(res.body)?, next))
    }

    pub fn list_issues(
        &self,
        full_name: &str,
        state: Option<&str>,
    ) -> Result<Vec<Issue>, CodeportError> {
        let url = issues::list_issues_url(full_name, state);
        let res = self.http.get(&url, &self.auth)?;
        self.result(res, issues::parse_issues)
    }

    pub fn list_runs(&self, full_name: &str) -> Result<Vec<Pipeline>, CodeportError> {
        let url = cicd::list_runs_url(full_name);
        let res = self.http.get(&url, &self.auth)?;
        self.result(res, cicd::parse_runs)
    }

    pub fn retry_run(&self, full_name: &str, run_id: u64) -> Result<(), CodeportError> {
        let url = cicd::retry_run_url(full_name, run_id);
        let res = self.http.post_empty(&url, &self.auth)?;
        if res.status == 201 || res.status == 204 {
            return Ok(());
        }
        Err(GithubClient::map_status(
            res.status,
            &res.body,
            res.rate_reset_at,
        ))
    }

    pub fn get_repo(&self, full_name: &str) -> Result<Repo, CodeportError> {
        let url = repos::get_repo_url(full_name);
        let res = self.http.get(&url, &self.auth)?;
        self.result(res, repos::parse_repo)
    }

    pub fn list_commits(&self, full_name: &str) -> Result<Vec<Commit>, CodeportError> {
        let url = repos::list_commits_url(full_name);
        let res = self.http.get(&url, &self.auth)?;
        self.result(res, repos::parse_commits)
    }

    pub fn get_issue(&self, full_name: &str, number: u64) -> Result<Issue, CodeportError> {
        let url = issues::get_issue_url(full_name, number);
        let res = self.http.get(&url, &self.auth)?;
        self.result(res, issues::parse_issue)
    }

    pub fn list_comments(
        &self,
        full_name: &str,
        number: u64,
    ) -> Result<Vec<IssueComment>, CodeportError> {
        let url = issues::list_comments_url(full_name, number);
        let res = self.http.get(&url, &self.auth)?;
        self.result(res, issues::parse_comments)
    }

    pub fn create_issue(
        &self,
        full_name: &str,
        title: &str,
        body: Option<&str>,
    ) -> Result<Issue, CodeportError> {
        let payload = issues::create_issue_body(title, body)?;
        let url = issues::create_issue_url(full_name);
        let res = self.http.post_json(&url, &self.auth, &payload)?;
        if res.status == 201 {
            return issues::parse_issue(res.body);
        }
        Err(GithubClient::map_status(
            res.status,
            &res.body,
            res.rate_reset_at,
        ))
    }

    pub fn close_issue(&self, full_name: &str, number: u64) -> Result<Issue, CodeportError> {
        self.set_issue_state(full_name, number, "closed")
    }

    pub fn reopen_issue(&self, full_name: &str, number: u64) -> Result<Issue, CodeportError> {
        self.set_issue_state(full_name, number, "open")
    }

    fn set_issue_state(
        &self,
        full_name: &str,
        number: u64,
        state: &str,
    ) -> Result<Issue, CodeportError> {
        let url = issues::get_issue_url(full_name, number);
        let payload = format!(r#"{{"state":"{state}"}}"#);
        let res = self.http.patch_json(&url, &self.auth, &payload)?;
        self.result(res, issues::parse_issue)
    }

    pub fn create_comment(
        &self,
        full_name: &str,
        number: u64,
        body: &str,
    ) -> Result<IssueComment, CodeportError> {
        let payload = issues::create_comment_body(body)?;
        let url = issues::create_comment_url(full_name, number);
        let res = self.http.post_json(&url, &self.auth, &payload)?;
        if res.status == 201 {
            return issues::parse_comment(res.body);
        }
        Err(GithubClient::map_status(
            res.status,
            &res.body,
            res.rate_reset_at,
        ))
    }

    pub fn get_run(&self, full_name: &str, run_id: u64) -> Result<Pipeline, CodeportError> {
        let url = cicd::get_run_url(full_name, run_id);
        let res = self.http.get(&url, &self.auth)?;
        self.result(res, cicd::parse_run)
    }

    pub fn list_jobs(&self, full_name: &str, run_id: u64) -> Result<Vec<CiJob>, CodeportError> {
        let url = cicd::list_jobs_url(full_name, run_id);
        let res = self.http.get(&url, &self.auth)?;
        self.result(res, cicd::parse_jobs)
    }
}
