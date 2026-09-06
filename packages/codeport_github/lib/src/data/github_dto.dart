import '../domain/github_models.dart';

class GithubRepoPage {
  const GithubRepoPage({required this.repos, this.nextPage});

  final List<GithubRepoDto> repos;
  final int? nextPage;
}

class GithubRepoDto {
  const GithubRepoDto({
    required this.id,
    required this.fullName,
    required this.private,
    required this.stars,
    required this.defaultBranch,
  });

  final int id;
  final String fullName;
  final bool private;
  final int stars;
  final String defaultBranch;

  GithubRepo toDomain() {
    final separator = fullName.indexOf('/');
    return GithubRepo(
      id: id,
      fullName: GithubFullName(
        owner: fullName.substring(0, separator),
        name: fullName.substring(separator + 1),
      ),
      private: private,
      stars: stars,
      defaultBranch: defaultBranch,
    );
  }
}

class GithubIssueDto {
  const GithubIssueDto({
    required this.id,
    required this.number,
    required this.title,
    required this.state,
    this.labels = const [],
  });

  final int id;
  final int number;
  final String title;
  final String state;
  final List<String> labels;

  GithubIssue toDomain() {
    return GithubIssue(
      id: id,
      number: number,
      title: title,
      state: state == 'closed'
          ? GithubIssueState.closed
          : GithubIssueState.open,
      labels: labels,
    );
  }
}

class GithubRunDto {
  const GithubRunDto({
    required this.id,
    required this.status,
    this.conclusion,
    required this.runNumber,
  });

  final int id;
  final String status;
  final String? conclusion;
  final int runNumber;

  GithubRun toDomain() {
    return GithubRun(
      id: id,
      status: _runStatus(status),
      conclusion: _runConclusion(conclusion),
      runNumber: runNumber,
    );
  }
}

GithubRunStatus _runStatus(String raw) {
  return switch (raw) {
    'completed' => GithubRunStatus.completed,
    'inProgress' || 'in_progress' => GithubRunStatus.inProgress,
    _ => GithubRunStatus.queued,
  };
}

GithubRunConclusion? _runConclusion(String? raw) {
  return switch (raw) {
    'success' => GithubRunConclusion.success,
    'failure' => GithubRunConclusion.failure,
    'cancelled' => GithubRunConclusion.cancelled,
    _ => null,
  };
}

class GithubCommitDto {
  const GithubCommitDto({
    required this.sha,
    required this.message,
    required this.author,
  });

  final String sha;
  final String message;
  final String author;

  GithubCommit toDomain() {
    return GithubCommit(sha: sha, message: message, author: author);
  }
}

class GithubIssueCommentDto {
  const GithubIssueCommentDto({
    required this.id,
    required this.body,
    required this.author,
  });

  final int id;
  final String body;
  final String author;

  GithubIssueComment toDomain() {
    return GithubIssueComment(id: id, body: body, author: author);
  }
}

class GithubCiJobDto {
  const GithubCiJobDto({
    required this.id,
    required this.name,
    required this.status,
    this.conclusion,
  });

  final int id;
  final String name;
  final String status;
  final String? conclusion;

  GithubCiJob toDomain() {
    return GithubCiJob(
      id: id,
      name: name,
      status: _runStatus(status),
      conclusion: _runConclusion(conclusion),
    );
  }
}
