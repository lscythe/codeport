use crate::entities::{Issue, Pipeline, Repo};
use crate::error::CodeportError;

pub trait RepoStore {
    fn list_repos(&self, page: u32) -> Result<Vec<Repo>, CodeportError>;
    fn get_repo(&self, full_name: &str) -> Result<Repo, CodeportError>;
}

pub trait IssueStore {
    fn list_issues(
        &self,
        full_name: &str,
        state: Option<&str>,
    ) -> Result<Vec<Issue>, CodeportError>;
    fn get_issue(&self, full_name: &str, number: u64) -> Result<Issue, CodeportError>;
}

pub trait CiStore {
    fn list_runs(&self, full_name: &str) -> Result<Vec<Pipeline>, CodeportError>;
    fn retry_run(&self, run_id: u64) -> Result<(), CodeportError>;
}
