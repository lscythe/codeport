import 'package:flutter_riverpod/flutter_riverpod.dart';

class GithubGateway {
  const GithubGateway({
    required this.listRepos,
    required this.listIssues,
    required this.listRuns,
    required this.retryRun,
  });

  final Future<List<RepoSummary>> Function({
    required String token,
    required int page,
  })
  listRepos;
  final Future<List<IssueSummary>> Function({
    required String token,
    required String fullName,
    String? state,
  })
  listIssues;
  final Future<List<RunSummary>> Function({
    required String token,
    required String fullName,
  })
  listRuns;
  final Future<void> Function({
    required String token,
    required String fullName,
    required int runId,
  })
  retryRun;
}

final githubGatewayProvider = Provider<GithubGateway>((ref) {
  throw UnimplementedError('Override with a real or fake gateway');
});

class RepoSummary {
  const RepoSummary({required this.fullName, required this.private});
  final String fullName;
  final bool private;
}

class IssueSummary {
  const IssueSummary({required this.number, required this.title});
  final int number;
  final String title;
}

class RunSummary {
  const RunSummary({required this.runId, required this.status});
  final int runId;
  final String status;
}
