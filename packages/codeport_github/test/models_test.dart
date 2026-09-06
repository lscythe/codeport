import 'package:flutter_test/flutter_test.dart';

import 'package:codeport_github/src/data/github_dto.dart';
import 'package:codeport_github/src/domain/github_models.dart';
import 'package:codeport_github/src/ui/github_ui_models.dart';

void main() {
  group('GithubRepoDto', () {
    test('round-trips through fromData', () {
      const dto = GithubRepoDto(
        id: 1,
        fullName: 'octocat/Hello-World',
        private: false,
        stars: 80,
        defaultBranch: 'main',
      );

      final domain = dto.toDomain();

      expect(domain.fullName.owner, 'octocat');
      expect(domain.fullName.name, 'Hello-World');
    });
  });

  group('GithubIssueDto', () {
    test('maps open state', () {
      const dto = GithubIssueDto(
        id: 1,
        number: 7,
        title: 'Bug',
        state: 'open',
        labels: ['bug'],
      );

      expect(dto.toDomain().state, GithubIssueState.open);
    });
  });

  group('GithubRunDto', () {
    test('maps failed conclusion', () {
      const dto = GithubRunDto(
        id: 1,
        status: 'completed',
        conclusion: 'failure',
        runNumber: 12,
      );

      final domain = dto.toDomain();

      expect(domain.status, GithubRunStatus.completed);
      expect(domain.conclusion, GithubRunConclusion.failure);
      expect(domain.canRetry, isTrue);
    });

    test('in-progress run cannot retry', () {
      const dto = GithubRunDto(id: 2, status: 'in_progress', runNumber: 13);

      expect(dto.toDomain().canRetry, isFalse);
    });
  });

  group('ui models', () {
    test('GithubRepoUi formats stars', () {
      const ui = GithubRepoUi(
        fullName: 'octocat/Hello-World',
        private: false,
        starsLabel: '80',
      );

      expect(ui.displayName, 'octocat/Hello-World');
    });

    test('GithubCommitDto shortens sha', () {
      const dto = GithubCommitDto(
        sha: 'abcdef123456',
        message: 'Hi',
        author: 'a',
      );

      expect(dto.toDomain().shortSha, 'abcdef1');
      expect(GithubCommitUi.fromDomain(dto.toDomain()).shortSha, 'abcdef1');
    });

    test('GithubIssueDetailUi counts comments', () {
      final detail = GithubIssueDetail(
        issue: GithubIssue(
          id: 1,
          number: 7,
          title: 'Bug',
          state: GithubIssueState.open,
        ),
        comments: [
          GithubIssueComment(id: 5, body: 'Hi', author: 'a'),
          GithubIssueComment(id: 6, body: 'Yo', author: 'b'),
        ],
      );

      final ui = GithubIssueDetailUi.fromDomain(detail);

      expect(ui.commentCountLabel, '2 comments');
      expect(ui.issue.stateLabel, 'Open');
    });

    test('GithubRunDetailUi maps jobs', () {
      final detail = GithubRunDetail(
        run: GithubRun(
          id: 12,
          status: GithubRunStatus.completed,
          conclusion: GithubRunConclusion.failure,
          runNumber: 12,
        ),
        jobs: [
          GithubCiJob(
            id: 9,
            name: 'build',
            status: GithubRunStatus.completed,
            conclusion: GithubRunConclusion.success,
          ),
        ],
      );

      final ui = GithubRunDetailUi.fromDomain(detail);

      expect(ui.run.statusLabel, 'Failed');
      expect(ui.jobs.single.statusLabel, 'Passed');
    });
  });
}
