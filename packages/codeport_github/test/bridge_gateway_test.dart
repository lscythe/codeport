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

    final gateway = emptyBridge(
      fetchRepos: ({required token, required page}) async =>
          GithubRepoPage(repos: dtos),
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

    final gateway = emptyBridge(
      fetchIssues: ({required token, required fullName, state}) async {
        expect(fullName, 'o/r');
        return issueDtos;
      },
      fetchRuns: ({required token, required fullName}) async => runDtos,
    );

    final issues = await gateway.fetchIssues(token: 't', fullName: 'o/r');
    final runs = await gateway.fetchRuns(token: 't', fullName: 'o/r');

    expect(issues.single.state, GithubIssueState.open);
    expect(runs.single.canRetry, isTrue);
  });

  test('fetches issue detail with comments', () async {
    final gateway = emptyBridge(
      fetchIssue:
          ({required token, required fullName, required number}) async =>
              GithubIssueDto(
                id: 1,
                number: number,
                title: 'Bug',
                state: 'open',
              ),
      fetchComments: ({
        required token,
        required fullName,
        required number,
      }) async => [GithubIssueCommentDto(id: 5, body: 'Hi', author: 'a')],
    );

    final detail = await gateway.fetchIssueDetail(
      token: 't',
      fullName: 'o/r',
      number: 7,
    );

    expect(detail.issue.number, 7);
    expect(detail.comments.single.body, 'Hi');
  });

  test('creates and closes issues', () async {
    final gateway = emptyBridge(
      createIssue: ({
        required token,
        required fullName,
        required title,
        body,
      }) async => GithubIssueDto(id: 1, number: 8, title: title, state: 'open'),
      closeIssue:
          ({required token, required fullName, required number}) async =>
              GithubIssueDto(
                id: 1,
                number: number,
                title: 'Bug',
                state: 'closed',
              ),
    );

    final created = await gateway.createIssue(
      token: 't',
      fullName: 'o/r',
      title: 'Bug',
    );
    expect(created.number, 8);

    final closed = await gateway.closeIssue(
      token: 't',
      fullName: 'o/r',
      number: 8,
    );
    expect(closed.state, GithubIssueState.closed);
  });

  test('fetches run detail with jobs', () async {
    final gateway = emptyBridge(
      fetchRun: ({required token, required fullName, required runId}) async =>
          GithubRunDto(
            id: runId,
            status: 'completed',
            conclusion: 'failure',
            runNumber: 12,
          ),
      fetchJobs: ({required token, required fullName, required runId}) async =>
          [
            GithubCiJobDto(
              id: 9,
              name: 'build',
              status: 'completed',
              conclusion: 'success',
            ),
          ],
    );

    final detail = await gateway.fetchRunDetail(
      token: 't',
      fullName: 'o/r',
      runId: 12,
    );

    expect(detail.run.canRetry, isTrue);
    expect(detail.jobs.single.name, 'build');
  });
}
