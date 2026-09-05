use codeport_core::entities::PipelineConclusion;
use codeport_core::entities::PipelineStatus;
use codeport_core::entities::{Issue, Pipeline, Repo};
use codeport_core::error::CodeportError;

fn only_failed_runs_can_retry(run: &Pipeline) -> Result<(), CodeportError> {
    let failed = run.status == PipelineStatus::Completed
        && run.conclusion == Some(PipelineConclusion::Failure);
    if failed {
        Ok(())
    } else {
        Err(CodeportError::Validation(
            "only failed runs can be retried".to_string(),
        ))
    }
}

fn open_issues_first(mut issues: Vec<Issue>) -> Vec<Issue> {
    issues.sort_by_key(|issue| issue.state != codeport_core::entities::IssueState::Open);
    issues
}

#[test]
fn retry_rule_rejects_non_failed_runs() {
    let queued = Pipeline {
        id: 1,
        status: PipelineStatus::Queued,
        conclusion: None,
        run_number: 1,
    };
    let succeeded = Pipeline {
        id: 2,
        status: PipelineStatus::Completed,
        conclusion: Some(PipelineConclusion::Success),
        run_number: 2,
    };
    let failed = Pipeline {
        id: 3,
        status: PipelineStatus::Completed,
        conclusion: Some(PipelineConclusion::Failure),
        run_number: 3,
    };

    assert!(only_failed_runs_can_retry(&queued).is_err());
    assert!(only_failed_runs_can_retry(&succeeded).is_err());
    assert!(only_failed_runs_can_retry(&failed).is_ok());
}

#[test]
fn open_issues_sort_before_closed() {
    use codeport_core::entities::IssueState;
    let closed = Issue {
        id: 1,
        number: 1,
        title: "old".to_string(),
        state: IssueState::Closed,
        labels: vec![],
    };
    let open = Issue {
        id: 2,
        number: 2,
        title: "new".to_string(),
        state: IssueState::Open,
        labels: vec![],
    };

    let sorted = open_issues_first(vec![closed.clone(), open.clone()]);
    assert_eq!(sorted, vec![open, closed]);
}

#[test]
fn repo_identity_comes_from_full_name() {
    let repo = Repo {
        id: 1,
        full_name: "octocat/Hello-World".to_string(),
        private: false,
        stars: 0,
        default_branch: "main".to_string(),
    };
    assert!(repo.full_name.contains('/'));
}
