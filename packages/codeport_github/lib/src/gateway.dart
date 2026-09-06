import 'package:codeport_core/codeport_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/bridge_gateway.dart';
import 'data/frb_datasource.dart' show liveBridgeGateway;
import 'domain/github_models.dart';

class GithubGateway {
  const GithubGateway({
    required this.listRepoPage,
    required this.listIssues,
    required this.listRuns,
    required this.retryRun,
    required this.watchRun,
    required this.getRepo,
    required this.listCommits,
    required this.getIssue,
    required this.createIssue,
    required this.closeIssue,
    required this.reopenIssue,
    required this.createComment,
    required this.getRun,
    required this.listJobs,
  });

  final Future<Page<GithubRepo>> Function({
    required String token,
    required int page,
  })
  listRepoPage;
  final Future<List<GithubIssue>> Function({
    required String token,
    required String fullName,
    String? state,
  })
  listIssues;
  final Future<List<GithubRun>> Function({
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
  final Stream<GithubRun> Function({
    required String token,
    required String fullName,
    required int runId,
  })
  watchRun;
  final Future<GithubRepo> Function({
    required String token,
    required String fullName,
  })
  getRepo;
  final Future<List<GithubCommit>> Function({
    required String token,
    required String fullName,
  })
  listCommits;
  final Future<GithubIssueDetail> Function({
    required String token,
    required String fullName,
    required int number,
  })
  getIssue;
  final Future<GithubIssue> Function({
    required String token,
    required String fullName,
    required String title,
    String? body,
  })
  createIssue;
  final Future<GithubIssue> Function({
    required String token,
    required String fullName,
    required int number,
  })
  closeIssue;
  final Future<GithubIssue> Function({
    required String token,
    required String fullName,
    required int number,
  })
  reopenIssue;
  final Future<GithubIssueComment> Function({
    required String token,
    required String fullName,
    required int number,
    required String body,
  })
  createComment;
  final Future<GithubRunDetail> Function({
    required String token,
    required String fullName,
    required int runId,
  })
  getRun;
  final Future<List<GithubCiJob>> Function({
    required String token,
    required String fullName,
    required int runId,
  })
  listJobs;

  Future<List<GithubIssueComment>> listComments({
    required String token,
    required String fullName,
    required int number,
  }) async {
    final detail = await getIssue(
      token: token,
      fullName: fullName,
      number: number,
    );
    return detail.comments;
  }
}

final githubGatewayProvider = Provider<GithubGateway>((ref) {
  throw UnimplementedError('Override with a real or fake gateway');
});

final bridgeGatewayProvider = Provider<BridgeGateway>((ref) {
  return liveBridgeGateway();
});

GithubGateway domainGateway(BridgeGateway bridge) {
  return GithubGateway(
    listRepoPage: ({required token, required page}) =>
        bridge.fetchRepoPage(token: token, page: page),
    listIssues: ({required token, required fullName, state}) =>
        bridge.fetchIssues(token: token, fullName: fullName, state: state),
    listRuns: ({required token, required fullName}) =>
        bridge.fetchRuns(token: token, fullName: fullName),
    retryRun: ({required token, required fullName, required runId}) =>
        bridge.doRetry(token: token, fullName: fullName, runId: runId),
    watchRun: ({required token, required fullName, required int runId}) =>
        bridge.watchRun(token: token, fullName: fullName, runId: runId),
    getRepo: ({required token, required fullName}) =>
        bridge.fetchRepo(token: token, fullName: fullName),
    listCommits: ({required token, required fullName}) =>
        bridge.fetchCommits(token: token, fullName: fullName),
    getIssue: ({required token, required fullName, required int number}) =>
        bridge.fetchIssueDetail(
          token: token,
          fullName: fullName,
          number: number,
        ),
    createIssue:
        ({required token, required fullName, required String title, body}) =>
            bridge.createIssue(
              token: token,
              fullName: fullName,
              title: title,
              body: body,
            ),
    closeIssue: ({required token, required fullName, required int number}) =>
        bridge.closeIssue(token: token, fullName: fullName, number: number),
    reopenIssue: ({required token, required fullName, required int number}) =>
        bridge.reopenIssue(token: token, fullName: fullName, number: number),
    createComment:
        ({
          required token,
          required fullName,
          required int number,
          required String body,
        }) => bridge.createComment(
          token: token,
          fullName: fullName,
          number: number,
          body: body,
        ),
    getRun: ({required token, required fullName, required int runId}) =>
        bridge.fetchRunDetail(token: token, fullName: fullName, runId: runId),
    listJobs: ({required token, required fullName, required int runId}) async {
      final detail = await bridge.fetchRunDetail(
        token: token,
        fullName: fullName,
        runId: runId,
      );
      return detail.jobs;
    },
  );
}
