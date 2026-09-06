pub mod auth;
pub mod cicd;
pub mod issues;
pub mod repositories;
pub mod simple;

#[flutter_rust_bridge::frb(mirror(Repo))]
pub struct _RepoMirror {
    pub id: u64,
    pub full_name: String,
    pub private: bool,
    pub stars: u64,
    pub default_branch: String,
}

#[flutter_rust_bridge::frb(mirror(IssueState))]
pub enum _IssueStateMirror {
    Open,
    Closed,
}

#[flutter_rust_bridge::frb(mirror(Issue))]
pub struct _IssueMirror {
    pub id: u64,
    pub number: u64,
    pub title: String,
    pub state: crate::api::IssueState,
    pub labels: Vec<String>,
}

#[flutter_rust_bridge::frb(mirror(PipelineStatus))]
pub enum _PipelineStatusMirror {
    Queued,
    InProgress,
    Completed,
}

#[flutter_rust_bridge::frb(mirror(PipelineConclusion))]
pub enum _PipelineConclusionMirror {
    Success,
    Failure,
    Cancelled,
}

#[flutter_rust_bridge::frb(mirror(Pipeline))]
pub struct _PipelineMirror {
    pub id: u64,
    pub status: crate::api::PipelineStatus,
    pub conclusion: Option<crate::api::PipelineConclusion>,
    pub run_number: u64,
}

#[flutter_rust_bridge::frb(mirror(CodeportError))]
pub enum _CodeportErrorMirror {
    Auth,
    Network(String),
    RateLimited { reset_at: String },
    NotFound,
    Validation(String),
}

#[derive(Debug)]
pub struct RepoPage {
    pub repos: Vec<Repo>,
    pub next_page: Option<u32>,
}

pub use codeport_core::entities::{
    Issue, IssueState, Pipeline, PipelineConclusion, PipelineStatus, Repo,
};
pub use codeport_core::error::CodeportError;

pub(crate) fn validate_full_name(full_name: &str) -> Result<(), CodeportError> {
    let mut parts = full_name.split('/');
    let valid = full_name.contains('/')
        && parts.all(|part| !part.trim().is_empty())
        && full_name.chars().filter(|c| *c == '/').count() == 1;
    if valid {
        Ok(())
    } else {
        Err(CodeportError::Validation(format!(
            "invalid repository: {full_name}"
        )))
    }
}
