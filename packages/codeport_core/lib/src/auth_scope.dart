import 'package:flutter_riverpod/flutter_riverpod.dart';

final authTokenProvider = StateProvider<String?>((ref) => null);

final isAuthenticatedProvider = Provider<bool>(
  (ref) => ref.watch(authTokenProvider)?.isNotEmpty ?? false,
);
