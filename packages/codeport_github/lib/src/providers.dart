import 'package:codeport_core/codeport_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'gateway.dart';
import 'ui/github_ui_models.dart';

part 'providers.g.dart';

String _token(Ref ref) {
  final token = ref.watch(authTokenProvider);
  if (token == null || token.isEmpty) {
    throw const AuthFailure();
  }
  return token;
}

@Riverpod(keepAlive: true)
Future<List<GithubRepoUi>> repoList(Ref ref) async {
  final token = _token(ref);
  final gateway = ref.watch(githubGatewayProvider);
  final repos = await UseCaseGuard.guard(
    () => gateway.listRepos(token: token, page: 1),
  );
  return repos.map(GithubRepoUi.fromDomain).toList();
}

@Riverpod(keepAlive: true)
Future<List<GithubIssueUi>> issueList(Ref ref, String fullName) async {
  final token = _token(ref);
  final gateway = ref.watch(githubGatewayProvider);
  final issues = await UseCaseGuard.guard(
    () => gateway.listIssues(token: token, fullName: fullName),
  );
  return issues.map(GithubIssueUi.fromDomain).toList();
}

@Riverpod(keepAlive: true)
Future<List<GithubRunUi>> runList(Ref ref, String fullName) async {
  final token = _token(ref);
  final gateway = ref.watch(githubGatewayProvider);
  final runs = await UseCaseGuard.guard(
    () => gateway.listRuns(token: token, fullName: fullName),
  );
  return runs.map(GithubRunUi.fromDomain).toList();
}

@Riverpod(keepAlive: true)
Future<void> retryRun(
  Ref ref, {
  required String fullName,
  required int runId,
}) async {
  final token = _token(ref);
  final gateway = ref.watch(githubGatewayProvider);
  return UseCaseGuard.guard(
    () => gateway.retryRun(token: token, fullName: fullName, runId: runId),
  );
}
