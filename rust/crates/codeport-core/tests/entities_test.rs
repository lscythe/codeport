use codeport_core::entities::{
    CiJob, Commit, Issue, IssueComment, IssueState, Pipeline, PipelineConclusion, PipelineStatus,
    Repo,
};

#[test]
fn repo_maps_github_repository_payload() {
    let payload = serde_json::json!({
        "id": 1296269,
        "full_name": "octocat/Hello-World",
        "private": false,
        "stargazers_count": 80,
        "default_branch": "main"
    });

    let repo: Repo = serde_json::from_value(payload).expect("repo deserializes");

    assert_eq!(repo.id, 1296269);
    assert_eq!(repo.full_name, "octocat/Hello-World");
    assert!(!repo.private);
    assert_eq!(repo.stars, 80);
    assert_eq!(repo.default_branch, "main");
}

#[test]
fn issue_maps_issue_payload_with_state_and_labels() {
    let payload = serde_json::json!({
        "id": 1,
        "number": 1347,
        "title": "Found a bug",
        "state": "open",
        "labels": ["bug"]
    });

    let issue: Issue = serde_json::from_value(payload).expect("issue deserializes");

    assert_eq!(issue.number, 1347);
    assert_eq!(issue.title, "Found a bug");
    assert_eq!(issue.state, IssueState::Open);
    assert_eq!(issue.labels, vec!["bug".to_string()]);
}

#[test]
fn issue_state_parses_closed() {
    let state: IssueState =
        serde_json::from_value(serde_json::json!("closed")).expect("closed parses");
    assert_eq!(state, IssueState::Closed);
}

#[test]
fn pipeline_maps_completed_failure_run_payload() {
    let payload = serde_json::json!({
        "id": 296794546,
        "status": "completed",
        "conclusion": "failure",
        "run_number": 12
    });

    let run: Pipeline = serde_json::from_value(payload).expect("pipeline deserializes");

    assert_eq!(run.id, 296794546);
    assert_eq!(run.status, PipelineStatus::Completed);
    assert_eq!(run.conclusion, Some(PipelineConclusion::Failure));
    assert_eq!(run.run_number, 12);
}

#[test]
fn pipeline_allows_missing_conclusion_for_in_progress_runs() {
    let payload = serde_json::json!({
        "id": 296794547,
        "status": "in_progress",
        "conclusion": null,
        "run_number": 13
    });

    let run: Pipeline = serde_json::from_value(payload).expect("pipeline deserializes");

    assert_eq!(run.status, PipelineStatus::InProgress);
    assert_eq!(run.conclusion, None);
}

#[test]
fn commit_maps_github_commit_payload() {
    let payload = serde_json::json!({
        "sha": "abc123",
        "commit": {
            "message": "Fix bug",
            "author": {"name": "octocat"}
        }
    });

    let commit: Commit = serde_json::from_value(payload).expect("commit deserializes");

    assert_eq!(commit.sha, "abc123");
    assert_eq!(commit.message, "Fix bug");
    assert_eq!(commit.author, "octocat");
}

#[test]
fn issue_comment_maps_payload_with_defaults() {
    let payload = serde_json::json!({"id": 5});

    let comment: IssueComment = serde_json::from_value(payload).expect("comment deserializes");

    assert_eq!(comment.id, 5);
    assert_eq!(comment.body, "");
}

#[test]
fn ci_job_maps_payload() {
    let payload = serde_json::json!({
        "id": 9,
        "name": "build",
        "status": "completed",
        "conclusion": "success"
    });

    let job: CiJob = serde_json::from_value(payload).expect("job deserializes");

    assert_eq!(job.name, "build");
    assert_eq!(job.status, PipelineStatus::Completed);
}
