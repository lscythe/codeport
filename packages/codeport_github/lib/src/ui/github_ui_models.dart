import '../domain/github_models.dart';

class GithubRepoUi {
  const GithubRepoUi({
    required this.fullName,
    required this.private,
    required this.starsLabel,
  });

  final String fullName;
  final bool private;
  final String starsLabel;

  String get displayName => fullName;

  static GithubRepoUi fromDomain(GithubRepo repo) {
    return GithubRepoUi(
      fullName: repo.fullName.value,
      private: repo.private,
      starsLabel: _compact(repo.stars),
    );
  }
}

class GithubIssueUi {
  const GithubIssueUi({
    required this.number,
    required this.title,
    required this.stateLabel,
  });

  final int number;
  final String title;
  final String stateLabel;

  static GithubIssueUi fromDomain(GithubIssue issue) {
    return GithubIssueUi(
      number: issue.number,
      title: issue.title,
      stateLabel: issue.isOpen ? 'Open' : 'Closed',
    );
  }
}

class GithubRunUi {
  const GithubRunUi({
    required this.runId,
    required this.statusLabel,
    required this.canRetry,
  });

  final int runId;
  final String statusLabel;
  final bool canRetry;

  static GithubRunUi fromDomain(GithubRun run) {
    return GithubRunUi(
      runId: run.id,
      statusLabel: switch (run.status) {
        GithubRunStatus.queued => 'Queued',
        GithubRunStatus.inProgress => 'In progress',
        GithubRunStatus.completed => switch (run.conclusion) {
          GithubRunConclusion.success => 'Passed',
          GithubRunConclusion.failure => 'Failed',
          GithubRunConclusion.cancelled => 'Cancelled',
          null => 'Completed',
        },
      },
      canRetry: run.canRetry,
    );
  }
}

String _compact(int stars) {
  if (stars >= 1000) return '${(stars / 1000).toStringAsFixed(1)}k';
  return '$stars';
}

class GithubCommitUi {
  const GithubCommitUi({
    required this.shortSha,
    required this.message,
    required this.author,
  });

  final String shortSha;
  final String message;
  final String author;

  static GithubCommitUi fromDomain(GithubCommit commit) {
    return GithubCommitUi(
      shortSha: commit.shortSha,
      message: commit.message,
      author: commit.author,
    );
  }
}

class GithubIssueCommentUi {
  const GithubIssueCommentUi({required this.body, required this.author});

  final String body;
  final String author;

  static GithubIssueCommentUi fromDomain(GithubIssueComment comment) {
    return GithubIssueCommentUi(body: comment.body, author: comment.author);
  }
}

class GithubIssueDetailUi {
  const GithubIssueDetailUi({
    required this.issue,
    required this.comments,
    required this.commentCountLabel,
  });

  final GithubIssueUi issue;
  final List<GithubIssueCommentUi> comments;
  final String commentCountLabel;

  static GithubIssueDetailUi fromDomain(GithubIssueDetail detail) {
    return GithubIssueDetailUi(
      issue: GithubIssueUi.fromDomain(detail.issue),
      comments: detail.comments.map(GithubIssueCommentUi.fromDomain).toList(),
      commentCountLabel: '${detail.comments.length} comments',
    );
  }
}

class GithubCiJobUi {
  const GithubCiJobUi({required this.name, required this.statusLabel});

  final String name;
  final String statusLabel;

  static GithubCiJobUi fromDomain(GithubCiJob job) {
    return GithubCiJobUi(
      name: job.name,
      statusLabel: switch (job.status) {
        GithubRunStatus.queued => 'Queued',
        GithubRunStatus.inProgress => 'In progress',
        GithubRunStatus.completed => switch (job.conclusion) {
          GithubRunConclusion.success => 'Passed',
          GithubRunConclusion.failure => 'Failed',
          GithubRunConclusion.cancelled => 'Cancelled',
          null => 'Completed',
        },
      },
    );
  }
}

class GithubRunDetailUi {
  const GithubRunDetailUi({required this.run, required this.jobs});

  final GithubRunUi run;
  final List<GithubCiJobUi> jobs;

  static GithubRunDetailUi fromDomain(GithubRunDetail detail) {
    return GithubRunDetailUi(
      run: GithubRunUi.fromDomain(detail.run),
      jobs: detail.jobs.map(GithubCiJobUi.fromDomain).toList(),
    );
  }
}
