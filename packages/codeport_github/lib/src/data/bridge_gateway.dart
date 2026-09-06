import 'package:codeport_core/codeport_core.dart';

import '../domain/github_models.dart';
import 'github_dto.dart';

typedef FetchRepos = Future<GithubRepoPage> Function({
  required String token,
  required int page,
});

typedef FetchIssues = Future<List<GithubIssueDto>> Function({
  required String token,
  required String fullName,
  String? state,
});

typedef FetchRuns = Future<List<GithubRunDto>> Function({
  required String token,
  required String fullName,
});

typedef RetryRun = Future<void> Function({
  required String token,
  required String fullName,
  required int runId,
});

class BridgeGateway {
  const BridgeGateway({
    required FetchRepos fetchRepos,
    required FetchIssues fetchIssues,
    required FetchRuns fetchRuns,
    required RetryRun doRetry,
  }) : _listRepos = fetchRepos,
       _listIssues = fetchIssues,
       _listRuns = fetchRuns,
       _retryRun = doRetry;

  final FetchRepos _listRepos;
  final FetchIssues _listIssues;
  final FetchRuns _listRuns;
  final RetryRun _retryRun;

  Future<Page<GithubRepo>> fetchRepoPage({
    required String token,
    required int page,
  }) async {
    final result = await _listRepos(token: token, page: page);
    return Page(
      items: result.repos.map((dto) => dto.toDomain()).toList(),
      nextCursor: result.nextPage,
    );
  }

  Future<List<GithubIssue>> fetchIssues({
    required String token,
    required String fullName,
    String? state,
  }) async {
    final dtos = await _listIssues(
      token: token,
      fullName: fullName,
      state: state,
    );
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  Future<List<GithubRun>> fetchRuns({
    required String token,
    required String fullName,
  }) async {
    final dtos = await _listRuns(token: token, fullName: fullName);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  Future<void> doRetry({
    required String token,
    required String fullName,
    required int runId,
  }) {
    return _retryRun(token: token, fullName: fullName, runId: runId);
  }
}
