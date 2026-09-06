import 'package:codeport_core/codeport_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:codeport_github/codeport_github.dart';

void main() {
  ProviderContainer makeContainer(GithubGateway gateway) {
    return ProviderContainer(
      overrides: [
        githubGatewayProvider.overrideWithValue(gateway),
        authTokenProvider.overrideWithValue('t'),
      ],
    );
  }

  const repos = [RepoSummary(fullName: 'octocat/Hello-World', private: false)];

  test('repoList loads first page through gateway', () async {
    final container = makeContainer(
      GithubGateway(
        listRepos: ({required token, required page}) async {
          expect(token, 't');
          expect(page, 1);
          return repos;
        },
        listIssues: ({required token, required fullName, state}) async => [],
        listRuns: ({required token, required fullName}) async => [],
        retryRun: ({
          required token,
          required fullName,
          required runId,
        }) async {},
      ),
    );
    addTearDown(container.dispose);

    await expectLater(
      container.read(repoListProvider.future),
      completion(repos),
    );
  });

  test('repoList surfaces auth failure when token is missing', () async {
    final container = ProviderContainer(
      overrides: [
        githubGatewayProvider.overrideWithValue(
          GithubGateway(
            listRepos: ({required token, required page}) async => [],
            listIssues: ({required token, required fullName, state}) async =>
                [],
            listRuns: ({required token, required fullName}) async => [],
            retryRun: ({
              required token,
              required fullName,
              required runId,
            }) async {},
          ),
        ),
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
    const issues = [IssueSummary(number: 7, title: 'Bug')];
    final container = makeContainer(
      GithubGateway(
        listRepos: ({required token, required page}) async => [],
        listIssues: ({required token, required fullName, state}) async {
          expect(fullName, 'octocat/Hello-World');
          return issues;
        },
        listRuns: ({required token, required fullName}) async => [],
        retryRun: ({
          required token,
          required fullName,
          required runId,
        }) async {},
      ),
    );
    addTearDown(container.dispose);

    await expectLater(
      container.read(issueListProvider('octocat/Hello-World').future),
      completion(issues),
    );
  });

  test('runList loads runs and retryRun completes', () async {
    const runs = [RunSummary(runId: 12, status: 'completed')];
    var retried = 0;
    final container = makeContainer(
      GithubGateway(
        listRepos: ({required token, required page}) async => [],
        listIssues: ({required token, required fullName, state}) async => [],
        listRuns: ({required token, required fullName}) async => runs,
        retryRun: ({required token, required fullName, required runId}) async {
          expect(runId, 12);
          retried++;
        },
      ),
    );
    addTearDown(container.dispose);

    await expectLater(
      container.read(runListProvider('o/r').future),
      completion(runs),
    );
    await container.read(retryRunProvider(fullName: 'o/r', runId: 12).future);
    expect(retried, 1);
  });
}
