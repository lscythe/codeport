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
