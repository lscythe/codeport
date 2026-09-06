use codeport_core::error::CodeportError;

pub struct GithubClient {
    token: String,
}

impl std::fmt::Debug for GithubClient {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("GithubClient").finish_non_exhaustive()
    }
}

impl GithubClient {
    pub fn new(token: String) -> Result<Self, CodeportError> {
        if token.trim().is_empty() {
            return Err(CodeportError::Auth);
        }
        Ok(Self { token })
    }

    pub fn auth_header(&self) -> String {
        format!("Bearer {}", self.token)
    }

    pub fn repo_path(owner: &str, repo: &str) -> String {
        format!("{owner}/{repo}")
    }

    pub fn map_status(status: u16, message: &str, rate_reset_at: Option<String>) -> CodeportError {
        match status {
            401 => CodeportError::Auth,
            403 if rate_reset_at.is_some() => CodeportError::RateLimited {
                reset_at: rate_reset_at.unwrap_or_default(),
            },
            403 => CodeportError::Auth,
            404 => CodeportError::NotFound,
            422 => CodeportError::Validation(message.to_string()),
            _ => CodeportError::Network(message.to_string()),
        }
    }
}
