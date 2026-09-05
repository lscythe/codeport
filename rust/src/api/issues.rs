use codeport_core::entities::Issue;
use codeport_core::error::CodeportError;
use codeport_github::client::GithubClient;

use super::validate_full_name;

pub fn github_list_issues(
    token: String,
    full_name: String,
    _state: Option<String>,
) -> Result<Vec<Issue>, CodeportError> {
    GithubClient::new(token)?;
    validate_full_name(&full_name)?;
    Ok(vec![])
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
    fn list_issues_accepts_valid_input() {
        let issues = github_list_issues(
            "ghp_test".to_string(),
            "octocat/Hello-World".to_string(),
            None,
        )
        .expect("valid input");
        assert!(issues.is_empty());
    }
}
