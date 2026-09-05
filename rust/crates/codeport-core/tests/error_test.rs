use codeport_core::error::CodeportError;

#[test]
fn only_rate_limited_errors_are_retryable() {
    assert!(CodeportError::RateLimited { reset_at: 1 }.is_retryable());
    assert!(!CodeportError::Auth.is_retryable());
    assert!(!CodeportError::Network("boom".to_string()).is_retryable());
    assert!(!CodeportError::NotFound.is_retryable());
    assert!(!CodeportError::Validation("bad".to_string()).is_retryable());
}

#[test]
fn errors_render_human_readable_messages() {
    assert_eq!(CodeportError::Auth.to_string(), "authentication failed");
    assert_eq!(CodeportError::NotFound.to_string(), "resource not found");
}
