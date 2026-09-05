class Page<T> {
  const Page({required this.items, required this.nextCursor});
  final List<T> items;
  final int? nextCursor;

  bool get hasMore => nextCursor != null;
}

class CursorPaginator {
  const CursorPaginator._();

  static Future<List<T>> collect<T>(
    Future<Page<T>> Function(int cursor) fetch, {
    required int firstCursor,
  }) async {
    final all = <T>[];
    int? cursor = firstCursor;
    while (cursor != null) {
      final page = await fetch(cursor);
      all.addAll(page.items);
      cursor = page.nextCursor;
    }
    return all;
  }
}
