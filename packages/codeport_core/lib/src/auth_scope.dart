import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'token_storage.dart';

part 'auth_scope.g.dart';

final secureTokenStorageProvider = Provider<SecureTokenStorage>((ref) {
  throw UnimplementedError('Override with a platform SecureTokenStorage');
});

@riverpod
class AuthToken extends _$AuthToken {
  @override
  String? build() {
    _restore();
    return null;
  }

  Future<void> _restore() async {
    final storage = ref.read(secureTokenStorageProvider);
    final saved = await loadInitial(storage.read);
    if (saved != null && saved.isNotEmpty) {
      state = saved;
    }
  }

  static Future<String?> loadInitial(ReadToken read) => read();

  Future<void> set(String? token) async {
    final storage = ref.read(secureTokenStorageProvider);
    if (token == null || token.isEmpty) {
      await storage.delete();
    } else {
      await storage.write(token);
    }
    state = token;
  }

  Future<void> clear() => set(null);
}

final isAuthenticatedProvider = Provider<bool>(
  (ref) => ref.watch(authTokenProvider)?.isNotEmpty ?? false,
);
