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
  });
}
