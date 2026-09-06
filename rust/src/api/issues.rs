use super::{validate_full_name, Issue, IssueComment};
use codeport_core::error::CodeportError;
use codeport_github::http::BlockingHttp;
use codeport_github::store::GithubStore;

pub fn github_list_issues(
    token: String,
    full_name: String,
    state: Option<String>,
) -> Result<Vec<Issue>, CodeportError> {
    validate_full_name(&full_name)?;
    let store = GithubStore::new(token, BlockingHttp::new())?;
    store.list_issues(&full_name, state.as_deref())
}

pub fn github_get_issue(
    token: String,
    full_name: String,
    number: u64,
) -> Result<Issue, CodeportError> {
    validate_full_name(&full_name)?;
    let store = GithubStore::new(token, BlockingHttp::new())?;
    store.get_issue(&full_name, number)
}

pub fn github_list_comments(
    token: String,
    full_name: String,
    number: u64,
) -> Result<Vec<IssueComment>, CodeportError> {
    validate_full_name(&full_name)?;
    let store = GithubStore::new(token, BlockingHttp::new())?;
    store.list_comments(&full_name, number)
}

pub fn github_create_issue(
    token: String,
    full_name: String,
    title: String,
    body: Option<String>,
) -> Result<Issue, CodeportError> {
    validate_full_name(&full_name)?;
    let store = GithubStore::new(token, BlockingHttp::new())?;
    store.create_issue(&full_name, &title, body.as_deref())
}

pub fn github_close_issue(
    token: String,
    full_name: String,
    number: u64,
) -> Result<Issue, CodeportError> {
    validate_full_name(&full_name)?;
    let store = GithubStore::new(token, BlockingHttp::new())?;
    store.close_issue(&full_name, number)
}

pub fn github_reopen_issue(
    token: String,
    full_name: String,
    number: u64,
) -> Result<Issue, CodeportError> {
    validate_full_name(&full_name)?;
    let store = GithubStore::new(token, BlockingHttp::new())?;
    store.reopen_issue(&full_name, number)
}

pub fn github_create_comment(
    token: String,
    full_name: String,
    number: u64,
    body: String,
) -> Result<IssueComment, CodeportError> {
    validate_full_name(&full_name)?;
    let store = GithubStore::new(token, BlockingHttp::new())?;
    store.create_comment(&full_name, number, &body)
}

#[cfg(test)]
mod tests {
    use super::github_list_issues;

    #[test]
    fn list_issues_rejects_empty_token() {
        let err = github_list_issues(String::new(), "octocat/Hello-World".to_string(), None)
            .expect_err("empty token must fail");
        assert_eq!(err.to_string(), "authentication failed");
    }

    #[test]
    fn list_issues_rejects_malformed_full_name() {
        let err = github_list_issues("ghp_test".to_string(), "not-a-full-name".to_string(), None)
            .expect_err("malformed name must fail");
        assert!(err.to_string().contains("invalid"));
    }

    #[test]
    fn get_issue_rejects_empty_token() {
        let err = super::github_get_issue(String::new(), "o/r".to_string(), 7)
            .expect_err("empty token must fail");
        assert_eq!(err.to_string(), "authentication failed");
    }

    #[test]
    fn create_issue_rejects_empty_title() {
        let err = super::github_create_issue(
            "ghp_test".to_string(),
            "o/r".to_string(),
            "  ".to_string(),
            None,
        )
        .expect_err("empty title must fail");
        assert!(err.to_string().contains("invalid"));
    }

    #[test]
    fn create_comment_rejects_empty_body() {
        let err = super::github_create_comment(
            "ghp_test".to_string(),
            "o/r".to_string(),
            7,
            "  ".to_string(),
        )
        .expect_err("empty body must fail");
        assert!(err.to_string().contains("invalid"));
    }
}
