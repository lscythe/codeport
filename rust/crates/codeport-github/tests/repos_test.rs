use codeport_core::entities::Repo;
use codeport_github::repos::{parse_commits, parse_repo, parse_repos};

#[test]
fn parses_user_repos_list_payload() {
    let payload = serde_json::json!([
        {
            "id": 1296269,
            "full_name": "octocat/Hello-World",
            "private": false,
            "stargazers_count": 80,
            "default_branch": "main"
        },
        {
            "id": 1296270,
            "full_name": "octocat/Spoon-Knife",
            "private": true,
            "stargazers_count": 3,
            "default_branch": "main"
        }
    ]);

    let repos: Vec<Repo> = parse_repos(payload.to_string()).expect("repos parse");

    assert_eq!(repos.len(), 2);
    assert_eq!(repos[0].full_name, "octocat/Hello-World");
    assert!(!repos[0].private);
    assert_eq!(repos[1].stars, 3);
    assert!(repos[1].private);
}

#[test]
fn rejects_malformed_repos_payload() {
    let err = parse_repos("not json".to_string()).expect_err("malformed must fail");
    assert!(err.to_string().contains("network"));
}

#[test]
fn repos_url_targets_authenticated_user() {
    assert_eq!(
        codeport_github::repos::list_repos_url(1),
        "https://api.github.com/user/repos?page=1&per_page=30"
    );
}

#[test]
fn repo_urls_target_single_repo_and_commits() {
    assert_eq!(
        codeport_github::repos::get_repo_url("o/r"),
        "https://api.github.com/repos/o/r"
    );
    assert_eq!(
        codeport_github::repos::list_commits_url("o/r"),
        "https://api.github.com/repos/o/r/commits?per_page=30"
    );
}

#[test]
fn parses_single_repo_payload() {
    let payload = serde_json::json!({
        "id": 1,
        "full_name": "o/r",
        "private": false
    });

    let repo = parse_repo(payload.to_string()).expect("repo parses");
    assert_eq!(repo.full_name, "o/r");
}

#[test]
fn parses_commits_payload() {
    let payload = serde_json::json!([
        {"sha": "abc", "commit": {"message": "Hi", "author": {"name": "a"}}}
    ]);

    let commits = parse_commits(payload.to_string()).expect("commits parse");
    assert_eq!(commits.len(), 1);
    assert_eq!(commits[0].message, "Hi");
}
