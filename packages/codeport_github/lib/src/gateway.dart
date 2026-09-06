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
  );
}
