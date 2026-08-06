/// Domain exceptions.
///
/// These map directly to infrastructure problems so the repository layer can
/// convert them to [Failure]s before they reach the presentation layer.
library;

/// Base type for any failure originating in the data or remote layers.
sealed class AppException implements Exception {
  const AppException(this.message, {this.cause});
  final String message;
  final Object? cause;

  @override
  String toString() => '$runtimeType: $message';
}

/// A network or HTTP-layer problem.
class NetworkException extends AppException {
  const NetworkException(super.message, {super.cause, this.statusCode});
  final int? statusCode;
}

/// Server returned a 5xx or business-logic error.
class ServerException extends AppException {
  const ServerException(super.message, {super.cause, this.statusCode, this.errorCode});
  final int? statusCode;
  final String? errorCode;
}

/// Local cache or persistence failure.
class CacheException extends AppException {
  const CacheException(super.message, {super.cause});
}

/// Authentication / authorization failure.
class AuthException extends AppException {
  const AuthException(super.message, {super.cause, this.statusCode});
  final int? statusCode;
}

/// Validation failure for inputs.
class ValidationException extends AppException {
  const ValidationException(super.message, {super.cause, this.fieldErrors = const {}});
  final Map<String, String> fieldErrors;
}

/// User cancelled the operation (e.g. dismissed a QR scanner).
class CancelledException extends AppException {
  const CancelledException([super.message = 'Cancelled']);
}

/// Unknown / unexpected error.
class UnknownException extends AppException {
  const UnknownException(super.message, {super.cause});
}

/// Permission denied by the user or OS.
class PermissionDeniedException extends AppException {
  const PermissionDeniedException(super.message, {super.cause});
}