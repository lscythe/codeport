use codeport_core::error::CodeportError;
use codeport_github::http::BlockingHttp;
use codeport_github::store::HttpClient;

#[test]
fn blocking_http_rejects_empty_url() {
    let http = BlockingHttp::new();
    let err = http.get("", "Bearer t").expect_err("empty url must fail");
    assert!(matches!(err, CodeportError::Validation(_)));
}

#[test]
fn blocking_http_rejects_empty_auth() {
    let http = BlockingHttp::new();
    let err = http
        .get("https://api.github.com/user", "")
        .expect_err("empty auth must fail");
    assert_eq!(err, CodeportError::Auth);
}

#[test]
fn blocking_http_post_rejects_empty_url() {
    let http = BlockingHttp::new();
    let err = http
        .post_empty("", "Bearer t")
        .expect_err("empty url must fail");
    assert!(matches!(err, CodeportError::Validation(_)));
}
