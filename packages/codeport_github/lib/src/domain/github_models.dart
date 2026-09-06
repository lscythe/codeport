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

class GithubCommit {
  const GithubCommit({
    required this.sha,
    required this.message,
    required this.author,
  });

  final String sha;
  final String message;
  final String author;

  String get shortSha => sha.length > 7 ? sha.substring(0, 7) : sha;
}

class GithubIssueComment {
  const GithubIssueComment({
    required this.id,
    required this.body,
    required this.author,
  });

  final int id;
  final String body;
  final String author;
}

class GithubIssueDetail {
  const GithubIssueDetail({required this.issue, required this.comments});

  final GithubIssue issue;
  final List<GithubIssueComment> comments;
}

class GithubCiJob {
  const GithubCiJob({
    required this.id,
    required this.name,
    required this.status,
    this.conclusion,
  });

  final int id;
  final String name;
  final GithubRunStatus status;
  final GithubRunConclusion? conclusion;
}

class GithubRunDetail {
  const GithubRunDetail({required this.run, required this.jobs});

  final GithubRun run;
  final List<GithubCiJob> jobs;
}
