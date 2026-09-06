use codeport_core::error::CodeportError;
use codeport_github::store::{GithubStore, HttpClient, HttpResponse};

#[cfg(test)]
mod test_double {
    use super::*;

    type Handler = Box<dyn Fn(&str, &str) -> Result<HttpResponse, CodeportError> + Send + Sync>;

    pub struct Stub {
        pub on_get: Handler,
        pub on_post: Handler,
    }

    impl HttpClient for Stub {
        fn get(&self, url: &str, auth: &str) -> Result<HttpResponse, CodeportError> {
            (self.on_get)(url, auth)
        }

        fn post_empty(&self, url: &str, auth: &str) -> Result<HttpResponse, CodeportError> {
            (self.on_post)(url, auth)
        }
    }

    pub fn ok(body: &str) -> HttpResponse {
        HttpResponse {
            status: 200,
            body: body.to_string(),
            rate_reset_at: None,
            next_page: None,
        }
    }

    pub fn fail(status: u16, body: &str) -> HttpResponse {
        HttpResponse {
            status,
            body: body.to_string(),
            rate_reset_at: None,
            next_page: None,
        }
    }
}

#[test]
fn store_rejects_empty_token() {
    let stub = test_double::Stub {
        on_get: Box::new(|_, _| unreachable!()),
        on_post: Box::new(|_, _| unreachable!()),
    };
    let err = GithubStore::new(String::new(), stub).expect_err("empty token must fail");
    assert_eq!(err, CodeportError::Auth);
}

#[test]
fn store_sends_bearer_token_on_list_repos() {
    use std::sync::{Arc, Mutex};
    let seen = Arc::new(Mutex::new(String::new()));
    let seen_clone = seen.clone();
    let stub = test_double::Stub {
        on_get: Box::new(move |_, auth| {
            *seen_clone.lock().unwrap() = auth.to_string();
            Ok(test_double::ok("[]"))
        }),
        on_post: Box::new(|_, _| unreachable!()),
    };
    let store = GithubStore::new("ghp_test".to_string(), stub).expect("valid token");
    store.list_repos(1).expect("list works");
    assert_eq!(*seen.lock().unwrap(), "Bearer ghp_test");
}

#[test]
fn store_returns_repos_and_next_page() {
    let stub = test_double::Stub {
        on_get: Box::new(|url, _| {
            assert!(url.contains("page=2"));
            Ok(HttpResponse {
                status: 200,
                body: r#"[{"id":1,"full_name":"o/r","private":false}]"#.to_string(),
                rate_reset_at: None,
                next_page: Some(3),
            })
        }),
        on_post: Box::new(|_, _| unreachable!()),
    };
    let store = GithubStore::new("t".to_string(), stub).expect("valid token");
    let (repos, next) = store.list_repos(2).expect("list works");
    assert_eq!(repos.len(), 1);
    assert_eq!(next, Some(3));
}

#[test]
fn store_maps_401_to_auth_error() {
    let stub = test_double::Stub {
        on_get: Box::new(|_, _| Ok(test_double::fail(401, "Bad credentials"))),
        on_post: Box::new(|_, _| unreachable!()),
    };
    let store = GithubStore::new("t".to_string(), stub).expect("valid token");
    let err = store.list_repos(1).expect_err("401 must fail");
    assert_eq!(err, CodeportError::Auth);
}

#[test]
fn store_lists_issues_for_repo() {
    let stub = test_double::Stub {
        on_get: Box::new(|url, _| {
            assert!(url.contains("octocat/Hello-World/issues"));
            Ok(test_double::ok(
                r#"[{"id":1,"number":7,"title":"Bug","state":"open","labels":[]}]"#,
            ))
        }),
        on_post: Box::new(|_, _| unreachable!()),
    };
    let store = GithubStore::new("t".to_string(), stub).expect("valid token");
    let issues = store
        .list_issues("octocat/Hello-World", None)
        .expect("list works");
    assert_eq!(issues[0].number, 7);
}

#[test]
fn store_lists_runs_for_repo() {
    let stub = test_double::Stub {
        on_get: Box::new(|url, _| {
            assert!(url.contains("/actions/runs"));
            Ok(test_double::ok(
                r#"{"workflow_runs":[{"id":1,"status":"completed","conclusion":"failure","run_number":12}]}"#,
            ))
        }),
        on_post: Box::new(|_, _| unreachable!()),
    };
    let store = GithubStore::new("t".to_string(), stub).expect("valid token");
    let runs = store.list_runs("octocat/Hello-World").expect("list works");
    assert_eq!(runs[0].run_number, 12);
}

#[test]
fn store_retry_succeeds_on_201() {
    let stub = test_double::Stub {
        on_get: Box::new(|_, _| unreachable!()),
        on_post: Box::new(|url, _| {
            assert!(url.ends_with("/rerun-failed-jobs"));
            Ok(HttpResponse {
                status: 201,
                body: String::new(),
                rate_reset_at: None,
                next_page: None,
            })
        }),
    };
    let store = GithubStore::new("t".to_string(), stub).expect("valid token");
    store.retry_run("o/r", 12).expect("retry works");
}

#[test]
fn store_retry_maps_404_to_not_found() {
    let stub = test_double::Stub {
        on_get: Box::new(|_, _| unreachable!()),
        on_post: Box::new(|_, _| Ok(test_double::fail(404, "Not Found"))),
    };
    let store = GithubStore::new("t".to_string(), stub).expect("valid token");
    let err = store.retry_run("o/r", 9).expect_err("404 must fail");
    assert_eq!(err, CodeportError::NotFound);
}
