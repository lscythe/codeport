use codeport_core::entities::{Issue, IssueComment};
use codeport_core::error::CodeportError;
use serde::Serialize;

pub fn list_issues_url(full_name: &str, state: Option<&str>) -> String {
    let state = state.unwrap_or("open");
    format!("https://api.github.com/repos/{full_name}/issues?state={state}&per_page=30")
}

pub fn get_issue_url(full_name: &str, number: u64) -> String {
    format!("https://api.github.com/repos/{full_name}/issues/{number}")
}

pub fn list_comments_url(full_name: &str, number: u64) -> String {
    format!("https://api.github.com/repos/{full_name}/issues/{number}/comments?per_page=30")
}

pub fn create_issue_url(full_name: &str) -> String {
    format!("https://api.github.com/repos/{full_name}/issues")
}

pub fn create_comment_url(full_name: &str, number: u64) -> String {
    format!("https://api.github.com/repos/{full_name}/issues/{number}/comments")
}

pub fn parse_issues(body: String) -> Result<Vec<Issue>, CodeportError> {
    serde_json::from_str(&body).map_err(|e| CodeportError::Network(e.to_string()))
}

pub fn parse_issue(body: String) -> Result<Issue, CodeportError> {
    serde_json::from_str(&body).map_err(|e| CodeportError::Network(e.to_string()))
}

pub fn parse_comments(body: String) -> Result<Vec<IssueComment>, CodeportError> {
    serde_json::from_str(&body).map_err(|e| CodeportError::Network(e.to_string()))
}

pub fn parse_comment(body: String) -> Result<IssueComment, CodeportError> {
    serde_json::from_str(&body).map_err(|e| CodeportError::Network(e.to_string()))
}

#[derive(Serialize)]
pub struct NewIssue<'a> {
    pub title: &'a str,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub body: Option<&'a str>,
}

pub fn create_issue_body(title: &str, body: Option<&str>) -> Result<String, CodeportError> {
    if title.trim().is_empty() {
        return Err(CodeportError::Validation(
            "issue title must not be empty".to_string(),
        ));
    }
    serde_json::to_string(&NewIssue { title, body })
        .map_err(|e| CodeportError::Network(e.to_string()))
}

#[derive(Serialize)]
pub struct NewComment<'a> {
    pub body: &'a str,
}

pub fn create_comment_body(body: &str) -> Result<String, CodeportError> {
    if body.trim().is_empty() {
        return Err(CodeportError::Validation(
            "comment body must not be empty".to_string(),
        ));
    }
    serde_json::to_string(&NewComment { body }).map_err(|e| CodeportError::Network(e.to_string()))
}
