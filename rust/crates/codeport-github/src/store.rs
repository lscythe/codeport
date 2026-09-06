use crate::client::GithubClient;
use crate::{cicd, issues, repos};
use codeport_core::entities::{Issue, Pipeline, Repo};
use codeport_core::error::CodeportError;

pub trait HttpClient {
    fn get(&self, url: &str, auth: &str) -> Result<HttpResponse, CodeportError>;
    fn post_empty(&self, url: &str, auth: &str) -> Result<HttpResponse, CodeportError>;
}

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
}
