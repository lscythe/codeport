class GithubFullName {
  const GithubFullName({required this.owner, required this.name});

  final String owner;
  final String name;

  String get value => '$owner/$name';
}

class GithubRepo {
  const GithubRepo({
    required this.id,
    required this.fullName,
    required this.private,
    required this.stars,
    required this.defaultBranch,
  });

  final int id;
  final GithubFullName fullName;
  final bool private;
  final int stars;
  final String defaultBranch;
}

enum GithubIssueState { open, closed }

class GithubIssue {
  const GithubIssue({
    required this.id,
    required this.number,
    required this.title,
    required this.state,
    this.labels = const [],
  });

  final int id;
  final int number;
  final String title;
  final GithubIssueState state;
  final List<String> labels;

  bool get isOpen => state == GithubIssueState.open;
}

enum GithubRunStatus { queued, inProgress, completed }

enum GithubRunConclusion { success, failure, cancelled }

class GithubRun {
  const GithubRun({
    required this.id,
    required this.status,
    this.conclusion,
    required this.runNumber,
  });

  final int id;
  final GithubRunStatus status;
  final GithubRunConclusion? conclusion;
  final int runNumber;

  bool get canRetry =>
      status == GithubRunStatus.completed &&
      conclusion == GithubRunConclusion.failure;
}
