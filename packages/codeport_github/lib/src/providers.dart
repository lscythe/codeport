import 'package:codeport_core/codeport_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'gateway.dart';

part 'providers.g.dart';

String _token(Ref ref) {
  final token = ref.watch(authTokenProvider);
  if (token == null || token.isEmpty) {
    throw const AuthFailure();
  }
  return token;
}

@Riverpod(keepAlive: true)
Future<List<RepoSummary>> repoList(Ref ref) async {
  final token = _token(ref);
  final gateway = ref.watch(githubGatewayProvider);
  return UseCaseGuard.guard(() => gateway.listRepos(token: token, page: 1));
}

@Riverpod(keepAlive: true)
Future<List<IssueSummary>> issueList(Ref ref, String fullName) async {
  final token = _token(ref);
  final gateway = ref.watch(githubGatewayProvider);
  return UseCaseGuard.guard(
    () => gateway.listIssues(token: token, fullName: fullName),
  );
}

@Riverpod(keepAlive: true)
Future<List<RunSummary>> runList(Ref ref, String fullName) async {
  final token = _token(ref);
  final gateway = ref.watch(githubGatewayProvider);
  return UseCaseGuard.guard(
    () => gateway.listRuns(token: token, fullName: fullName),
  );
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
