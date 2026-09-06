use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct Repo {
    pub id: u64,
    pub full_name: String,
    pub private: bool,
    #[serde(default, rename = "stargazers_count")]
    pub stars: u64,
    #[serde(default = "default_branch")]
    pub default_branch: String,
}

fn default_branch() -> String {
    "main".to_string()
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "lowercase")]
pub enum IssueState {
    Open,
    Closed,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct Issue {
    pub id: u64,
    pub number: u64,
    pub title: String,
    pub state: IssueState,
    #[serde(default)]
    pub labels: Vec<String>,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum PipelineStatus {
    Queued,
    InProgress,
    Completed,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum PipelineConclusion {
    Success,
    Failure,
    Cancelled,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct Pipeline {
    pub id: u64,
    pub status: PipelineStatus,
    pub conclusion: Option<PipelineConclusion>,
    pub run_number: u64,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(from = "GithubCommitPayload")]
pub struct Commit {
    pub sha: String,
    pub message: String,
    pub author: String,
}

#[derive(Debug, Clone, PartialEq, Eq, Deserialize)]
struct GithubCommitPayload {
    #[serde(default)]
    sha: String,
    #[serde(default)]
    commit: CommitDetail,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Deserialize)]
struct CommitDetail {
    #[serde(default)]
    message: String,
    #[serde(default)]
    author: AuthorName,
}

#[derive(Default, Debug, Clone, PartialEq, Eq, Deserialize)]
struct AuthorName {
    #[serde(default)]
    name: String,
}

impl From<GithubCommitPayload> for Commit {
    fn from(p: GithubCommitPayload) -> Self {
        Self {
            sha: p.sha,
            message: p.commit.message,
            author: p.commit.author.name,
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct IssueComment {
    pub id: u64,
    #[serde(default)]
    pub body: String,
    #[serde(default)]
    pub author: String,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct CiJob {
    pub id: u64,
    #[serde(default)]
    pub name: String,
    pub status: PipelineStatus,
    pub conclusion: Option<PipelineConclusion>,
}
