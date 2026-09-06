use codeport_core::entities::{CiJob, Pipeline};
use codeport_core::error::CodeportError;
use serde::Deserialize;

#[derive(Deserialize)]
struct RunsEnvelope {
    #[serde(default, rename = "workflow_runs")]
    runs: Vec<Pipeline>,
}

#[derive(Deserialize)]
struct JobsEnvelope {
    #[serde(default)]
    jobs: Vec<CiJob>,
}

pub fn list_runs_url(full_name: &str) -> String {
    format!("https://api.github.com/repos/{full_name}/actions/runs?per_page=30")
}

pub fn get_run_url(full_name: &str, run_id: u64) -> String {
    format!("https://api.github.com/repos/{full_name}/actions/runs/{run_id}")
}

pub fn list_jobs_url(full_name: &str, run_id: u64) -> String {
    format!("https://api.github.com/repos/{full_name}/actions/runs/{run_id}/jobs?per_page=30")
}

pub fn retry_run_url(full_name: &str, run_id: u64) -> String {
    format!("https://api.github.com/repos/{full_name}/actions/runs/{run_id}/rerun-failed-jobs")
}

pub fn parse_runs(body: String) -> Result<Vec<Pipeline>, CodeportError> {
    let envelope: RunsEnvelope =
        serde_json::from_str(&body).map_err(|e| CodeportError::Network(e.to_string()))?;
    Ok(envelope.runs)
}

pub fn parse_run(body: String) -> Result<Pipeline, CodeportError> {
    serde_json::from_str(&body).map_err(|e| CodeportError::Network(e.to_string()))
}

pub fn parse_jobs(body: String) -> Result<Vec<CiJob>, CodeportError> {
    let envelope: JobsEnvelope =
        serde_json::from_str(&body).map_err(|e| CodeportError::Network(e.to_string()))?;
    Ok(envelope.jobs)
}
