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
          AsyncValue<List<RepoSummary>>,
          List<RepoSummary>,
          FutureOr<List<RepoSummary>>
        >
    with
        $FutureModifier<List<RepoSummary>>,
        $FutureProvider<List<RepoSummary>> {
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
  $FutureProviderElement<List<RepoSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RepoSummary>> create(Ref ref) {
    return repoList(ref);
  }
}

String _$repoListHash() => r'e10ede27c4720fb39969acaf6c37a678232f5044';

@ProviderFor(issueList)
final issueListProvider = IssueListFamily._();

final class IssueListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<IssueSummary>>,
          List<IssueSummary>,
          FutureOr<List<IssueSummary>>
        >
    with
        $FutureModifier<List<IssueSummary>>,
        $FutureProvider<List<IssueSummary>> {
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
  $FutureProviderElement<List<IssueSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<IssueSummary>> create(Ref ref) {
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

String _$issueListHash() => r'bd928d09f7d372c8955e5b6f80685e6ea8c7fad9';

final class IssueListFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<IssueSummary>>, String> {
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
          AsyncValue<List<RunSummary>>,
          List<RunSummary>,
          FutureOr<List<RunSummary>>
        >
    with $FutureModifier<List<RunSummary>>, $FutureProvider<List<RunSummary>> {
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
  $FutureProviderElement<List<RunSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RunSummary>> create(Ref ref) {
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

String _$runListHash() => r'adf7f8d3489b052e72611268ae6cd8fbd262cbae';

final class RunListFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<RunSummary>>, String> {
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
