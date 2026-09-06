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

    fn github_headers(auth: &str) -> reqwest::header::HeaderMap {
        let mut headers = reqwest::header::HeaderMap::new();
        headers.insert(
            reqwest::header::AUTHORIZATION,
            reqwest::header::HeaderValue::from_str(auth).expect("auth header value"),
        );
        headers.insert(
            reqwest::header::ACCEPT,
            reqwest::header::HeaderValue::from_static("application/vnd.github+json"),
        );
        headers.insert(
            "X-GitHub-Api-Version",
            reqwest::header::HeaderValue::from_static("2022-11-28"),
        );
        headers.insert(
            reqwest::header::CONTENT_TYPE,
            reqwest::header::HeaderValue::from_static("application/json"),
        );
        headers
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
            .headers(Self::github_headers(auth))
            .send()
            .map_err(|e| CodeportError::Network(e.to_string()))?;
        Self::response(res)
    }

    fn post_empty(&self, url: &str, auth: &str) -> Result<HttpResponse, CodeportError> {
        Self::validated(url, auth)?;
        let res = self
            .inner
            .post(url)
            .headers(Self::github_headers(auth))
            .body(String::new())
            .send()
            .map_err(|e| CodeportError::Network(e.to_string()))?;
        Self::response(res)
    }

    fn post_json(&self, url: &str, auth: &str, body: &str) -> Result<HttpResponse, CodeportError> {
        Self::validated(url, auth)?;
        let res = self
            .inner
            .post(url)
            .headers(Self::github_headers(auth))
            .body(body.to_string())
            .send()
            .map_err(|e| CodeportError::Network(e.to_string()))?;
        Self::response(res)
    }

    fn patch_json(&self, url: &str, auth: &str, body: &str) -> Result<HttpResponse, CodeportError> {
        Self::validated(url, auth)?;
        let res = self
            .inner
            .patch(url)
            .headers(Self::github_headers(auth))
            .body(body.to_string())
            .send()
            .map_err(|e| CodeportError::Network(e.to_string()))?;
        Self::response(res)
    }
}
