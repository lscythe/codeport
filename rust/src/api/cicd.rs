use codeport_core::entities::Pipeline;
use codeport_core::error::CodeportError;
use codeport_github::client::GithubClient;

use super::validate_full_name;

pub fn github_list_runs(token: String, full_name: String) -> Result<Vec<Pipeline>, CodeportError> {
    GithubClient::new(token)?;
    validate_full_name(&full_name)?;
    Ok(vec![])
}

pub fn github_retry_run(token: String, _run_id: u64) -> Result<(), CodeportError> {
    GithubClient::new(token)?;
    Ok(())
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
        let err = github_retry_run(String::new(), 1).expect_err("empty token must fail");
        assert_eq!(err.to_string(), "authentication failed");
    }

    #[test]
    fn retry_run_accepts_valid_input() {
        github_retry_run("ghp_test".to_string(), 1).expect("valid input");
    }
}
