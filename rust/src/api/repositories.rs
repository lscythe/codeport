use codeport_core::entities::Repo;
use codeport_core::error::CodeportError;
use codeport_github::client::GithubClient;

pub fn github_list_repos(token: String, page: u32) -> Result<Vec<Repo>, CodeportError> {
    GithubClient::new(token)?;
    if page == 0 {
        return Err(CodeportError::Validation(
            "page must start at 1".to_string(),
        ));
    }
    Ok(vec![])
}

#[cfg(test)]
mod tests {
    use super::github_list_repos;

    #[test]
    fn list_repos_rejects_empty_token() {
        let err = github_list_repos(String::new(), 1).expect_err("empty token must fail");
        assert_eq!(err.to_string(), "authentication failed");
    }

    #[test]
    fn list_repos_rejects_zero_page() {
        let err = github_list_repos("ghp_test".to_string(), 0).expect_err("page 0 must fail");
        assert!(err.to_string().contains("invalid"));
    }

    #[test]
    fn list_repos_accepts_valid_input() {
        let repos = github_list_repos("ghp_test".to_string(), 1).expect("valid input");
        assert!(repos.is_empty());
    }
}
