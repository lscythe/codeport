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
}
