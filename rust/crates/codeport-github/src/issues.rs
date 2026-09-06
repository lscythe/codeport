use codeport_core::entities::Issue;
use codeport_core::error::CodeportError;

pub fn list_issues_url(full_name: &str, state: Option<&str>) -> String {
    let state = state.unwrap_or("open");
    format!("https://api.github.com/repos/{full_name}/issues?state={state}&per_page=30")
}

pub fn parse_issues(body: String) -> Result<Vec<Issue>, CodeportError> {
    serde_json::from_str(&body).map_err(|e| CodeportError::Network(e.to_string()))
}
