/// Tiny sealed [Result] for repository returns.
///
/// Repository methods should never throw across layer boundaries; they
/// return a [Result] carrying either a value or a [Failure].
library;

import 'package:friendzchat/core/errors/exceptions.dart';
import 'package:friendzchat/core/errors/failures.dart';

/// Sealed result type holding either a successful [value] or a [Failure].
sealed class Result<T> {
  const Result();

  /// Construct a successful result.
  const factory Result.success(T value) = Success<T>;

  /// Construct a failed result.
  const factory Result.failure(Failure failure) = FailureResult<T>;

  /// Returns `true` when this is a [Success].
  bool get isSuccess => this is Success<T>;

  /// Returns `true` when this is a [FailureResult].
  bool get isFailure => this is FailureResult<T>;

  /// Pattern-matches on the result, calling [onSuccess] or [onFailure].
  R when<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    final self = this;
    return switch (self) {
      Success<T>(:final value) => onSuccess(value),
      FailureResult<T>(:final failure) => onFailure(failure),
    };
  }

  /// Returns the value or `null` if failed.
  T? get valueOrNull => switch (this) {
        Success<T>(:final value) => value,
        FailureResult<T>() => null,
      };

  /// Returns the failure or `null` if successful.
  Failure? get failureOrNull => switch (this) {
        Success<T>() => null,
        FailureResult<T>(:final failure) => failure,
      };
}

final class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}

final class FailureResult<T> extends Result<T> {
  const FailureResult(this.failure);
  final Failure failure;
}

/// Convenience helpers around [Result].
extension ResultX<T> on Result<T> {
  /// Returns the value or throws the contained failure wrapped in an
  /// [AppException].  Useful in use-cases that need to propagate.
  T unwrap() => when(
        onSuccess: (v) => v,
        onFailure: (f) => throw UnknownException(f.message),
      );

  /// Returns the value or the result of [orElse].
  T unwrapOr(T Function(Failure) orElse) => when(
        onSuccess: (v) => v,
        onFailure: (f) => orElse(f),
      );
}