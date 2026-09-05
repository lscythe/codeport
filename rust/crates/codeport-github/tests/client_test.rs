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
