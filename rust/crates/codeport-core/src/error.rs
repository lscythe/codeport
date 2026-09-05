use std::fmt;

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum CodeportError {
    Auth,
    Network(String),
    RateLimited { reset_at: u64 },
    NotFound,
    Validation(String),
}

impl CodeportError {
    pub fn is_retryable(&self) -> bool {
        matches!(self, CodeportError::RateLimited { .. })
    }
}

impl fmt::Display for CodeportError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            CodeportError::Auth => write!(f, "authentication failed"),
            CodeportError::Network(msg) => write!(f, "network error: {msg}"),
            CodeportError::RateLimited { reset_at } => {
                write!(f, "rate limited, retry after {reset_at}")
            }
            CodeportError::NotFound => write!(f, "resource not found"),
            CodeportError::Validation(msg) => write!(f, "invalid input: {msg}"),
        }
    }
}

impl std::error::Error for CodeportError {}
