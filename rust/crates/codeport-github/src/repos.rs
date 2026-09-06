use codeport_core::entities::Repo;
use codeport_core::error::CodeportError;

pub fn list_repos_url(page: u32) -> String {
    format!("https://api.github.com/user/repos?page={page}&per_page=30")
}

pub fn parse_repos(body: String) -> Result<Vec<Repo>, CodeportError> {
    serde_json::from_str(&body).map_err(|e| CodeportError::Network(e.to_string()))
}
