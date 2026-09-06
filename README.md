# codeport

[![ci](https://github.com/lscythe/codeport/actions/workflows/ci.yml/badge.svg)](https://github.com/lscythe/codeport/actions/workflows/ci.yml)
[![rust](https://img.shields.io/badge/rust-stable-orange)](https://www.rust-lang.org)
[![flutter](https://img.shields.io/badge/flutter-stable-blue)](https://flutter.dev)
[![license](https://img.shields.io/badge/license-Apache--2.0-green)](LICENSE)

Git hosting client for repos, CI/CD, and issues. Flutter renders UI only. Rust is the business logic engine behind `flutter_rust_bridge`.

## Layout

```text
rust/crates/
  codeport-core/        entities, error, RepoStore/IssueStore/CiStore traits
  codeport-github/      REST client, parsers, GithubStore, watch backoff
  codeport-gitlab-stub/ proof that a second provider fits the same traits
  codeport-git/         local git ops stub (phase 2)
rust/src/api/           FRB boundary: auth, repositories, issues, cicd
packages/
  codeport_core/        AppFailure, Page/CursorPaginator, UseCaseNotifier,
                        AuthToken + SecureTokenStorage, FRB bindings
  codeport_github/      data (DTO/datasource/gateway), domain, ui models,
                        Riverpod providers, liveBridgeGateway
```

## Data flow

```text
UI (your app) -> Github*Ui -> provider -> GithubGateway (domain)
  -> BridgeGateway (DTO) -> FRB bindings -> Rust store -> GitHub REST
```

Each provider package owns its models and Riverpod providers. Core holds only shared plumbing. A new host (GitLab, Bitbucket) adds one Rust crate plus one Dart package, with no core changes.

## Prerequisites

Flutter stable, Rust stable, `flutter_rust_bridge_codegen 2.13.0`, Melos.

## Commands

```sh
melos bootstrap
cargo test --manifest-path rust/Cargo.toml --workspace
cargo clippy --manifest-path rust/Cargo.toml --workspace --all-targets -- -D warnings
cargo fmt --check --manifest-path rust/Cargo.toml
flutter test --directory=packages/codeport_core
flutter test --directory=packages/codeport_github
flutter_rust_bridge_codegen generate \
  --rust-input crate::api \
  --rust-root rust/ \
  --dart-output packages/codeport_core/lib/src/rust
```

## Auth

Personal access token, held in memory by `AuthToken` and persisted through `SecureTokenStorage`. The app shell provides the platform implementation. The token is passed per FRB call and sent as a Bearer header. No OAuth in MVP.

## Status

MVP engine done: paginated repo listing, repo detail and commits, issue list/detail/comments/create/close/reopen, run list/detail/jobs/retry, live run watch stream with backoff. UI is up to you.

## License

Licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE).
