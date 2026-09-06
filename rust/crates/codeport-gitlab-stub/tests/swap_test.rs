use codeport_core::traits::{CiStore, IssueStore, RepoStore};
use codeport_gitlab_stub::GitlabStub;

fn browse<R: RepoStore, I: IssueStore, C: CiStore>(repos: &R, issues: &I, ci: &C) -> String {
    let repo = repos.get_repo("group/project").expect("get works");
    let issue = issues.get_issue("group/project", 1).expect("get works");
    let run = ci.get_run("group/project", 3).expect("get works");
    format!("{}|{}|{}", repo.full_name, issue.number, run.id)
}

#[test]
fn second_provider_satisfies_same_contract() {
    let stub = GitlabStub::new("gl");
    assert_eq!(browse(&stub, &stub, &stub), "gl/group/project|1|3");
}

#[test]
fn both_providers_share_validation_rules() {
    let stub = GitlabStub::new("gl");
    assert!(stub.create_issue("g/p", "  ", None).is_err());
    assert!(stub.create_comment("g/p", 1, "  ").is_err());
    assert!(stub.set_issue_state("g/p", 1, "weird").is_err());
}
