use codeport_core::entities::{Pipeline, PipelineStatus};

pub struct WatchConfig {
    pub initial_delay_secs: u64,
    pub max_delay_secs: u64,
    pub max_attempts: u32,
}

impl Default for WatchConfig {
    fn default() -> Self {
        Self {
            initial_delay_secs: 2,
            max_delay_secs: 30,
            max_attempts: 60,
        }
    }
}

pub fn is_terminal(run: &Pipeline) -> bool {
    run.status == PipelineStatus::Completed && run.conclusion.is_some()
}

pub fn next_delay(config: &WatchConfig, attempt: u32) -> u64 {
    let delay = config
        .initial_delay_secs
        .saturating_mul(2u64.saturating_pow(attempt));
    delay.min(config.max_delay_secs)
}

pub fn should_stop(config: &WatchConfig, attempts: u32, terminal: bool) -> bool {
    terminal || attempts >= config.max_attempts
}
