use crate::entities::{CiJob, Commit, Issue, IssueComment, Pipeline, Repo};
use crate::error::CodeportError;

pub trait RepoStore {
    fn list_repos(&self, page: u32) -> Result<(Vec<Repo>, Option<u32>), CodeportError>;
    fn get_repo(&self, full_name: &str) -> Result<Repo, CodeportError>;
    fn list_commits(&self, full_name: &str) -> Result<Vec<Commit>, CodeportError>;
}

pub trait IssueStore {
    fn list_issues(
        &self,
        full_name: &str,
        state: Option<&str>,
    ) -> Result<Vec<Issue>, CodeportError>;
    fn get_issue(&self, full_name: &str, number: u64) -> Result<Issue, CodeportError>;
    fn list_comments(
        &self,
        full_name: &str,
        number: u64,
    ) -> Result<Vec<IssueComment>, CodeportError>;
    fn create_issue(
        &self,
        full_name: &str,
        title: &str,
        body: Option<&str>,
    ) -> Result<Issue, CodeportError>;
    fn set_issue_state(
        &self,
        full_name: &str,
        number: u64,
        state: &str,
    ) -> Result<Issue, CodeportError>;
    fn create_comment(
        &self,
        full_name: &str,
        number: u64,
        body: &str,
    ) -> Result<IssueComment, CodeportError>;
}

pub trait CiStore {
    fn list_runs(&self, full_name: &str) -> Result<Vec<Pipeline>, CodeportError>;
    fn get_run(&self, full_name: &str, run_id: u64) -> Result<Pipeline, CodeportError>;
    fn list_jobs(&self, full_name: &str, run_id: u64) -> Result<Vec<CiJob>, CodeportError>;
    fn retry_run(&self, full_name: &str, run_id: u64) -> Result<(), CodeportError>;
}
