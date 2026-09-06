use codeport_core::error::CodeportError;
use codeport_core::traits::{CiStore, IssueStore, RepoStore};
use codeport_github::store::{GithubStore, HttpClient, HttpResponse};

#[cfg(test)]
mod test_double {
    use super::*;

    type Handler = Box<dyn Fn(&str, &str) -> Result<HttpResponse, CodeportError> + Send + Sync>;
    type JsonHandler =
        Box<dyn Fn(&str, &str, &str) -> Result<HttpResponse, CodeportError> + Send + Sync>;

    pub struct Stub {
        pub on_get: Handler,
        pub on_post: Handler,
        pub on_post_json: JsonHandler,
        pub on_patch_json: JsonHandler,
    }

    impl HttpClient for Stub {
        fn get(&self, url: &str, auth: &str) -> Result<HttpResponse, CodeportError> {
            (self.on_get)(url, auth)
        }

        fn post_empty(&self, url: &str, auth: &str) -> Result<HttpResponse, CodeportError> {
            (self.on_post)(url, auth)
        }

        fn post_json(
            &self,
            url: &str,
            auth: &str,
            body: &str,
        ) -> Result<HttpResponse, CodeportError> {
            (self.on_post_json)(url, auth, body)
        }

        fn patch_json(
            &self,
            url: &str,
            auth: &str,
            body: &str,
        ) -> Result<HttpResponse, CodeportError> {
            (self.on_patch_json)(url, auth, body)
        }
    }

    pub fn stub(on_get: Handler, on_post: Handler) -> Stub {
        stub_full(on_get, on_post, default_json(), default_json())
    }

    pub fn stub_full(
        on_get: Handler,
        on_post: Handler,
        on_post_json: JsonHandler,
        on_patch_json: JsonHandler,
    ) -> Stub {
        Stub {
            on_get,
            on_post,
            on_post_json,
            on_patch_json,
        }
    }

    fn default_json() -> JsonHandler {
        Box::new(|_, _, _| unreachable!())
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
    let stub = test_double::stub(
        Box::new(|_, _| unreachable!()),
        Box::new(|_, _| unreachable!()),
    );
    let err = GithubStore::new(String::new(), stub).expect_err("empty token must fail");
    assert_eq!(err, CodeportError::Auth);
}

#[test]
fn store_sends_bearer_token_on_list_repos() {
    use std::sync::{Arc, Mutex};
    let seen = Arc::new(Mutex::new(String::new()));
    let seen_clone = seen.clone();
    let stub = test_double::stub(
        Box::new(move |_, auth| {
            *seen_clone.lock().unwrap() = auth.to_string();
            Ok(test_double::ok("[]"))
        }),
        Box::new(|_, _| unreachable!()),
    );
    let store = GithubStore::new("ghp_test".to_string(), stub).expect("valid token");
    store.list_repos(1).expect("list works");
    assert_eq!(*seen.lock().unwrap(), "Bearer ghp_test");
}

#[test]
fn store_returns_repos_and_next_page() {
    let stub = test_double::stub(
        Box::new(|url, _| {
            assert!(url.contains("page=2"));
            Ok(HttpResponse {
                status: 200,
                body: r#"[{"id":1,"full_name":"o/r","private":false}]"#.to_string(),
                rate_reset_at: None,
                next_page: Some(3),
            })
        }),
        Box::new(|_, _| unreachable!()),
    );
    let store = GithubStore::new("t".to_string(), stub).expect("valid token");
    let (repos, next) = store.list_repos(2).expect("list works");
    assert_eq!(repos.len(), 1);
    assert_eq!(next, Some(3));
}

#[test]
fn store_maps_401_to_auth_error() {
    let stub = test_double::stub(
        Box::new(|_, _| Ok(test_double::fail(401, "Bad credentials"))),
        Box::new(|_, _| unreachable!()),
    );
    let store = GithubStore::new("t".to_string(), stub).expect("valid token");
    let err = store.list_repos(1).expect_err("401 must fail");
    assert_eq!(err, CodeportError::Auth);
}

#[test]
fn store_lists_issues_for_repo() {
    let stub = test_double::stub(
        Box::new(|url, _| {
            assert!(url.contains("octocat/Hello-World/issues"));
            Ok(test_double::ok(
                r#"[{"id":1,"number":7,"title":"Bug","state":"open","labels":[]}]"#,
            ))
        }),
        Box::new(|_, _| unreachable!()),
    );
    let store = GithubStore::new("t".to_string(), stub).expect("valid token");
    let issues = store
        .list_issues("octocat/Hello-World", None)
        .expect("list works");
    assert_eq!(issues[0].number, 7);
}

#[test]
fn store_lists_runs_for_repo() {
    let stub = test_double::stub(
        Box::new(|url, _| {
            assert!(url.contains("/actions/runs"));
            Ok(test_double::ok(
                r#"{"workflow_runs":[{"id":1,"status":"completed","conclusion":"failure","run_number":12}]}"#,
            ))
        }),
        Box::new(|_, _| unreachable!()),
    );
    let store = GithubStore::new("t".to_string(), stub).expect("valid token");
    let runs = store.list_runs("octocat/Hello-World").expect("list works");
    assert_eq!(runs[0].run_number, 12);
}

#[test]
fn store_retry_succeeds_on_201() {
    let stub = test_double::stub(
        Box::new(|_, _| unreachable!()),
        Box::new(|url, _| {
            assert!(url.ends_with("/rerun-failed-jobs"));
            Ok(HttpResponse {
                status: 201,
                body: String::new(),
                rate_reset_at: None,
                next_page: None,
            })
        }),
    );
    let store = GithubStore::new("t".to_string(), stub).expect("valid token");
    store.retry_run("o/r", 12).expect("retry works");
}

#[test]
fn store_retry_maps_404_to_not_found() {
    let stub = test_double::stub(
        Box::new(|_, _| unreachable!()),
        Box::new(|_, _| Ok(test_double::fail(404, "Not Found"))),
    );
    let store = GithubStore::new("t".to_string(), stub).expect("valid token");
    let err = store.retry_run("o/r", 9).expect_err("404 must fail");
    assert_eq!(err, CodeportError::NotFound);
}

#[test]
fn store_conforms_to_core_traits_through_generics() {
    fn browse<R: RepoStore, I: IssueStore, C: CiStore>(repos: &R, issues: &I, ci: &C) {
        let (all, _) = repos.list_repos(1).expect("list works");
        assert_eq!(all.len(), 1);
        assert_eq!(repos.get_repo("o/r").expect("get works").full_name, "o/r");
        assert_eq!(
            repos.list_commits("o/r").expect("commits work")[0].sha,
            "abc"
        );
        assert_eq!(issues.get_issue("o/r", 7).expect("get works").number, 7);
        assert_eq!(
            issues.list_comments("o/r", 7).expect("comments work").len(),
            1
        );
        assert_eq!(ci.get_run("o/r", 12).expect("get works").run_number, 12);
        assert_eq!(ci.list_jobs("o/r", 12).expect("jobs work")[0].name, "build");
    }

    let stub = test_double::stub(
        Box::new(|url, _| {
            let body = if url.contains("/commits") {
                r#"[{"sha":"abc","commit":{"message":"Hi","author":{"name":"a"}}}]"#
            } else if url.contains("/comments") {
                r#"[{"id":5,"body":"Hi"}]"#
            } else if url.contains("/jobs") {
                r#"{"jobs":[{"id":9,"name":"build","status":"completed","conclusion":"success"}]}"#
            } else if url.contains("/actions/runs/12") {
                r#"{"id":12,"status":"completed","conclusion":"success","run_number":12}"#
            } else if url.contains("/issues/7") {
                r#"{"id":1,"number":7,"title":"Bug","state":"open","labels":[]}"#
            } else if url.contains("/repos/o/r") {
                r#"{"id":1,"full_name":"o/r","private":false}"#
            } else {
                r#"[{"id":1,"full_name":"o/r","private":false}]"#
            };
            Ok(test_double::ok(body))
        }),
        Box::new(|_, _| unreachable!()),
    );
    let store = GithubStore::new("t".to_string(), stub).expect("valid token");
    browse(&store, &store, &store);
}

#[test]
fn store_rejects_unknown_issue_state() {
    let stub = test_double::stub(
        Box::new(|_, _| unreachable!()),
        Box::new(|_, _| unreachable!()),
    );
    let store = GithubStore::new("t".to_string(), stub).expect("valid token");
    let err = IssueStore::set_issue_state(&store, "o/r", 7, "weird")
        .expect_err("unknown state must fail");
    assert!(err.to_string().contains("invalid"));
}

#[test]
fn store_gets_single_repo() {
    let stub = test_double::stub(
        Box::new(|url, _| {
            assert!(url.ends_with("/repos/o/r"));
            Ok(test_double::ok(
                r#"{"id":1,"full_name":"o/r","private":false}"#,
            ))
        }),
        Box::new(|_, _| unreachable!()),
    );
    let store = GithubStore::new("t".to_string(), stub).expect("valid token");
    let repo = store.get_repo("o/r").expect("get works");
    assert_eq!(repo.full_name, "o/r");
}

#[test]
fn store_lists_commits_for_repo() {
    let stub = test_double::stub(
        Box::new(|url, _| {
            assert!(url.ends_with("/commits?per_page=30"));
            Ok(test_double::ok(
                r#"[{"sha":"abc","commit":{"message":"Hi","author":{"name":"a"}}}]"#,
            ))
        }),
        Box::new(|_, _| unreachable!()),
    );
    let store = GithubStore::new("t".to_string(), stub).expect("valid token");
    let commits = store.list_commits("o/r").expect("list works");
    assert_eq!(commits[0].sha, "abc");
    assert_eq!(commits[0].message, "Hi");
}

#[test]
fn store_gets_single_issue() {
    let stub = test_double::stub(
        Box::new(|url, _| {
            assert!(url.ends_with("/issues/7"));
            Ok(test_double::ok(
                r#"{"id":1,"number":7,"title":"Bug","state":"open","labels":[]}"#,
            ))
        }),
        Box::new(|_, _| unreachable!()),
    );
    let store = GithubStore::new("t".to_string(), stub).expect("valid token");
    let issue = store.get_issue("o/r", 7).expect("get works");
    assert_eq!(issue.number, 7);
}

#[test]
fn store_lists_comments_for_issue() {
    let stub = test_double::stub(
        Box::new(|url, _| {
            assert!(url.ends_with("/issues/7/comments?per_page=30"));
            Ok(test_double::ok(r#"[{"id":5,"body":"Hi"}]"#))
        }),
        Box::new(|_, _| unreachable!()),
    );
    let store = GithubStore::new("t".to_string(), stub).expect("valid token");
    let comments = store.list_comments("o/r", 7).expect("list works");
    assert_eq!(comments[0].body, "Hi");
}

#[test]
fn store_creates_issue_with_title() {
    let stub = test_double::stub_full(
        Box::new(|_, _| unreachable!()),
        Box::new(|_, _| unreachable!()),
        Box::new(|url, _, body| {
            assert!(url.ends_with("/repos/o/r/issues"));
            assert!(body.contains("Bug"));
            Ok(HttpResponse {
                status: 201,
                body: r#"{"id":1,"number":8,"title":"Bug","state":"open","labels":[]}"#.to_string(),
                rate_reset_at: None,
                next_page: None,
            })
        }),
        Box::new(|_, _, _| unreachable!()),
    );
    let store = GithubStore::new("t".to_string(), stub).expect("valid token");
    let issue = store
        .create_issue("o/r", "Bug", None)
        .expect("create works");
    assert_eq!(issue.number, 8);
}

#[test]
fn store_rejects_empty_issue_title() {
    let stub = test_double::stub(
        Box::new(|_, _| unreachable!()),
        Box::new(|_, _| unreachable!()),
    );
    let store = GithubStore::new("t".to_string(), stub).expect("valid token");
    let err = store
        .create_issue("o/r", "  ", None)
        .expect_err("empty title must fail");
    assert!(err.to_string().contains("invalid"));
}

#[test]
fn store_closes_and_reopens_issue() {
    let stub = test_double::stub_full(
        Box::new(|_, _| unreachable!()),
        Box::new(|_, _| unreachable!()),
        Box::new(|_, _, _| unreachable!()),
        Box::new(|url, _, body| {
            assert!(url.ends_with("/issues/7"));
            let state = if body.contains("closed") {
                "closed"
            } else {
                "open"
            };
            Ok(test_double::ok(&format!(
                r#"{{"id":1,"number":7,"title":"Bug","state":"{state}","labels":[]}}"#
            )))
        }),
    );
    let store = GithubStore::new("t".to_string(), stub).expect("valid token");
    let closed = store.close_issue("o/r", 7).expect("close works");
    assert_eq!(closed.state, codeport_core::entities::IssueState::Closed);
    let open = store.reopen_issue("o/r", 7).expect("reopen works");
    assert_eq!(open.state, codeport_core::entities::IssueState::Open);
}

#[test]
fn store_creates_comment_on_issue() {
    let stub = test_double::stub_full(
        Box::new(|_, _| unreachable!()),
        Box::new(|_, _| unreachable!()),
        Box::new(|url, _, body| {
            assert!(url.ends_with("/issues/7/comments"));
            assert!(body.contains("Hi"));
            Ok(HttpResponse {
                status: 201,
                body: r#"{"id":6,"body":"Hi"}"#.to_string(),
                rate_reset_at: None,
                next_page: None,
            })
        }),
        Box::new(|_, _, _| unreachable!()),
    );
    let store = GithubStore::new("t".to_string(), stub).expect("valid token");
    let comment = store.create_comment("o/r", 7, "Hi").expect("comment works");
    assert_eq!(comment.body, "Hi");
}

#[test]
fn store_gets_single_run() {
    let stub = test_double::stub(
        Box::new(|url, _| {
            assert!(url.ends_with("/actions/runs/12"));
            Ok(test_double::ok(
                r#"{"id":12,"status":"completed","conclusion":"success","run_number":12}"#,
            ))
        }),
        Box::new(|_, _| unreachable!()),
    );
    let store = GithubStore::new("t".to_string(), stub).expect("valid token");
    let run = store.get_run("o/r", 12).expect("get works");
    assert_eq!(run.run_number, 12);
}

#[test]
fn store_lists_jobs_for_run() {
    let stub = test_double::stub(
        Box::new(|url, _| {
            assert!(url.ends_with("/actions/runs/12/jobs?per_page=30"));
            Ok(test_double::ok(
                r#"{"jobs":[{"id":9,"name":"build","status":"completed","conclusion":"success"}]}"#,
            ))
        }),
        Box::new(|_, _| unreachable!()),
    );
    let store = GithubStore::new("t".to_string(), stub).expect("valid token");
    let jobs = store.list_jobs("o/r", 12).expect("list works");
    assert_eq!(jobs[0].name, "build");
}
