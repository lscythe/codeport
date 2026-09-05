sealed class AppFailure implements Exception {
  const AppFailure(this.message);
  final String message;

  const factory AppFailure.auth() = AuthFailure;
  const factory AppFailure.network(String message) = NetworkFailure;
  const factory AppFailure.rateLimited(String message) = RateLimitedFailure;
  const factory AppFailure.notFound() = NotFoundFailure;
  const factory AppFailure.validation(String message) = ValidationFailure;

  static AppFailure fromRust(Object error) {
    final message = error.toString().toLowerCase();
    if (message.contains('auth')) return const AppFailure.auth();
    if (message.contains('rate limit')) {
      return AppFailure.rateLimited(error.toString());
    }
    if (message.contains('not found')) return const AppFailure.notFound();
    if (message.contains('invalid')) {
      return AppFailure.validation(error.toString());
    }
    return AppFailure.network(error.toString());
  }

  @override
  String toString() => 'AppFailure: $message';
}

final class AuthFailure extends AppFailure {
  const AuthFailure() : super('authentication failed');
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure(super.message);
}

final class RateLimitedFailure extends AppFailure {
  const RateLimitedFailure(super.message);
}

final class NotFoundFailure extends AppFailure {
  const NotFoundFailure() : super('resource not found');
}

final class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message);
}

class RustBridgeException implements Exception {
  const RustBridgeException(this.message);
  final String message;

  @override
  String toString() => message;
}
