// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(repoList)
final repoListProvider = RepoListProvider._();

final class RepoListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GithubRepoUi>>,
          List<GithubRepoUi>,
          FutureOr<List<GithubRepoUi>>
        >
    with
        $FutureModifier<List<GithubRepoUi>>,
        $FutureProvider<List<GithubRepoUi>> {
  RepoListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'repoListProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$repoListHash();

  @$internal
  @override
  $FutureProviderElement<List<GithubRepoUi>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<GithubRepoUi>> create(Ref ref) {
    return repoList(ref);
  }
}

String _$repoListHash() => r'f5120f3d047c39049abc77829c10a60af81f5e68';

@ProviderFor(issueList)
final issueListProvider = IssueListFamily._();

final class IssueListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GithubIssueUi>>,
          List<GithubIssueUi>,
          FutureOr<List<GithubIssueUi>>
        >
    with
        $FutureModifier<List<GithubIssueUi>>,
        $FutureProvider<List<GithubIssueUi>> {
  IssueListProvider._({
    required IssueListFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'issueListProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$issueListHash();

  @override
  String toString() {
    return r'issueListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<GithubIssueUi>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<GithubIssueUi>> create(Ref ref) {
    final argument = this.argument as String;
    return issueList(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is IssueListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$issueListHash() => r'afe031b2bfeaaea5eb1c2e6d7722adc04290ff12';

final class IssueListFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<GithubIssueUi>>, String> {
  IssueListFamily._()
    : super(
        retry: null,
        name: r'issueListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  IssueListProvider call(String fullName) =>
      IssueListProvider._(argument: fullName, from: this);

  @override
  String toString() => r'issueListProvider';
}

@ProviderFor(runList)
final runListProvider = RunListFamily._();

final class RunListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GithubRunUi>>,
          List<GithubRunUi>,
          FutureOr<List<GithubRunUi>>
        >
    with
        $FutureModifier<List<GithubRunUi>>,
        $FutureProvider<List<GithubRunUi>> {
  RunListProvider._({
    required RunListFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'runListProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$runListHash();

  @override
  String toString() {
    return r'runListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<GithubRunUi>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<GithubRunUi>> create(Ref ref) {
    final argument = this.argument as String;
    return runList(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RunListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$runListHash() => r'0b6fe56c3ae44936c9e4ee252b54ed2a852acd72';

final class RunListFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<GithubRunUi>>, String> {
  RunListFamily._()
    : super(
        retry: null,
        name: r'runListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  RunListProvider call(String fullName) =>
      RunListProvider._(argument: fullName, from: this);

  @override
  String toString() => r'runListProvider';
}

@ProviderFor(runWatch)
final runWatchProvider = RunWatchFamily._();

final class RunWatchProvider
    extends
        $FunctionalProvider<
          AsyncValue<GithubRunUi>,
          GithubRunUi,
          Stream<GithubRunUi>
        >
    with $FutureModifier<GithubRunUi>, $StreamProvider<GithubRunUi> {
  RunWatchProvider._({
    required RunWatchFamily super.from,
    required (String, int) super.argument,
  }) : super(
         retry: null,
         name: r'runWatchProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$runWatchHash();

  @override
  String toString() {
    return r'runWatchProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<GithubRunUi> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<GithubRunUi> create(Ref ref) {
    final argument = this.argument as (String, int);
    return runWatch(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is RunWatchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$runWatchHash() => r'e624d0e9756642bc99694727862bc6a14ad67836';

final class RunWatchFamily extends $Family
    with $FunctionalFamilyOverride<Stream<GithubRunUi>, (String, int)> {
  RunWatchFamily._()
    : super(
        retry: null,
        name: r'runWatchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  RunWatchProvider call(String fullName, int runId) =>
      RunWatchProvider._(argument: (fullName, runId), from: this);

  @override
  String toString() => r'runWatchProvider';
}

@ProviderFor(retryRun)
final retryRunProvider = RetryRunFamily._();

final class RetryRunProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  RetryRunProvider._({
    required RetryRunFamily super.from,
    required ({String fullName, int runId}) super.argument,
  }) : super(
         retry: null,
         name: r'retryRunProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$retryRunHash();

  @override
  String toString() {
    return r'retryRunProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as ({String fullName, int runId});
    return retryRun(ref, fullName: argument.fullName, runId: argument.runId);
  }

  @override
  bool operator ==(Object other) {
    return other is RetryRunProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$retryRunHash() => r'e9261c9b238a694ef6517f8d714baf5c89e8beac';

final class RetryRunFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          ({String fullName, int runId})
        > {
  RetryRunFamily._()
    : super(
        retry: null,
        name: r'retryRunProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  RetryRunProvider call({required String fullName, required int runId}) =>
      RetryRunProvider._(
        argument: (fullName: fullName, runId: runId),
        from: this,
      );

  @override
  String toString() => r'retryRunProvider';
}

@ProviderFor(repoDetail)
final repoDetailProvider = RepoDetailFamily._();

final class RepoDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<GithubRepoUi>,
          GithubRepoUi,
          FutureOr<GithubRepoUi>
        >
    with $FutureModifier<GithubRepoUi>, $FutureProvider<GithubRepoUi> {
  RepoDetailProvider._({
    required RepoDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'repoDetailProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$repoDetailHash();

  @override
  String toString() {
    return r'repoDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<GithubRepoUi> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GithubRepoUi> create(Ref ref) {
    final argument = this.argument as String;
    return repoDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RepoDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$repoDetailHash() => r'609d2fe2e1b4579c1f9ff677926247bf87af2468';

final class RepoDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<GithubRepoUi>, String> {
  RepoDetailFamily._()
    : super(
        retry: null,
        name: r'repoDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  RepoDetailProvider call(String fullName) =>
      RepoDetailProvider._(argument: fullName, from: this);

  @override
  String toString() => r'repoDetailProvider';
}

@ProviderFor(commitList)
final commitListProvider = CommitListFamily._();

final class CommitListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GithubCommitUi>>,
          List<GithubCommitUi>,
          FutureOr<List<GithubCommitUi>>
        >
    with
        $FutureModifier<List<GithubCommitUi>>,
        $FutureProvider<List<GithubCommitUi>> {
  CommitListProvider._({
    required CommitListFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'commitListProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$commitListHash();

  @override
  String toString() {
    return r'commitListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<GithubCommitUi>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<GithubCommitUi>> create(Ref ref) {
    final argument = this.argument as String;
    return commitList(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CommitListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$commitListHash() => r'4701721ad11326408a59f770453a365e3106cd48';

final class CommitListFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<GithubCommitUi>>, String> {
  CommitListFamily._()
    : super(
        retry: null,
        name: r'commitListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  CommitListProvider call(String fullName) =>
      CommitListProvider._(argument: fullName, from: this);

  @override
  String toString() => r'commitListProvider';
}

@ProviderFor(issueDetail)
final issueDetailProvider = IssueDetailFamily._();

final class IssueDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<GithubIssueDetailUi>,
          GithubIssueDetailUi,
          FutureOr<GithubIssueDetailUi>
        >
    with
        $FutureModifier<GithubIssueDetailUi>,
        $FutureProvider<GithubIssueDetailUi> {
  IssueDetailProvider._({
    required IssueDetailFamily super.from,
    required (String, int) super.argument,
  }) : super(
         retry: null,
         name: r'issueDetailProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$issueDetailHash();

  @override
  String toString() {
    return r'issueDetailProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<GithubIssueDetailUi> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GithubIssueDetailUi> create(Ref ref) {
    final argument = this.argument as (String, int);
    return issueDetail(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is IssueDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$issueDetailHash() => r'513da4ab39480d62bb73be72cf02b8cc7c3c2e4c';

final class IssueDetailFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<GithubIssueDetailUi>,
          (String, int)
        > {
  IssueDetailFamily._()
    : super(
        retry: null,
        name: r'issueDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  IssueDetailProvider call(String fullName, int number) =>
      IssueDetailProvider._(argument: (fullName, number), from: this);

  @override
  String toString() => r'issueDetailProvider';
}

@ProviderFor(createIssue)
final createIssueProvider = CreateIssueFamily._();

final class CreateIssueProvider
    extends
        $FunctionalProvider<
          AsyncValue<GithubIssueUi>,
          GithubIssueUi,
          FutureOr<GithubIssueUi>
        >
    with $FutureModifier<GithubIssueUi>, $FutureProvider<GithubIssueUi> {
  CreateIssueProvider._({
    required CreateIssueFamily super.from,
    required (String, String, {String? body}) super.argument,
  }) : super(
         retry: null,
         name: r'createIssueProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$createIssueHash();

  @override
  String toString() {
    return r'createIssueProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<GithubIssueUi> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GithubIssueUi> create(Ref ref) {
    final argument = this.argument as (String, String, {String? body});
    return createIssue(ref, argument.$1, argument.$2, body: argument.body);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateIssueProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$createIssueHash() => r'0e5a1af1007552c51198b0bc4e1a95a55fa5f0ce';

final class CreateIssueFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<GithubIssueUi>,
          (String, String, {String? body})
        > {
  CreateIssueFamily._()
    : super(
        retry: null,
        name: r'createIssueProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  CreateIssueProvider call(String fullName, String title, {String? body}) =>
      CreateIssueProvider._(
        argument: (fullName, title, body: body),
        from: this,
      );

  @override
  String toString() => r'createIssueProvider';
}

@ProviderFor(closeIssue)
final closeIssueProvider = CloseIssueFamily._();

final class CloseIssueProvider
    extends
        $FunctionalProvider<
          AsyncValue<GithubIssueUi>,
          GithubIssueUi,
          FutureOr<GithubIssueUi>
        >
    with $FutureModifier<GithubIssueUi>, $FutureProvider<GithubIssueUi> {
  CloseIssueProvider._({
    required CloseIssueFamily super.from,
    required (String, int) super.argument,
  }) : super(
         retry: null,
         name: r'closeIssueProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$closeIssueHash();

  @override
  String toString() {
    return r'closeIssueProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<GithubIssueUi> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GithubIssueUi> create(Ref ref) {
    final argument = this.argument as (String, int);
    return closeIssue(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is CloseIssueProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$closeIssueHash() => r'178891e37081b35131e1f84c536a19190fd29984';

final class CloseIssueFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<GithubIssueUi>, (String, int)> {
  CloseIssueFamily._()
    : super(
        retry: null,
        name: r'closeIssueProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  CloseIssueProvider call(String fullName, int number) =>
      CloseIssueProvider._(argument: (fullName, number), from: this);

  @override
  String toString() => r'closeIssueProvider';
}

@ProviderFor(reopenIssue)
final reopenIssueProvider = ReopenIssueFamily._();

final class ReopenIssueProvider
    extends
        $FunctionalProvider<
          AsyncValue<GithubIssueUi>,
          GithubIssueUi,
          FutureOr<GithubIssueUi>
        >
    with $FutureModifier<GithubIssueUi>, $FutureProvider<GithubIssueUi> {
  ReopenIssueProvider._({
    required ReopenIssueFamily super.from,
    required (String, int) super.argument,
  }) : super(
         retry: null,
         name: r'reopenIssueProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$reopenIssueHash();

  @override
  String toString() {
    return r'reopenIssueProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<GithubIssueUi> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GithubIssueUi> create(Ref ref) {
    final argument = this.argument as (String, int);
    return reopenIssue(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is ReopenIssueProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$reopenIssueHash() => r'61c3b210cc090ae60e58bd7e03b62030dcd36313';

final class ReopenIssueFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<GithubIssueUi>, (String, int)> {
  ReopenIssueFamily._()
    : super(
        retry: null,
        name: r'reopenIssueProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  ReopenIssueProvider call(String fullName, int number) =>
      ReopenIssueProvider._(argument: (fullName, number), from: this);

  @override
  String toString() => r'reopenIssueProvider';
}

@ProviderFor(createComment)
final createCommentProvider = CreateCommentFamily._();

final class CreateCommentProvider
    extends
        $FunctionalProvider<
          AsyncValue<GithubIssueCommentUi>,
          GithubIssueCommentUi,
          FutureOr<GithubIssueCommentUi>
        >
    with
        $FutureModifier<GithubIssueCommentUi>,
        $FutureProvider<GithubIssueCommentUi> {
  CreateCommentProvider._({
    required CreateCommentFamily super.from,
    required (String, int, String) super.argument,
  }) : super(
         retry: null,
         name: r'createCommentProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$createCommentHash();

  @override
  String toString() {
    return r'createCommentProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<GithubIssueCommentUi> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GithubIssueCommentUi> create(Ref ref) {
    final argument = this.argument as (String, int, String);
    return createComment(ref, argument.$1, argument.$2, argument.$3);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateCommentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$createCommentHash() => r'7670284c18ecf366589e32b5a4a015d8796d8e9a';

final class CreateCommentFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<GithubIssueCommentUi>,
          (String, int, String)
        > {
  CreateCommentFamily._()
    : super(
        retry: null,
        name: r'createCommentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  CreateCommentProvider call(String fullName, int number, String body) =>
      CreateCommentProvider._(argument: (fullName, number, body), from: this);

  @override
  String toString() => r'createCommentProvider';
}

@ProviderFor(runDetail)
final runDetailProvider = RunDetailFamily._();

final class RunDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<GithubRunDetailUi>,
          GithubRunDetailUi,
          FutureOr<GithubRunDetailUi>
        >
    with
        $FutureModifier<GithubRunDetailUi>,
        $FutureProvider<GithubRunDetailUi> {
  RunDetailProvider._({
    required RunDetailFamily super.from,
    required (String, int) super.argument,
  }) : super(
         retry: null,
         name: r'runDetailProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$runDetailHash();

  @override
  String toString() {
    return r'runDetailProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<GithubRunDetailUi> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GithubRunDetailUi> create(Ref ref) {
    final argument = this.argument as (String, int);
    return runDetail(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is RunDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$runDetailHash() => r'8e8a3bdd3e6533da2bdafaca9a0f72149451a959';

final class RunDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<GithubRunDetailUi>, (String, int)> {
  RunDetailFamily._()
    : super(
        retry: null,
        name: r'runDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  RunDetailProvider call(String fullName, int runId) =>
      RunDetailProvider._(argument: (fullName, runId), from: this);

  @override
  String toString() => r'runDetailProvider';
}

@ProviderFor(jobList)
final jobListProvider = JobListFamily._();

final class JobListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GithubCiJobUi>>,
          List<GithubCiJobUi>,
          FutureOr<List<GithubCiJobUi>>
        >
    with
        $FutureModifier<List<GithubCiJobUi>>,
        $FutureProvider<List<GithubCiJobUi>> {
  JobListProvider._({
    required JobListFamily super.from,
    required (String, int) super.argument,
  }) : super(
         retry: null,
         name: r'jobListProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$jobListHash();

  @override
  String toString() {
    return r'jobListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<GithubCiJobUi>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<GithubCiJobUi>> create(Ref ref) {
    final argument = this.argument as (String, int);
    return jobList(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is JobListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$jobListHash() => r'c582d71d7e42906b8ec86a8b4ca35968c12de0c8';

final class JobListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<GithubCiJobUi>>,
          (String, int)
        > {
  JobListFamily._()
    : super(
        retry: null,
        name: r'jobListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  JobListProvider call(String fullName, int runId) =>
      JobListProvider._(argument: (fullName, runId), from: this);

  @override
  String toString() => r'jobListProvider';
}
