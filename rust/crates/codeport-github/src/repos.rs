use codeport_core::entities::{Commit, Repo};
use codeport_core::error::CodeportError;

pub fn list_repos_url(page: u32) -> String {
    format!("https://api.github.com/user/repos?page={page}&per_page=30")
}

pub fn get_repo_url(full_name: &str) -> String {
    format!("https://api.github.com/repos/{full_name}")
}

pub fn list_commits_url(full_name: &str) -> String {
    format!("https://api.github.com/repos/{full_name}/commits?per_page=30")
}

pub fn parse_repos(body: String) -> Result<Vec<Repo>, CodeportError> {
    serde_json::from_str(&body).map_err(|e| CodeportError::Network(e.to_string()))
}

pub fn parse_repo(body: String) -> Result<Repo, CodeportError> {
    serde_json::from_str(&body).map_err(|e| CodeportError::Network(e.to_string()))
}

pub fn parse_commits(body: String) -> Result<Vec<Commit>, CodeportError> {
    serde_json::from_str(&body).map_err(|e| CodeportError::Network(e.to_string()))
}
