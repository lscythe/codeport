use codeport_github::issues::{list_issues_url, parse_issues};

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
