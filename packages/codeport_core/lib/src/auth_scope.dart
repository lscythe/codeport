import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_scope.g.dart';

@riverpod
class AuthToken extends _$AuthToken {
  @override
  String? build() => null;

  void set(String? token) => state = token;
  void clear() => state = null;
}

final isAuthenticatedProvider = Provider<bool>(
  (ref) => ref.watch(authTokenProvider)?.isNotEmpty ?? false,
);
