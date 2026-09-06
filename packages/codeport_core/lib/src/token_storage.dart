typedef ReadToken = Future<String?> Function();
typedef WriteToken = Future<void> Function(String? token);
typedef DeleteToken = Future<void> Function();

abstract class SecureTokenStorage {
  Future<String?> read();
  Future<void> write(String token);
  Future<void> delete();
}

class FakeSecureTokenStorage implements SecureTokenStorage {
  String? _token;

  @override
  Future<String?> read() async => _token;

  @override
  Future<void> write(String token) async {
    _token = token;
  }

  @override
  Future<void> delete() async {
    _token = null;
  }
}
