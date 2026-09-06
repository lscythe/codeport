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

typedef WatchRun = Stream<GithubRunDto> Function({
  required String token,
  required String fullName,
  required int runId,
});

typedef FetchCommits = Future<List<GithubCommitDto>> Function({
  required String token,
  required String fullName,
});

typedef FetchIssue = Future<GithubIssueDto> Function({
  required String token,
  required String fullName,
  required int number,
});

typedef FetchComments = Future<List<GithubIssueCommentDto>> Function({
  required String token,
  required String fullName,
  required int number,
});

typedef CreateIssue = Future<GithubIssueDto> Function({
  required String token,
  required String fullName,
  required String title,
  String? body,
});

typedef SetIssueState = Future<GithubIssueDto> Function({
  required String token,
  required String fullName,
  required int number,
});

typedef CreateComment = Future<GithubIssueCommentDto> Function({
  required String token,
  required String fullName,
  required int number,
  required String body,
});

typedef FetchRepo = Future<GithubRepoDto> Function({
  required String token,
  required String fullName,
});

typedef FetchRun = Future<GithubRunDto> Function({
  required String token,
  required String fullName,
  required int runId,
});

typedef FetchJobs = Future<List<GithubCiJobDto>> Function({
  required String token,
  required String fullName,
  required int runId,
});

BridgeGateway emptyBridge({
  FetchRepos? fetchRepos,
  FetchIssues? fetchIssues,
  FetchRuns? fetchRuns,
  RetryRun? retryRun,
  WatchRun? watchRun,
  FetchRepo? fetchRepo,
  FetchCommits? fetchCommits,
  FetchIssue? fetchIssue,
  FetchComments? fetchComments,
  CreateIssue? createIssue,
  SetIssueState? closeIssue,
  SetIssueState? reopenIssue,
  CreateComment? createComment,
  FetchRun? fetchRun,
  FetchJobs? fetchJobs,
}) {
  Future<GithubRepoPage> noRepos({
    required String token,
    required int page,
  }) async => const GithubRepoPage(repos: []);
  Future<List<GithubIssueDto>> noIssues({
    required String token,
    required String fullName,
    String? state,
  }) async => [];
  Future<List<GithubRunDto>> noRuns({
    required String token,
    required String fullName,
  }) async => [];
  Future<void> noRetry({
    required String token,
    required String fullName,
    required int runId,
  }) async {}
  Stream<GithubRunDto> noWatch({
    required String token,
    required String fullName,
    required int runId,
  }) => const Stream.empty();
  Future<GithubRepoDto> noRepo({
    required String token,
    required String fullName,
  }) async => throw UnimplementedError('fetchRepo');
  Future<List<GithubCommitDto>> noCommits({
    required String token,
    required String fullName,
  }) async => [];
  Future<GithubIssueDto> noIssue({
    required String token,
    required String fullName,
    required int number,
  }) async => throw UnimplementedError('fetchIssue');
  Future<List<GithubIssueCommentDto>> noComments({
    required String token,
    required String fullName,
    required int number,
  }) async => [];
  Future<GithubIssueDto> noCreate({
    required String token,
    required String fullName,
    required String title,
    String? body,
  }) async => throw UnimplementedError('createIssue');
  Future<GithubIssueDto> noSetState({
    required String token,
    required String fullName,
    required int number,
  }) async => throw UnimplementedError('setIssueState');
  Future<GithubIssueCommentDto> noComment({
    required String token,
    required String fullName,
    required int number,
    required String body,
  }) async => throw UnimplementedError('createComment');
  Future<GithubRunDto> noRun({
    required String token,
    required String fullName,
    required int runId,
  }) async => throw UnimplementedError('fetchRun');
  Future<List<GithubCiJobDto>> noJobs({
    required String token,
    required String fullName,
    required int runId,
  }) async => [];

  return BridgeGateway(
    fetchRepoPage: fetchRepos ?? noRepos,
    fetchIssueList: fetchIssues ?? noIssues,
    fetchRunList: fetchRuns ?? noRuns,
    retryRun: retryRun ?? noRetry,
    watchRun: watchRun ?? noWatch,
    fetchSingleRepo: fetchRepo ?? noRepo,
    fetchCommitList: fetchCommits ?? noCommits,
    fetchSingleIssue: fetchIssue ?? noIssue,
    fetchCommentList: fetchComments ?? noComments,
    createNewIssue: createIssue ?? noCreate,
    closeCurrentIssue: closeIssue ?? noSetState,
    reopenCurrentIssue: reopenIssue ?? noSetState,
    createNewComment: createComment ?? noComment,
    fetchSingleRun: fetchRun ?? noRun,
    fetchJobList: fetchJobs ?? noJobs,
  );
}

class BridgeGateway {
  const BridgeGateway({
    required FetchRepos fetchRepoPage,
    required FetchIssues fetchIssueList,
    required FetchRuns fetchRunList,
    required RetryRun retryRun,
    required WatchRun watchRun,
    required FetchRepo fetchSingleRepo,
    required FetchCommits fetchCommitList,
    required FetchIssue fetchSingleIssue,
    required FetchComments fetchCommentList,
    required CreateIssue createNewIssue,
    required SetIssueState closeCurrentIssue,
    required SetIssueState reopenCurrentIssue,
    required CreateComment createNewComment,
    required FetchRun fetchSingleRun,
    required FetchJobs fetchJobList,
  }) : _listRepos = fetchRepoPage,
       _listIssues = fetchIssueList,
       _listRuns = fetchRunList,
       // ignore: prefer_initializing_formals
       _retryRun = retryRun,
       // ignore: prefer_initializing_formals
       _watchRun = watchRun,
       _fetchRepo = fetchSingleRepo,
       _fetchCommits = fetchCommitList,
       _fetchIssue = fetchSingleIssue,
       _fetchComments = fetchCommentList,
       _createIssue = createNewIssue,
       _closeIssue = closeCurrentIssue,
       _reopenIssue = reopenCurrentIssue,
       _createComment = createNewComment,
       _fetchRun = fetchSingleRun,
       _fetchJobs = fetchJobList;

  final FetchRepos _listRepos;
  final FetchIssues _listIssues;
  final FetchRuns _listRuns;
  final RetryRun _retryRun;
  final WatchRun _watchRun;
  final FetchRepo _fetchRepo;
  final FetchCommits _fetchCommits;
  final FetchIssue _fetchIssue;
  final FetchComments _fetchComments;
  final CreateIssue _createIssue;
  final SetIssueState _closeIssue;
  final SetIssueState _reopenIssue;
  final CreateComment _createComment;
  final FetchRun _fetchRun;
  final FetchJobs _fetchJobs;

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

  Stream<GithubRun> watchRun({
    required String token,
    required String fullName,
    required int runId,
  }) {
    return _watchRun(
      token: token,
      fullName: fullName,
      runId: runId,
    ).map((dto) => dto.toDomain());
  }

  Future<GithubRepo> fetchRepo({
    required String token,
    required String fullName,
  }) async {
    final dto = await _fetchRepo(token: token, fullName: fullName);
    return dto.toDomain();
  }

  Future<List<GithubCommit>> fetchCommits({
    required String token,
    required String fullName,
  }) async {
    final dtos = await _fetchCommits(token: token, fullName: fullName);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  Future<GithubIssueDetail> fetchIssueDetail({
    required String token,
    required String fullName,
    required int number,
  }) async {
    final issue = await _fetchIssue(
      token: token,
      fullName: fullName,
      number: number,
    );
    final comments = await _fetchComments(
      token: token,
      fullName: fullName,
      number: number,
    );
    return GithubIssueDetail(
      issue: issue.toDomain(),
      comments: comments.map((dto) => dto.toDomain()).toList(),
    );
  }

  Future<GithubIssue> createIssue({
    required String token,
    required String fullName,
    required String title,
    String? body,
  }) async {
    final dto = await _createIssue(
      token: token,
      fullName: fullName,
      title: title,
      body: body,
    );
    return dto.toDomain();
  }

  Future<GithubIssue> closeIssue({
    required String token,
    required String fullName,
    required int number,
  }) async {
    final dto = await _closeIssue(
      token: token,
      fullName: fullName,
      number: number,
    );
    return dto.toDomain();
  }

  Future<GithubIssue> reopenIssue({
    required String token,
    required String fullName,
    required int number,
  }) async {
    final dto = await _reopenIssue(
      token: token,
      fullName: fullName,
      number: number,
    );
    return dto.toDomain();
  }

  Future<GithubIssueComment> createComment({
    required String token,
    required String fullName,
    required int number,
    required String body,
  }) async {
    final dto = await _createComment(
      token: token,
      fullName: fullName,
      number: number,
      body: body,
    );
    return dto.toDomain();
  }

  Future<GithubRunDetail> fetchRunDetail({
    required String token,
    required String fullName,
    required int runId,
  }) async {
    final run = await _fetchRun(token: token, fullName: fullName, runId: runId);
    final jobs = await _fetchJobs(
      token: token,
      fullName: fullName,
      runId: runId,
    );
    return GithubRunDetail(
      run: run.toDomain(),
      jobs: jobs.map((dto) => dto.toDomain()).toList(),
    );
  }
}
