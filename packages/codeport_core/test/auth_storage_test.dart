import 'package:codeport_core/codeport_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AuthToken restores persisted token on build', () async {
    final storage = FakeSecureTokenStorage();
    await storage.write('ghp_saved');

    final token = await AuthToken.loadInitial(storage.read);

    expect(token, 'ghp_saved');
  });

  test('AuthToken returns null when nothing persisted', () async {
    final storage = FakeSecureTokenStorage();

    expect(await AuthToken.loadInitial(storage.read), isNull);
  });

  test('AuthToken persists set and clear through storage', () async {
    final storage = FakeSecureTokenStorage();
    final container = ProviderContainer(
      overrides: [secureTokenStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);

    await container.read(authTokenProvider.notifier).set('ghp_new');
    expect(await storage.read(), 'ghp_new');

    await container.read(authTokenProvider.notifier).clear();
    expect(await storage.read(), isNull);
  });

  test('AuthToken restores saved token into state', () async {
    final storage = FakeSecureTokenStorage();
    await storage.write('ghp_saved');
    final container = ProviderContainer(
      overrides: [secureTokenStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);

    container.listen(authTokenProvider, (_, _) {});
    await Future<void>.delayed(const Duration(milliseconds: 100));

    expect(container.read(authTokenProvider), 'ghp_saved');
  });
}
