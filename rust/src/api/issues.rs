use codeport_core::entities::Issue;
use codeport_core::error::CodeportError;
use codeport_github::http::BlockingHttp;
use codeport_github::store::GithubStore;

use super::validate_full_name;

pub fn github_list_issues(
    token: String,
    full_name: String,
    state: Option<String>,
) -> Result<Vec<Issue>, CodeportError> {
    validate_full_name(&full_name)?;
    let store = GithubStore::new(token, BlockingHttp::new())?;
    store.list_issues(&full_name, state.as_deref())
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
}
