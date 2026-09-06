//! GitHub provider implementation.
//!
//! API choice: REST-first. GitHub exposes both REST and GraphQL, but the
//! Actions API (CI/CD monitoring — an MVP pillar) is REST-only, so the MVP
//! client targets REST (`Link`-header pagination, see [`pagination`]).
//! GraphQL can be added later per-screen (e.g. issue timelines) behind the
//! same `codeport-core` traits without touching core or Dart.
pub mod cicd;
pub mod client;
pub mod http;
pub mod issues;
pub mod pagination;
pub mod repos;
pub mod store;
pub mod watch;
