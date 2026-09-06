//! Proof that a second provider can satisfy the core traits without
//! touching `codeport-core` or `codeport-github`. Simulates GitLab by
//! prefixing names; a real implementation would swap the HTTP layer only.
use codeport_core::entities::{CiJob, Commit, Issue, IssueComment, Pipeline, Repo};
use codeport_core::error::CodeportError;
use codeport_core::traits::{CiStore, IssueStore, RepoStore};

pub struct GitlabStub {
    prefix: String,
}

impl GitlabStub {
    pub fn new(prefix: &str) -> Self {
        Self {
            prefix: prefix.to_string(),
        }
    }

    fn namespaced(&self, full_name: &str) -> String {
        format!("{}/{full_name}", self.prefix)
    }
}

impl RepoStore for GitlabStub {
    fn list_repos(&self, _page: u32) -> Result<(Vec<Repo>, Option<u32>), CodeportError> {
        Ok((
            vec![Repo {
                id: 2,
                full_name: self.namespaced("group/project"),
                private: true,
                stars: 5,
                default_branch: "main".to_string(),
            }],
            None,
        ))
    }

    fn get_repo(&self, full_name: &str) -> Result<Repo, CodeportError> {
        Ok(Repo {
            id: 2,
            full_name: self.namespaced(full_name),
            private: true,
            stars: 5,
            default_branch: "main".to_string(),
        })
    }

    fn list_commits(&self, _full_name: &str) -> Result<Vec<Commit>, CodeportError> {
        Ok(vec![Commit {
            sha: "gl1".to_string(),
            message: "gl commit".to_string(),
            author: "gl".to_string(),
        }])
    }
}

impl IssueStore for GitlabStub {
    fn list_issues(
        &self,
        _full_name: &str,
        _state: Option<&str>,
    ) -> Result<Vec<Issue>, CodeportError> {
        Ok(vec![])
    }

    fn get_issue(&self, _full_name: &str, number: u64) -> Result<Issue, CodeportError> {
        Ok(Issue {
            id: number,
            number,
            title: "gl issue".to_string(),
            state: codeport_core::entities::IssueState::Open,
            labels: vec![],
        })
    }

    fn list_comments(
        &self,
        _full_name: &str,
        _number: u64,
    ) -> Result<Vec<IssueComment>, CodeportError> {
        Ok(vec![])
    }

    fn create_issue(
        &self,
        _full_name: &str,
        title: &str,
        _body: Option<&str>,
    ) -> Result<Issue, CodeportError> {
        if title.trim().is_empty() {
            return Err(CodeportError::Validation(
                "issue title must not be empty".to_string(),
            ));
        }
        Ok(Issue {
            id: 99,
            number: 99,
            title: title.to_string(),
            state: codeport_core::entities::IssueState::Open,
            labels: vec![],
        })
    }

    fn set_issue_state(
        &self,
        _full_name: &str,
        number: u64,
        state: &str,
    ) -> Result<Issue, CodeportError> {
        let parsed = match state {
            "open" => codeport_core::entities::IssueState::Open,
            "closed" => codeport_core::entities::IssueState::Closed,
            _ => {
                return Err(CodeportError::Validation(format!(
                    "unknown issue state: {state}"
                )));
            }
        };
        Ok(Issue {
            id: number,
            number,
            title: "gl issue".to_string(),
            state: parsed,
            labels: vec![],
        })
    }

    fn create_comment(
        &self,
        _full_name: &str,
        _number: u64,
        body: &str,
    ) -> Result<IssueComment, CodeportError> {
        if body.trim().is_empty() {
            return Err(CodeportError::Validation(
                "comment body must not be empty".to_string(),
            ));
        }
        Ok(IssueComment {
            id: 7,
            body: body.to_string(),
            author: "gl".to_string(),
        })
    }
}

impl CiStore for GitlabStub {
    fn list_runs(&self, _full_name: &str) -> Result<Vec<Pipeline>, CodeportError> {
        Ok(vec![])
    }

    fn get_run(&self, _full_name: &str, run_id: u64) -> Result<Pipeline, CodeportError> {
        Ok(Pipeline {
            id: run_id,
            status: codeport_core::entities::PipelineStatus::Queued,
            conclusion: None,
            run_number: run_id,
        })
    }

    fn list_jobs(&self, _full_name: &str, _run_id: u64) -> Result<Vec<CiJob>, CodeportError> {
        Ok(vec![])
    }

    fn retry_run(&self, _full_name: &str, _run_id: u64) -> Result<(), CodeportError> {
        Ok(())
    }
}
