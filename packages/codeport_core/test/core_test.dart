import 'package:flutter_test/flutter_test.dart';
import 'package:codeport_core/codeport_core.dart';

void main() {
  test('guard maps same Rust failure message to one AppFailure', () async {
    final a = UseCaseGuard.guard(() async => throw const RustBridgeException('rate limited, retry after 1'));
    final b = UseCaseGuard.guard(() async => throw const RustBridgeException('rate limited, retry after 1'));

    await expectLater(a, throwsA(isA<AppFailure>()));
    await expectLater(b, throwsA(isA<AppFailure>()));

    String message(Object e) {
      try {
        throw e;
      } on AppFailure catch (f) {
        return f.message;
      }
    }

    final first = await a.then((_) => '', onError: message);
    final second = await b.then((_) => '', onError: message);
    expect(first, second);
  });

  test('paginator keeps fetching until cursor is exhausted', () async {
    final pages = <int, Page<String>>{
      1: const Page(items: ['a'], nextCursor: 2),
      2: const Page(items: ['b'], nextCursor: null),
    };

    final all = await CursorPaginator.collect(
      (cursor) async => pages[cursor]!,
      firstCursor: 1,
    );

    expect(all, ['a', 'b']);
  });
}
