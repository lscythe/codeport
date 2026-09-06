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

String _$repoListHash() => r'ec73233f818ba657f8680fd1e4b49727f1e0fca1';

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
