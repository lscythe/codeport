use crate::pagination::next_page;
use crate::store::{HttpClient, HttpResponse};
use codeport_core::error::CodeportError;

pub struct BlockingHttp {
    inner: reqwest::blocking::Client,
}

impl BlockingHttp {
    pub fn new() -> Self {
        Self {
            inner: reqwest::blocking::Client::builder()
                .user_agent("codeport/0.1.0")
                .build()
                .expect("http client builds"),
        }
    }

    fn validated(url: &str, auth: &str) -> Result<(), CodeportError> {
        if url.trim().is_empty() {
            return Err(CodeportError::Validation(
                "url must not be empty".to_string(),
            ));
        }
        if auth.trim().is_empty() {
            return Err(CodeportError::Auth);
        }
        Ok(())
    }

    fn response(res: reqwest::blocking::Response) -> Result<HttpResponse, CodeportError> {
        let status = res.status().as_u16();
        let headers = res.headers().clone();
        let reset = headers
            .get("x-ratelimit-reset")
            .and_then(|v| v.to_str().ok())
            .map(str::to_string);
        let next = headers
            .get(reqwest::header::LINK)
            .and_then(|v| v.to_str().ok())
            .map(str::to_string);
        let body = res
            .text()
            .map_err(|e| CodeportError::Network(e.to_string()))?;
        Ok(HttpResponse {
            status,
            body,
            rate_reset_at: reset,
            next_page: next_page(&next),
        })
    }
}

impl Default for BlockingHttp {
    fn default() -> Self {
        Self::new()
    }
}

impl HttpClient for BlockingHttp {
    fn get(&self, url: &str, auth: &str) -> Result<HttpResponse, CodeportError> {
        Self::validated(url, auth)?;
        let res = self
            .inner
            .get(url)
            .header(reqwest::header::AUTHORIZATION, auth)
            .header(reqwest::header::ACCEPT, "application/vnd.github+json")
            .header("X-GitHub-Api-Version", "2022-11-28")
            .send()
            .map_err(|e| CodeportError::Network(e.to_string()))?;
        Self::response(res)
    }

    fn post_empty(&self, url: &str, auth: &str) -> Result<HttpResponse, CodeportError> {
        Self::validated(url, auth)?;
        let res = self
            .inner
            .post(url)
            .header(reqwest::header::AUTHORIZATION, auth)
            .header(reqwest::header::ACCEPT, "application/vnd.github+json")
            .header("X-GitHub-Api-Version", "2022-11-28")
            .body(String::new())
            .send()
            .map_err(|e| CodeportError::Network(e.to_string()))?;
        Self::response(res)
    }
}
