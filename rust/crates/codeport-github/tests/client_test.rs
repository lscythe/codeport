use codeport_core::error::CodeportError;
use codeport_github::client::GithubClient;

#[test]
fn rejects_empty_token_with_auth_error() {
    let err = GithubClient::new(String::new()).expect_err("empty token must fail");
    assert_eq!(err, CodeportError::Auth);
}

#[test]
fn rejects_blank_token_with_auth_error() {
    let err = GithubClient::new("   ".to_string()).expect_err("blank token must fail");
    assert_eq!(err, CodeportError::Auth);
}

#[test]
fn builds_bearer_auth_header() {
    let client = GithubClient::new("ghp_test".to_string()).expect("valid token");
    assert_eq!(client.auth_header(), "Bearer ghp_test");
}

#[test]
fn maps_401_to_auth_error() {
    let err = GithubClient::map_status(401, "Bad credentials", None);
    assert_eq!(err, CodeportError::Auth);
}

#[test]
fn maps_404_to_not_found() {
    let err = GithubClient::map_status(404, "Not Found", None);
    assert_eq!(err, CodeportError::NotFound);
}

#[test]
fn maps_403_with_zero_remaining_to_rate_limited() {
    let err = GithubClient::map_status(
        403,
        "rate limit exceeded",
        Some("1_700_000_000".to_string()),
    );
    assert_eq!(
        err,
        CodeportError::RateLimited {
            reset_at: "1_700_000_000".to_string()
        }
    );
    assert!(err.is_retryable());
}

#[test]
fn maps_403_without_rate_info_to_auth_error() {
    let err = GithubClient::map_status(403, "forbidden", None);
    assert_eq!(err, CodeportError::Auth);
}

#[test]
fn maps_422_to_validation_error() {
    let err = GithubClient::map_status(422, "Validation Failed", None);
    assert_eq!(
        err,
        CodeportError::Validation("Validation Failed".to_string())
    );
}

#[test]
fn maps_500_to_network_error() {
    let err = GithubClient::map_status(500, "boom", None);
    assert_eq!(err, CodeportError::Network("boom".to_string()));
}

#[test]
fn builds_full_repo_name_for_endpoints() {
    assert_eq!(
        GithubClient::repo_path("octocat", "Hello-World"),
        "octocat/Hello-World"
    );
}
