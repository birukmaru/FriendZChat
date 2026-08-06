/// Failure types used by the domain layer.
///
/// Repository implementations convert [AppException]s into these
/// domain-friendly failures so presentation code can react with a sealed
/// `when` switch.
library;

import 'package:equatable/equatable.dart';

/// Base type for any domain-level failure.
sealed class Failure extends Equatable {
  const Failure(this.message);
  final String message;

  @override
  List<Object?> get props => [message, runtimeType];
}

/// Network or connectivity failure.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network unavailable']);
}

/// Server returned an error.
class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.statusCode, this.errorCode});
  final int? statusCode;
  final String? errorCode;

  @override
  List<Object?> get props => [message, statusCode, errorCode];
}

/// Local cache failure.
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local cache error']);
}

/// Auth failure.
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication required']);
}

/// Validation failure (carries per-field messages).
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {this.fieldErrors = const {}});
  final Map<String, String> fieldErrors;

  @override
  List<Object?> get props => [message, fieldErrors];
}

/// User cancelled the operation.
class CancelledFailure extends Failure {
  const CancelledFailure([super.message = 'Cancelled by user']);
}

/// Permission denied.
class PermissionDeniedFailure extends Failure {
  const PermissionDeniedFailure([super.message = 'Permission denied']);
}

/// Catch-all.
class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred']);
}