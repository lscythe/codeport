use codeport_core::entities::{CiJob, Commit, Issue, IssueComment, Pipeline, Repo};
use codeport_core::error::CodeportError;
use codeport_core::traits::{CiStore, IssueStore, RepoStore};

struct StubStore {
    repo: Repo,
    commit: Commit,
    issue: Issue,
    comment: IssueComment,
    run: Pipeline,
    job: CiJob,
}

fn stub_store() -> StubStore {
    StubStore {
        repo: Repo {
            id: 1,
            full_name: "o/r".to_string(),
            private: false,
            stars: 0,
            default_branch: "main".to_string(),
        },
        commit: Commit {
            sha: "abc".to_string(),
            message: "Hi".to_string(),
            author: "a".to_string(),
        },
        issue: Issue {
            id: 1,
            number: 7,
            title: "Bug".to_string(),
            state: codeport_core::entities::IssueState::Open,
            labels: vec![],
        },
        comment: IssueComment {
            id: 5,
            body: "Hi".to_string(),
            author: "a".to_string(),
        },
        run: Pipeline {
            id: 12,
            status: codeport_core::entities::PipelineStatus::Completed,
            conclusion: Some(codeport_core::entities::PipelineConclusion::Success),
            run_number: 12,
        },
        job: CiJob {
            id: 9,
            name: "build".to_string(),
            status: codeport_core::entities::PipelineStatus::Completed,
            conclusion: Some(codeport_core::entities::PipelineConclusion::Success),
        },
    }
}

impl RepoStore for StubStore {
    fn list_repos(&self, _page: u32) -> Result<(Vec<Repo>, Option<u32>), CodeportError> {
        Ok((vec![self.repo.clone()], None))
    }

    fn get_repo(&self, _full_name: &str) -> Result<Repo, CodeportError> {
        Ok(self.repo.clone())
    }

    fn list_commits(&self, _full_name: &str) -> Result<Vec<Commit>, CodeportError> {
        Ok(vec![self.commit.clone()])
    }
}

impl IssueStore for StubStore {
    fn list_issues(
        &self,
        _full_name: &str,
        _state: Option<&str>,
    ) -> Result<Vec<Issue>, CodeportError> {
        Ok(vec![self.issue.clone()])
    }

    fn get_issue(&self, _full_name: &str, _number: u64) -> Result<Issue, CodeportError> {
        Ok(self.issue.clone())
    }

    fn list_comments(
        &self,
        _full_name: &str,
        _number: u64,
    ) -> Result<Vec<IssueComment>, CodeportError> {
        Ok(vec![self.comment.clone()])
    }

    fn create_issue(
        &self,
        _full_name: &str,
        title: &str,
        _body: Option<&str>,
    ) -> Result<Issue, CodeportError> {
        if title.trim().is_empty() {
            return Err(CodeportError::Validation(
                "issue title must not be empty".to_string(),
            ));
        }
        Ok(self.issue.clone())
    }

    fn set_issue_state(
        &self,
        _full_name: &str,
        _number: u64,
        _state: &str,
    ) -> Result<Issue, CodeportError> {
        Ok(self.issue.clone())
    }

    fn create_comment(
        &self,
        _full_name: &str,
        _number: u64,
        body: &str,
    ) -> Result<IssueComment, CodeportError> {
        if body.trim().is_empty() {
            return Err(CodeportError::Validation(
                "comment body must not be empty".to_string(),
            ));
        }
        Ok(self.comment.clone())
    }
}

impl CiStore for StubStore {
    fn list_runs(&self, _full_name: &str) -> Result<Vec<Pipeline>, CodeportError> {
        Ok(vec![self.run.clone()])
    }

    fn get_run(&self, _full_name: &str, _run_id: u64) -> Result<Pipeline, CodeportError> {
        Ok(self.run.clone())
    }

    fn list_jobs(&self, _full_name: &str, _run_id: u64) -> Result<Vec<CiJob>, CodeportError> {
        Ok(vec![self.job.clone()])
    }

    fn retry_run(&self, _full_name: &str, _run_id: u64) -> Result<(), CodeportError> {
        Ok(())
    }
}

#[test]
fn repo_store_contract_covers_details() {
    let store = stub_store();
    let (repos, next) = RepoStore::list_repos(&store, 1).expect("list works");
    assert_eq!(repos.len(), 1);
    assert_eq!(next, None);
    assert_eq!(store.get_repo("o/r").expect("get works").full_name, "o/r");
    assert_eq!(
        store.list_commits("o/r").expect("commits work")[0].sha,
        "abc"
    );
}

#[test]
fn issue_store_contract_covers_writes() {
    let store = stub_store();
    assert_eq!(store.list_issues("o/r", None).expect("list works").len(), 1);
    assert_eq!(store.get_issue("o/r", 7).expect("get works").number, 7);
    assert_eq!(
        store.list_comments("o/r", 7).expect("comments work")[0].body,
        "Hi"
    );
    assert!(store.create_issue("o/r", "  ", None).is_err());
    assert!(store.create_comment("o/r", 7, "  ").is_err());
}

#[test]
fn ci_store_contract_covers_details() {
    let store = stub_store();
    assert_eq!(store.list_runs("o/r").expect("list works").len(), 1);
    assert_eq!(store.get_run("o/r", 12).expect("get works").run_number, 12);
    assert_eq!(
        store.list_jobs("o/r", 12).expect("jobs work")[0].name,
        "build"
    );
    assert!(store.retry_run("o/r", 12).is_ok());
}
