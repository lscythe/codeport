import 'package:codeport_github/src/data/bridge_gateway.dart';
import 'package:codeport_github/src/data/frb_datasource.dart';
import 'package:codeport_github/src/data/github_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  FrbGithubDataSource fakeSource() {
    return FrbGithubDataSource(
      listRepos: ({required token, required page}) async => [],
      listIssues: ({required token, required fullName, state}) async => [],
      listRuns: ({required token, required fullName}) async => [],
      retryRun: ({required token, required fullName, required runId}) async {},
    );
  }

  test('FrbGithubDataSource maps issue records to DTOs', () async {
    var sawState = '';
    final source = FrbGithubDataSource(
      listRepos: ({required token, required page}) async => [],
      listIssues: ({required token, required fullName, state}) async {
        sawState = state ?? 'none';
        return [
          FrbIssueRecord(
            id: BigInt.from(1),
            number: BigInt.from(7),
            title: 'Bug',
            state: 'open',
            labels: ['bug'],
          ),
        ];
      },
      listRuns: ({required token, required fullName}) async => [],
      retryRun: ({required token, required fullName, required runId}) async {},
    );

    final dtos = await source.asFetchIssues(
      token: 't',
      fullName: 'o/r',
      state: 'open',
    );

    expect(sawState, 'open');
    expect(dtos.single.number, 7);
    expect(dtos.single.labels, ['bug']);
  });

  test('FrbGithubDataSource maps run records to DTOs', () async {
    final source = FrbGithubDataSource(
      listRepos: ({required token, required page}) async => [],
      listIssues: ({required token, required fullName, state}) async => [],
      listRuns: ({required token, required fullName}) async => [
        FrbRunRecord(
          id: BigInt.from(1),
          status: 'completed',
          conclusion: 'failure',
          runNumber: BigInt.from(12),
        ),
      ],
      retryRun: ({required token, required fullName, required runId}) async {},
    );

    final dtos = await source.asFetchRuns(token: 't', fullName: 'o/r');

    expect(dtos.single.runNumber, 12);
    expect(dtos.single.toDomain().canRetry, isTrue);
  });

  test('BridgeGateway wires a datasource end to end', () async {
    final source = fakeSource();
    final gateway = emptyBridge(
      fetchRepos: source.asFetchRepos,
      fetchIssues: source.asFetchIssues,
      fetchRuns: source.asFetchRuns,
    );

    expect((await gateway.fetchRepoPage(token: 't', page: 1)).items, isEmpty);
    expect(await gateway.fetchIssues(token: 't', fullName: 'o/r'), isEmpty);
    expect(await gateway.fetchRuns(token: 't', fullName: 'o/r'), isEmpty);
  });

  test('FrbGithubDataSource maps FRB types to DTOs', () async {
    var sawPage = 0;
    final source = FrbGithubDataSource(
      listRepos: ({required token, required page}) async {
        sawPage = page;
        return [
          FrbRepoRecord(
            id: BigInt.from(1),
            fullName: 'octocat/Hello-World',
            private: false,
            stars: BigInt.from(80),
            defaultBranch: 'main',
          ),
        ];
      },
      listIssues: ({required token, required fullName, state}) async => [],
      listRuns: ({required token, required fullName}) async => [],
      retryRun: ({required token, required fullName, required runId}) async {},
    );

    final result = await source.asFetchRepos(token: 't', page: 2);
    final dtos = result.repos;

    expect(sawPage, 2);
    expect(dtos.single, isA<GithubRepoDto>());
    expect(dtos.single.fullName, 'octocat/Hello-World');
    expect(dtos.single.stars, 80);
  });
}
