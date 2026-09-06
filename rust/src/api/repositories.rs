use super::RepoPage;
use codeport_core::error::CodeportError;
use codeport_github::http::BlockingHttp;
use codeport_github::store::GithubStore;

pub fn github_list_repos(token: String, page: u32) -> Result<RepoPage, CodeportError> {
    let store = GithubStore::new(token, BlockingHttp::new())?;
    let (repos, next_page) = store.list_repos(page)?;
    Ok(RepoPage { repos, next_page })
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
}
