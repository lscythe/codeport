pub mod auth;
pub mod cicd;
pub mod issues;
pub mod repositories;
pub mod simple;

use codeport_core::error::CodeportError;

pub(crate) fn validate_full_name(full_name: &str) -> Result<(), CodeportError> {
    let mut parts = full_name.split('/');
    let valid = full_name.contains('/')
        && parts.all(|part| !part.trim().is_empty())
        && full_name.chars().filter(|c| *c == '/').count() == 1;
    if valid {
        Ok(())
    } else {
        Err(CodeportError::Validation(format!(
            "invalid repository: {full_name}"
        )))
    }
}
