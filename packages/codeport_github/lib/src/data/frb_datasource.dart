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

Future<GithubRepoDto> liveFetchRepo({
  required String token,
  required String fullName,
}) async {
  final r = await githubGetRepo(token: token, fullName: fullName);
  return GithubRepoDto(
    id: r.id.toInt(),
    fullName: r.fullName,
    private: r.private,
    stars: r.stars.toInt(),
    defaultBranch: r.defaultBranch,
  );
}

Future<List<GithubCommitDto>> liveFetchCommits({
  required String token,
  required String fullName,
}) async {
  final commits = await githubListCommits(token: token, fullName: fullName);
  return commits
      .map(
        (c) =>
            GithubCommitDto(sha: c.sha, message: c.message, author: c.author),
      )
      .toList();
}

Future<GithubIssueDto> liveFetchIssue({
  required String token,
  required String fullName,
  required int number,
}) async {
  final r = await githubGetIssue(
    token: token,
    fullName: fullName,
    number: BigInt.from(number),
  );
  return GithubIssueDto(
    id: r.id.toInt(),
    number: r.number.toInt(),
    title: r.title,
    state: r.state.name,
    labels: r.labels,
  );
}

Future<List<GithubIssueCommentDto>> liveFetchComments({
  required String token,
  required String fullName,
  required int number,
}) async {
  final comments = await githubListComments(
    token: token,
    fullName: fullName,
    number: BigInt.from(number),
  );
  return comments
      .map(
        (c) => GithubIssueCommentDto(
          id: c.id.toInt(),
          body: c.body,
          author: c.author,
        ),
      )
      .toList();
}

Future<GithubIssueDto> liveCreateIssue({
  required String token,
  required String fullName,
  required String title,
  String? body,
}) async {
  final r = await githubCreateIssue(
    token: token,
    fullName: fullName,
    title: title,
    body: body,
  );
  return GithubIssueDto(
    id: r.id.toInt(),
    number: r.number.toInt(),
    title: r.title,
    state: r.state.name,
    labels: r.labels,
  );
}

Future<GithubIssueDto> liveCloseIssue({
  required String token,
  required String fullName,
  required int number,
}) async {
  final r = await githubCloseIssue(
    token: token,
    fullName: fullName,
    number: BigInt.from(number),
  );
  return GithubIssueDto(
    id: r.id.toInt(),
    number: r.number.toInt(),
    title: r.title,
    state: r.state.name,
    labels: r.labels,
  );
}

Future<GithubIssueDto> liveReopenIssue({
  required String token,
  required String fullName,
  required int number,
}) async {
  final r = await githubReopenIssue(
    token: token,
    fullName: fullName,
    number: BigInt.from(number),
  );
  return GithubIssueDto(
    id: r.id.toInt(),
    number: r.number.toInt(),
    title: r.title,
    state: r.state.name,
    labels: r.labels,
  );
}

Future<GithubIssueCommentDto> liveCreateComment({
  required String token,
  required String fullName,
  required int number,
  required String body,
}) async {
  final r = await githubCreateComment(
    token: token,
    fullName: fullName,
    number: BigInt.from(number),
    body: body,
  );
  return GithubIssueCommentDto(
    id: r.id.toInt(),
    body: r.body,
    author: r.author,
  );
}

Future<GithubRunDto> liveFetchRun({
  required String token,
  required String fullName,
  required int runId,
}) async {
  final r = await githubGetRun(
    token: token,
    fullName: fullName,
    runId: BigInt.from(runId),
  );
  return GithubRunDto(
    id: r.id.toInt(),
    status: r.status.name,
    conclusion: r.conclusion?.name,
    runNumber: r.runNumber.toInt(),
  );
}

Future<List<GithubCiJobDto>> liveFetchJobs({
  required String token,
  required String fullName,
  required int runId,
}) async {
  final jobs = await githubListJobs(
    token: token,
    fullName: fullName,
    runId: BigInt.from(runId),
  );
  return jobs
      .map(
        (j) => GithubCiJobDto(
          id: j.id.toInt(),
          name: j.name,
          status: j.status.name,
          conclusion: j.conclusion?.name,
        ),
      )
      .toList();
}

BridgeGateway liveBridgeGateway() {
  return BridgeGateway(
    fetchRepoPage: liveFetchRepos,
    fetchIssueList: liveFetchIssues,
    fetchRunList: liveFetchRuns,
    retryRun: liveRetryRun,
    fetchSingleRepo: liveFetchRepo,
    fetchCommitList: liveFetchCommits,
    fetchSingleIssue: liveFetchIssue,
    fetchCommentList: liveFetchComments,
    createNewIssue: liveCreateIssue,
    closeCurrentIssue: liveCloseIssue,
    reopenCurrentIssue: liveReopenIssue,
    createNewComment: liveCreateComment,
    fetchSingleRun: liveFetchRun,
    fetchJobList: liveFetchJobs,
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

class FrbCommitRecord {
  const FrbCommitRecord({
    required this.sha,
    required this.message,
    required this.author,
  });

  final String sha;
  final String message;
  final String author;
}

class FrbCommentRecord {
  const FrbCommentRecord({
    required this.id,
    required this.body,
    required this.author,
  });

  final BigInt id;
  final String body;
  final String author;
}

class FrbJobRecord {
  const FrbJobRecord({
    required this.id,
    required this.name,
    required this.status,
    this.conclusion,
  });

  final BigInt id;
  final String name;
  final String status;
  final String? conclusion;
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
