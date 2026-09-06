use codeport_core::entities::{Pipeline, PipelineConclusion, PipelineStatus};
use codeport_github::watch::{is_terminal, next_delay, should_stop, WatchConfig};

fn completed(status: PipelineStatus, conclusion: Option<PipelineConclusion>) -> Pipeline {
    Pipeline {
        id: 1,
        status,
        conclusion,
        run_number: 12,
    }
}

#[test]
fn terminal_when_completed_with_conclusion() {
    let run = completed(PipelineStatus::Completed, Some(PipelineConclusion::Success));
    assert!(is_terminal(&run));
}

#[test]
fn not_terminal_while_in_progress() {
    let run = completed(PipelineStatus::InProgress, None);
    assert!(!is_terminal(&run));
}

#[test]
fn not_terminal_when_completed_without_conclusion() {
    let run = completed(PipelineStatus::Completed, None);
    assert!(!is_terminal(&run));
}

#[test]
fn backoff_grows_then_caps() {
    let config = WatchConfig {
        initial_delay_secs: 2,
        max_delay_secs: 30,
        ..WatchConfig::default()
    };
    assert_eq!(next_delay(&config, 0), 2);
    assert_eq!(next_delay(&config, 1), 4);
    assert_eq!(next_delay(&config, 10), 30);
}

#[test]
fn stops_after_max_attempts() {
    let config = WatchConfig {
        max_attempts: 3,
        ..WatchConfig::default()
    };
    assert!(!should_stop(&config, 0, false));
    assert!(!should_stop(&config, 2, false));
    assert!(should_stop(&config, 3, false));
    assert!(should_stop(&config, 0, true));
}
