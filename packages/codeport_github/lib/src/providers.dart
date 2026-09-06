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
    () => CursorPaginator.collect(
      (cursor) => gateway.listRepoPage(token: token, page: cursor),
      firstCursor: 1,
    ),
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

@Riverpod(keepAlive: true)
Future<GithubRepoUi> repoDetail(Ref ref, String fullName) async {
  final token = _token(ref);
  final gateway = ref.watch(githubGatewayProvider);
  final repo = await UseCaseGuard.guard(
    () => gateway.getRepo(token: token, fullName: fullName),
  );
  return GithubRepoUi.fromDomain(repo);
}

@Riverpod(keepAlive: true)
Future<List<GithubCommitUi>> commitList(Ref ref, String fullName) async {
  final token = _token(ref);
  final gateway = ref.watch(githubGatewayProvider);
  final commits = await UseCaseGuard.guard(
    () => gateway.listCommits(token: token, fullName: fullName),
  );
  return commits.map(GithubCommitUi.fromDomain).toList();
}

@Riverpod(keepAlive: true)
Future<GithubIssueDetailUi> issueDetail(
  Ref ref,
  String fullName,
  int number,
) async {
  final token = _token(ref);
  final gateway = ref.watch(githubGatewayProvider);
  final detail = await UseCaseGuard.guard(
    () => gateway.getIssue(token: token, fullName: fullName, number: number),
  );
  return GithubIssueDetailUi.fromDomain(detail);
}

@Riverpod(keepAlive: true)
Future<GithubIssueUi> createIssue(
  Ref ref,
  String fullName,
  String title, {
  String? body,
}) async {
  final token = _token(ref);
  final gateway = ref.watch(githubGatewayProvider);
  final issue = await UseCaseGuard.guard(
    () => gateway.createIssue(
      token: token,
      fullName: fullName,
      title: title,
      body: body,
    ),
  );
  return GithubIssueUi.fromDomain(issue);
}

@Riverpod(keepAlive: true)
Future<GithubIssueUi> closeIssue(Ref ref, String fullName, int number) async {
  final token = _token(ref);
  final gateway = ref.watch(githubGatewayProvider);
  final issue = await UseCaseGuard.guard(
    () => gateway.closeIssue(token: token, fullName: fullName, number: number),
  );
  return GithubIssueUi.fromDomain(issue);
}

@Riverpod(keepAlive: true)
Future<GithubIssueUi> reopenIssue(Ref ref, String fullName, int number) async {
  final token = _token(ref);
  final gateway = ref.watch(githubGatewayProvider);
  final issue = await UseCaseGuard.guard(
    () => gateway.reopenIssue(token: token, fullName: fullName, number: number),
  );
  return GithubIssueUi.fromDomain(issue);
}

@Riverpod(keepAlive: true)
Future<GithubIssueCommentUi> createComment(
  Ref ref,
  String fullName,
  int number,
  String body,
) async {
  final token = _token(ref);
  final gateway = ref.watch(githubGatewayProvider);
  final comment = await UseCaseGuard.guard(
    () => gateway.createComment(
      token: token,
      fullName: fullName,
      number: number,
      body: body,
    ),
  );
  return GithubIssueCommentUi.fromDomain(comment);
}

@Riverpod(keepAlive: true)
Future<GithubRunDetailUi> runDetail(Ref ref, String fullName, int runId) async {
  final token = _token(ref);
  final gateway = ref.watch(githubGatewayProvider);
  final detail = await UseCaseGuard.guard(
    () => gateway.getRun(token: token, fullName: fullName, runId: runId),
  );
  return GithubRunDetailUi.fromDomain(detail);
}

@Riverpod(keepAlive: true)
Future<List<GithubCiJobUi>> jobList(Ref ref, String fullName, int runId) async {
  final token = _token(ref);
  final gateway = ref.watch(githubGatewayProvider);
  final jobs = await UseCaseGuard.guard(
    () => gateway.listJobs(token: token, fullName: fullName, runId: runId),
  );
  return jobs.map(GithubCiJobUi.fromDomain).toList();
}
