use super::{validate_full_name, Commit, Repo, RepoPage};
use codeport_core::error::CodeportError;
use codeport_github::http::BlockingHttp;
use codeport_github::store::GithubStore;

pub fn github_list_repos(token: String, page: u32) -> Result<RepoPage, CodeportError> {
    let store = GithubStore::new(token, BlockingHttp::new())?;
    let (repos, next_page) = store.list_repos(page)?;
    Ok(RepoPage { repos, next_page })
}

pub fn github_get_repo(token: String, full_name: String) -> Result<Repo, CodeportError> {
    validate_full_name(&full_name)?;
    let store = GithubStore::new(token, BlockingHttp::new())?;
    store.get_repo(&full_name)
}

pub fn github_list_commits(token: String, full_name: String) -> Result<Vec<Commit>, CodeportError> {
    validate_full_name(&full_name)?;
    let store = GithubStore::new(token, BlockingHttp::new())?;
    store.list_commits(&full_name)
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
    fn get_repo_rejects_malformed_full_name() {
        let err = super::github_get_repo("ghp_test".to_string(), "nope".to_string())
            .expect_err("malformed name must fail");
        assert!(err.to_string().contains("invalid"));
    }

    #[test]
    fn list_commits_rejects_empty_token() {
        let err = super::github_list_commits(String::new(), "o/r".to_string())
            .expect_err("empty token must fail");
        assert_eq!(err.to_string(), "authentication failed");
    }
}
