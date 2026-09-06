import 'package:codeport_core/codeport_core.dart';

import 'bridge_gateway.dart';
import 'github_dto.dart';

Future<GithubRepoPage> liveFetchRepos({
  required String token,
  required int page,
}) async {
  final result = await githubListRepos(token: token, page: page);
  return GithubRepoPage(
    repos: result.repos
        .map(
          (r) => GithubRepoDto(
            id: r.id.toInt(),
            fullName: r.fullName,
            private: r.private,
            stars: r.stars.toInt(),
            defaultBranch: r.defaultBranch,
          ),
        )
        .toList(),
    nextPage: result.nextPage?.toInt(),
  );
}

Future<List<GithubIssueDto>> liveFetchIssues({
  required String token,
  required String fullName,
  String? state,
}) async {
  final issues = await githubListIssues(
    token: token,
    fullName: fullName,
    state: state,
  );
  return issues
      .map(
        (r) => GithubIssueDto(
          id: r.id.toInt(),
          number: r.number.toInt(),
          title: r.title,
          state: r.state.name,
          labels: r.labels,
        ),
      )
      .toList();
}

Future<List<GithubRunDto>> liveFetchRuns({
  required String token,
  required String fullName,
}) async {
  final runs = await githubListRuns(token: token, fullName: fullName);
  return runs
      .map(
        (r) => GithubRunDto(
          id: r.id.toInt(),
          status: r.status.name,
          conclusion: r.conclusion?.name,
          runNumber: r.runNumber.toInt(),
        ),
      )
      .toList();
}

Future<void> liveRetryRun({
  required String token,
  required String fullName,
  required int runId,
}) {
  return githubRetryRun(
    token: token,
    fullName: fullName,
    runId: BigInt.from(runId),
  );
}

BridgeGateway liveBridgeGateway() {
  return BridgeGateway(
    fetchRepos: liveFetchRepos,
    fetchIssues: liveFetchIssues,
    fetchRuns: liveFetchRuns,
    doRetry: liveRetryRun,
  );
}

class FrbRepoRecord {
  const FrbRepoRecord({
    required this.id,
    required this.fullName,
    required this.private,
    required this.stars,
    required this.defaultBranch,
  });

  final BigInt id;
  final String fullName;
  final bool private;
  final BigInt stars;
  final String defaultBranch;
}

class FrbIssueRecord {
  const FrbIssueRecord({
    required this.id,
    required this.number,
    required this.title,
    required this.state,
    required this.labels,
  });

  final BigInt id;
  final BigInt number;
  final String title;
  final String state;
  final List<String> labels;
}

class FrbRunRecord {
  const FrbRunRecord({
    required this.id,
    required this.status,
    this.conclusion,
    required this.runNumber,
  });

  final BigInt id;
  final String status;
  final String? conclusion;
  final BigInt runNumber;
}

class FrbGithubDataSource {
  const FrbGithubDataSource({
    required this.listRepos,
    required this.listIssues,
    required this.listRuns,
    required this.retryRun,
  });

  final Future<List<FrbRepoRecord>> Function({
    required String token,
    required int page,
  })
  listRepos;
  final Future<List<FrbIssueRecord>> Function({
    required String token,
    required String fullName,
    String? state,
  })
  listIssues;
  final Future<List<FrbRunRecord>> Function({
    required String token,
    required String fullName,
  })
  listRuns;
  final Future<void> Function({
    required String token,
    required String fullName,
    required BigInt runId,
  })
  retryRun;

  FetchRepos get asFetchRepos => ({required token, required page}) async {
    final records = await listRepos(token: token, page: page);
    return GithubRepoPage(
      repos: records
          .map(
            (r) => GithubRepoDto(
              id: r.id.toInt(),
              fullName: r.fullName,
              private: r.private,
              stars: r.stars.toInt(),
              defaultBranch: r.defaultBranch,
            ),
          )
          .toList(),
    );
  };

  FetchIssues get asFetchIssues =>
      ({required token, required fullName, String? state}) async {
        final records = await listIssues(
          token: token,
          fullName: fullName,
          state: state,
        );
        return records
            .map(
              (r) => GithubIssueDto(
                id: r.id.toInt(),
                number: r.number.toInt(),
                title: r.title,
                state: r.state,
                labels: r.labels,
              ),
            )
            .toList();
      };

  FetchRuns get asFetchRuns => ({required token, required fullName}) async {
    final records = await listRuns(token: token, fullName: fullName);
    return records
        .map(
          (r) => GithubRunDto(
            id: r.id.toInt(),
            status: r.status,
            conclusion: r.conclusion,
            runNumber: r.runNumber.toInt(),
          ),
        )
        .toList();
  };
}
