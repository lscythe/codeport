use codeport_core::entities::Pipeline;
use codeport_core::error::CodeportError;
use serde::Deserialize;

#[derive(Deserialize)]
struct RunsEnvelope {
    #[serde(default, rename = "workflow_runs")]
    runs: Vec<Pipeline>,
}

pub fn list_runs_url(full_name: &str) -> String {
    format!("https://api.github.com/repos/{full_name}/actions/runs?per_page=30")
}

pub fn retry_run_url(full_name: &str, run_id: u64) -> String {
    format!("https://api.github.com/repos/{full_name}/actions/runs/{run_id}/rerun-failed-jobs")
}

pub fn parse_runs(body: String) -> Result<Vec<Pipeline>, CodeportError> {
    let envelope: RunsEnvelope =
        serde_json::from_str(&body).map_err(|e| CodeportError::Network(e.to_string()))?;
    Ok(envelope.runs)
}
