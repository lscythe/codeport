use super::{validate_full_name, CiJob, Pipeline};
use codeport_core::error::CodeportError;
use codeport_github::http::BlockingHttp;
use codeport_github::store::GithubStore;

pub fn github_list_runs(token: String, full_name: String) -> Result<Vec<Pipeline>, CodeportError> {
    validate_full_name(&full_name)?;
    let store = GithubStore::new(token, BlockingHttp::new())?;
    store.list_runs(&full_name)
}

pub fn github_get_run(
    token: String,
    full_name: String,
    run_id: u64,
) -> Result<Pipeline, CodeportError> {
    validate_full_name(&full_name)?;
    let store = GithubStore::new(token, BlockingHttp::new())?;
    store.get_run(&full_name, run_id)
}

pub fn github_list_jobs(
    token: String,
    full_name: String,
    run_id: u64,
) -> Result<Vec<CiJob>, CodeportError> {
    validate_full_name(&full_name)?;
    let store = GithubStore::new(token, BlockingHttp::new())?;
    store.list_jobs(&full_name, run_id)
}

pub fn github_retry_run(
    token: String,
    full_name: String,
    run_id: u64,
) -> Result<(), CodeportError> {
    validate_full_name(&full_name)?;
    let store = GithubStore::new(token, BlockingHttp::new())?;
    store.retry_run(&full_name, run_id)
}

#[cfg(test)]
mod tests {
    use super::{github_list_runs, github_retry_run};

    #[test]
    fn list_runs_rejects_empty_token() {
        let err = github_list_runs(String::new(), "octocat/Hello-World".to_string())
            .expect_err("empty token must fail");
        assert_eq!(err.to_string(), "authentication failed");
    }

    #[test]
    fn list_runs_rejects_malformed_full_name() {
        let err = github_list_runs("ghp_test".to_string(), "nope".to_string())
            .expect_err("malformed name must fail");
        assert!(err.to_string().contains("invalid"));
    }

    #[test]
    fn retry_run_rejects_empty_token() {
        let err = github_retry_run(String::new(), "o/r".to_string(), 1)
            .expect_err("empty token must fail");
        assert_eq!(err.to_string(), "authentication failed");
    }

    #[test]
    fn retry_run_rejects_malformed_full_name() {
        let err = github_retry_run("ghp_test".to_string(), "nope".to_string(), 1)
            .expect_err("malformed name must fail");
        assert!(err.to_string().contains("invalid"));
    }

    #[test]
    fn get_run_rejects_empty_token() {
        let err = super::github_get_run(String::new(), "o/r".to_string(), 1)
            .expect_err("empty token must fail");
        assert_eq!(err.to_string(), "authentication failed");
    }

    #[test]
    fn list_jobs_rejects_malformed_full_name() {
        let err = super::github_list_jobs("ghp_test".to_string(), "nope".to_string(), 1)
            .expect_err("malformed name must fail");
        assert!(err.to_string().contains("invalid"));
    }
}
