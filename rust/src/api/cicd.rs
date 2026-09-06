use super::{validate_full_name, CiJob, Pipeline};
use codeport_core::error::CodeportError;
use codeport_github::http::BlockingHttp;
use codeport_github::store::GithubStore;
use codeport_github::watch::{self, WatchConfig};

pub fn github_list_runs(token: String, full_name: String) -> Result<Vec<Pipeline>, CodeportError> {
    validate_full_name(&full_name)?;
    let store = GithubStore::new(token, BlockingHttp::new())?;
    store.list_runs(&full_name)
}

pub fn github_get_run(
    token: String,
    full_name: String,
    run_id: u64,
) -> Result<Pipeline, CodeportError> {
    validate_full_name(&full_name)?;
    let store = GithubStore::new(token, BlockingHttp::new())?;
    store.get_run(&full_name, run_id)
}

pub fn github_list_jobs(
    token: String,
    full_name: String,
    run_id: u64,
) -> Result<Vec<CiJob>, CodeportError> {
    validate_full_name(&full_name)?;
    let store = GithubStore::new(token, BlockingHttp::new())?;
    store.list_jobs(&full_name, run_id)
}

pub fn github_retry_run(
    token: String,
    full_name: String,
    run_id: u64,
) -> Result<(), CodeportError> {
    validate_full_name(&full_name)?;
    let store = GithubStore::new(token, BlockingHttp::new())?;
    store.retry_run(&full_name, run_id)
}

pub fn github_watch_run(
    sink: crate::frb_generated::StreamSink<Pipeline>,
    token: String,
    full_name: String,
    run_id: u64,
) -> Result<(), CodeportError> {
    github_watch_run_with(sink, token, full_name, run_id, WatchConfig::default())
}

fn github_watch_run_with(
    sink: crate::frb_generated::StreamSink<Pipeline>,
    token: String,
    full_name: String,
    run_id: u64,
    config: WatchConfig,
) -> Result<(), CodeportError> {
    github_poll_run(
        |run| {
            sink.add(run)
                .map_err(|e| CodeportError::Network(e.to_string()))
        },
        token,
        full_name,
        run_id,
        config,
    )
}

fn github_poll_run(
    mut emit: impl FnMut(Pipeline) -> Result<(), CodeportError>,
    token: String,
    full_name: String,
    run_id: u64,
    config: WatchConfig,
) -> Result<(), CodeportError> {
    validate_full_name(&full_name)?;
    let store = GithubStore::new(token, BlockingHttp::new())?;
    let mut attempts: u32 = 0;
    loop {
        let run = store.get_run(&full_name, run_id)?;
        let terminal = watch::is_terminal(&run);
        emit(run)?;
        if watch::should_stop(&config, attempts, terminal) {
            break;
        }
        std::thread::sleep(std::time::Duration::from_secs(watch::next_delay(
            &config, attempts,
        )));
        attempts = attempts.saturating_add(1);
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::{github_list_runs, github_retry_run};

    #[test]
    fn list_runs_rejects_empty_token() {
        let err = github_list_runs(String::new(), "octocat/Hello-World".to_string())
            .expect_err("empty token must fail");
        assert_eq!(err.to_string(), "authentication failed");
    }

    #[test]
    fn list_runs_rejects_malformed_full_name() {
        let err = github_list_runs("ghp_test".to_string(), "nope".to_string())
            .expect_err("malformed name must fail");
        assert!(err.to_string().contains("invalid"));
    }

    #[test]
    fn retry_run_rejects_empty_token() {
        let err = github_retry_run(String::new(), "o/r".to_string(), 1)
            .expect_err("empty token must fail");
        assert_eq!(err.to_string(), "authentication failed");
    }

    #[test]
    fn retry_run_rejects_malformed_full_name() {
        let err = github_retry_run("ghp_test".to_string(), "nope".to_string(), 1)
            .expect_err("malformed name must fail");
        assert!(err.to_string().contains("invalid"));
    }

    #[test]
    fn get_run_rejects_empty_token() {
        let err = super::github_get_run(String::new(), "o/r".to_string(), 1)
            .expect_err("empty token must fail");
        assert_eq!(err.to_string(), "authentication failed");
    }

    #[test]
    fn list_jobs_rejects_malformed_full_name() {
        let err = super::github_list_jobs("ghp_test".to_string(), "nope".to_string(), 1)
            .expect_err("malformed name must fail");
        assert!(err.to_string().contains("invalid"));
    }

    #[test]
    fn watch_run_rejects_malformed_full_name_without_polling() {
        let mut emitted = vec![];
        let err = super::github_poll_run(
            |run| {
                emitted.push(run);
                Ok(())
            },
            "ghp_test".to_string(),
            "nope".to_string(),
            1,
            fast_config(),
        )
        .expect_err("malformed name must fail");
        assert!(err.to_string().contains("invalid"));
        assert!(emitted.is_empty());
    }

    #[test]
    fn watch_poll_validates_token_before_polling() {
        let mut emitted = vec![];
        let err = super::github_poll_run(
            |run| {
                emitted.push(run);
                Ok(())
            },
            String::new(),
            "o/r".to_string(),
            1,
            fast_config(),
        )
        .expect_err("empty token must fail");
        assert_eq!(err.to_string(), "authentication failed");
        assert!(emitted.is_empty());
    }

    fn fast_config() -> super::WatchConfig {
        super::WatchConfig {
            initial_delay_secs: 0,
            max_delay_secs: 0,
            max_attempts: 2,
        }
    }
}
