use codeport_core::error::CodeportError;
use codeport_github::client::GithubClient;

pub fn validate_token(token: String) -> Result<(), CodeportError> {
    GithubClient::new(token)?;
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::validate_token;

    #[test]
    fn validate_token_rejects_empty() {
        let err = validate_token(String::new()).expect_err("empty token must fail");
        assert_eq!(err.to_string(), "authentication failed");
    }

    #[test]
    fn validate_token_rejects_blank() {
        let err = validate_token("   ".to_string()).expect_err("blank token must fail");
        assert_eq!(err.to_string(), "authentication failed");
    }

    #[test]
    fn validate_token_accepts_pat() {
        validate_token("ghp_test".to_string()).expect("valid token");
    }
}
