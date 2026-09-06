import 'package:flutter_test/flutter_test.dart';

import 'package:codeport_github/src/data/bridge_gateway.dart';
import 'package:codeport_github/src/data/github_dto.dart';
import 'package:codeport_github/src/domain/github_models.dart';

void main() {
  test('maps bridge repos to domain', () async {
    const dtos = [
      GithubRepoDto(
        id: 1,
        fullName: 'octocat/Hello-World',
        private: false,
        stars: 80,
        defaultBranch: 'main',
      ),
    ];

    final gateway = BridgeGateway(
      fetchRepos: ({required token, required page}) async =>
          GithubRepoPage(repos: dtos),
      fetchIssues: ({required token, required fullName, state}) async => [],
      fetchRuns: ({required token, required fullName}) async => [],
      doRetry: ({required token, required fullName, required runId}) async {},
    );

    final page = await gateway.fetchRepoPage(token: 't', page: 1);
    final repos = page.items;

    expect(repos.single.fullName.value, 'octocat/Hello-World');
    expect(repos.single.stars, 80);
  });

  test('maps bridge issues and runs to domain', () async {
    const issueDtos = [
      GithubIssueDto(id: 1, number: 7, title: 'Bug', state: 'open'),
    ];
    const runDtos = [
      GithubRunDto(
        id: 1,
        status: 'completed',
        conclusion: 'failure',
        runNumber: 12,
      ),
    ];

    final gateway = BridgeGateway(
      fetchRepos: ({required token, required page}) async =>
          const GithubRepoPage(repos: []),
      fetchIssues: ({required token, required fullName, state}) async {
        expect(fullName, 'o/r');
        return issueDtos;
      },
      fetchRuns: ({required token, required fullName}) async => runDtos,
      doRetry: ({required token, required fullName, required runId}) async {},
    );

    final issues = await gateway.fetchIssues(token: 't', fullName: 'o/r');
    final runs = await gateway.fetchRuns(token: 't', fullName: 'o/r');

    expect(issues.single.state, GithubIssueState.open);
    expect(runs.single.canRetry, isTrue);
  });
}
