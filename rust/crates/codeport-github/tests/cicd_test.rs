use codeport_github::cicd::{list_runs_url, parse_runs, retry_run_url};

#[test]
fn parses_workflow_runs_payload() {
    let payload = serde_json::json!({
        "total_count": 1,
        "workflow_runs": [
            {"id": 296794546, "status": "completed", "conclusion": "failure", "run_number": 12}
        ]
    });

    let runs = parse_runs(payload.to_string()).expect("runs parse");

    assert_eq!(runs.len(), 1);
    assert_eq!(runs[0].run_number, 12);
}

#[test]
fn rejects_malformed_runs_payload() {
    let err = parse_runs("nope".to_string()).expect_err("malformed must fail");
    assert!(err.to_string().contains("network"));
}

#[test]
fn runs_url_targets_repo_actions() {
    assert_eq!(
        list_runs_url("octocat/Hello-World"),
        "https://api.github.com/repos/octocat/Hello-World/actions/runs?per_page=30"
    );
}

#[test]
fn retry_url_targets_rerun_failed_jobs() {
    assert_eq!(
        retry_run_url("octocat/Hello-World", 12),
        "https://api.github.com/repos/octocat/Hello-World/actions/runs/12/rerun-failed-jobs"
    );
}
