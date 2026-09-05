import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'failures.dart';

abstract class UseCaseNotifier<S> extends AsyncNotifier<S> {
  Future<T> guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } catch (e) {
      throw AppFailure.fromRust(e);
    }
  }
}

class UseCaseGuard {
  const UseCaseGuard._();

  static Future<T> guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } catch (e) {
      throw AppFailure.fromRust(e);
    }
  }
}
