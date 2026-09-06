import 'package:codeport_core/codeport_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:codeport_github/codeport_github.dart';

GithubRepo testRepo() {
  return GithubRepo(
    id: 1,
    fullName: GithubFullName(owner: 'octocat', name: 'Hello-World'),
    private: false,
    stars: 80,
    defaultBranch: 'main',
  );
}

void main() {
  ProviderContainer makeContainer(GithubGateway gateway) {
    return ProviderContainer(
      overrides: [
        githubGatewayProvider.overrideWithValue(gateway),
        authTokenProvider.overrideWithValue('t'),
      ],
    );
  }

  GithubGateway fakeGateway({
    Future<Page<GithubRepo>> Function({
      required String token,
      required int page,
    })?
    listRepoPage,
    Future<List<GithubIssue>> Function({
      required String token,
      required String fullName,
      String? state,
    })?
    listIssues,
    Future<List<GithubRun>> Function({
      required String token,
      required String fullName,
    })?
    listRuns,
    Future<void> Function({
      required String token,
      required String fullName,
      required int runId,
    })?
    retryRun,
  }) {
    GithubRepo stubRepo() => GithubRepo(
      id: 0,
      fullName: GithubFullName(owner: 'o', name: 'r'),
      private: false,
      stars: 0,
      defaultBranch: 'main',
    );
    GithubIssue stubIssue() =>
        GithubIssue(id: 0, number: 0, title: '', state: GithubIssueState.open);

    return GithubGateway(
      listRepoPage:
          listRepoPage ??
          ({required token, required page}) async =>
              const Page(items: [], nextCursor: null),
      listIssues:
          listIssues ??
          ({required token, required fullName, state}) async => [],
      listRuns: listRuns ?? ({required token, required fullName}) async => [],
      retryRun:
          retryRun ??
          ({required token, required fullName, required runId}) async {},
      getRepo: ({required token, required fullName}) async => stubRepo(),
      listCommits: ({required token, required fullName}) async => [],
      getIssue: ({
        required token,
        required fullName,
        required int number,
      }) async => GithubIssueDetail(issue: stubIssue(), comments: []),
      createIssue: ({
        required token,
        required fullName,
        required String title,
        body,
      }) async => stubIssue(),
      closeIssue: ({
        required token,
        required fullName,
        required int number,
      }) async => stubIssue(),
      reopenIssue: ({
        required token,
        required fullName,
        required int number,
      }) async => stubIssue(),
      createComment: ({
        required token,
        required fullName,
        required int number,
        required String body,
      }) async => GithubIssueComment(id: 0, body: body, author: ''),
      getRun: ({required token, required fullName, required int runId}) async =>
          GithubRunDetail(
            run: GithubRun(
              id: runId,
              status: GithubRunStatus.queued,
              runNumber: runId,
            ),
            jobs: [],
          ),
      listJobs: ({
        required token,
        required fullName,
        required int runId,
      }) async => [],
    );
  }

  test('repoList loads first page through gateway', () async {
    final container = makeContainer(
      fakeGateway(
        listRepoPage: ({required token, required page}) async {
          expect(token, 't');
          expect(page, 1);
          return Page(items: [testRepo()], nextCursor: null);
        },
      ),
    );
    addTearDown(container.dispose);

    final repos = await container.read(repoListProvider.future);

    expect(repos.single.fullName, 'octocat/Hello-World');
    expect(repos.single.starsLabel, '80');
  });

  test('repoList collects all pages through cursor', () async {
    final seenPages = <int>[];
    final container = makeContainer(
      fakeGateway(
        listRepoPage: ({required token, required page}) async {
          seenPages.add(page);
          if (page == 1) {
            return Page(items: [testRepo()], nextCursor: 2);
          }
          return const Page(items: [], nextCursor: null);
        },
      ),
    );
    addTearDown(container.dispose);

    final repos = await container.read(repoListProvider.future);

    expect(seenPages, [1, 2]);
    expect(repos.single.fullName, 'octocat/Hello-World');
  });

  test('repoList surfaces auth failure when token is missing', () async {
    final container = ProviderContainer(
      overrides: [
        githubGatewayProvider.overrideWithValue(fakeGateway()),
        authTokenProvider.overrideWithValue(null),
      ],
    );
    addTearDown(container.dispose);

    container.listen(repoListProvider, (_, _) {});
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final state = container.read(repoListProvider);
    expect(state.hasError, isTrue);
    expect(state.error, isA<AuthFailure>());
  });

  test('issueList loads issues for the selected repo', () async {
    final container = makeContainer(
      fakeGateway(
        listIssues: ({required token, required fullName, state}) async {
          expect(fullName, 'octocat/Hello-World');
          return [
            GithubIssue(
              id: 1,
              number: 7,
              title: 'Bug',
              state: GithubIssueState.open,
              labels: ['bug'],
            ),
          ];
        },
      ),
    );
    addTearDown(container.dispose);

    final issues = await container.read(
      issueListProvider('octocat/Hello-World').future,
    );

    expect(issues.single.title, 'Bug');
    expect(issues.single.stateLabel, 'Open');
  });

  test('runList loads runs and retryRun completes', () async {
    var retried = 0;
    final container = makeContainer(
      fakeGateway(
        listRuns: ({required token, required fullName}) async => [
          GithubRun(
            id: 12,
            status: GithubRunStatus.completed,
            conclusion: GithubRunConclusion.failure,
            runNumber: 12,
          ),
        ],
        retryRun: ({required token, required fullName, required runId}) async {
          expect(runId, 12);
          retried++;
        },
      ),
    );
    addTearDown(container.dispose);

    final runs = await container.read(runListProvider('o/r').future);

    expect(runs.single.statusLabel, 'Failed');
    expect(runs.single.canRetry, isTrue);
    await container.read(retryRunProvider(fullName: 'o/r', runId: 12).future);
    expect(retried, 1);
  });

  test('repoDetail and commitList load repo data', () async {
    final container = makeContainer(fakeGateway());
    addTearDown(container.dispose);

    final repo = await container.read(repoDetailProvider('o/r').future);
    expect(repo.fullName, 'o/r');

    final commits = await container.read(commitListProvider('o/r').future);
    expect(commits, isEmpty);
  });

  test('issueDetail loads issue with comments', () async {
    final container = makeContainer(fakeGateway());
    addTearDown(container.dispose);

    final detail = await container.read(issueDetailProvider('o/r', 0).future);
    expect(detail.commentCountLabel, '0 comments');
  });

  test('runDetail and jobList load run data', () async {
    final container = makeContainer(fakeGateway());
    addTearDown(container.dispose);

    final detail = await container.read(runDetailProvider('o/r', 0).future);
    expect(detail.jobs, isEmpty);

    final jobs = await container.read(jobListProvider('o/r', 0).future);
    expect(jobs, isEmpty);
  });
}
