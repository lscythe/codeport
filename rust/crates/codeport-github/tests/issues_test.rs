use codeport_github::issues::{
    create_comment_body, create_issue_body, list_comments_url, list_issues_url, parse_comments,
    parse_issue, parse_issues,
};

#[test]
fn parses_repo_issues_list_payload() {
    let payload = serde_json::json!([
        {"id": 1, "number": 1347, "title": "Found a bug", "state": "open", "labels": ["bug"]},
        {"id": 2, "number": 1348, "title": "Fixed", "state": "closed", "labels": []}
    ]);

    let issues = parse_issues(payload.to_string()).expect("issues parse");

    assert_eq!(issues.len(), 2);
    assert_eq!(issues[0].number, 1347);
    assert_eq!(issues[1].title, "Fixed");
}

#[test]
fn rejects_malformed_issues_payload() {
    let err = parse_issues("nope".to_string()).expect_err("malformed must fail");
    assert!(err.to_string().contains("network"));
}

#[test]
fn issues_url_targets_repo_with_open_state() {
    assert_eq!(
        list_issues_url("octocat/Hello-World", None),
        "https://api.github.com/repos/octocat/Hello-World/issues?state=open&per_page=30"
    );
}

#[test]
fn issues_url_passes_closed_state() {
    assert_eq!(
        list_issues_url("octocat/Hello-World", Some("closed")),
        "https://api.github.com/repos/octocat/Hello-World/issues?state=closed&per_page=30"
    );
}

#[test]
fn comments_url_targets_issue_comments() {
    assert_eq!(
        list_comments_url("o/r", 7),
        "https://api.github.com/repos/o/r/issues/7/comments?per_page=30"
    );
}

#[test]
fn parses_single_issue_payload() {
    let payload = serde_json::json!({
        "id": 1, "number": 7, "title": "Bug", "state": "open", "labels": []
    });

    let issue = parse_issue(payload.to_string()).expect("issue parses");
    assert_eq!(issue.number, 7);
}

#[test]
fn parses_comments_payload() {
    let payload = serde_json::json!([{"id": 5, "body": "Hi", "user": {"login": "a"}}]);

    let comments = parse_comments(payload.to_string()).expect("comments parse");
    assert_eq!(comments.len(), 1);
    assert_eq!(comments[0].body, "Hi");
}

#[test]
fn create_issue_body_rejects_empty_title() {
    let err = create_issue_body("  ", None).expect_err("empty title must fail");
    assert!(err.to_string().contains("invalid"));
}

#[test]
fn create_issue_body_serializes_title_and_body() {
    let body = create_issue_body("Bug", Some("details")).expect("body builds");
    assert!(body.contains("Bug"));
    assert!(body.contains("details"));
}

#[test]
fn create_comment_body_rejects_empty_body() {
    let err = create_comment_body("  ").expect_err("empty body must fail");
    assert!(err.to_string().contains("invalid"));
}
