/// Auth state provider.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../dependency_injection/injection.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/repositories.dart';
import '../../utils/result.dart';

class AuthState {
  const AuthState({
    required this.isLoading,
    required this.isRegistered,
    required this.user,
    this.error,
  });

  factory AuthState.initial() => const AuthState(
        isLoading: true,
        isRegistered: false,
        user: null,
      );

  final bool isLoading;
  final bool isRegistered;
  final User? user;
  final String? error;

  AuthState copyWith({
    bool? isLoading,
    bool? isRegistered,
    User? user,
    String? error,
    bool clearError = false,
  }) =>
      AuthState(
        isLoading: isLoading ?? this.isLoading,
        isRegistered: isRegistered ?? this.isRegistered,
        user: user ?? this.user,
        error: clearError ? null : error ?? this.error,
      );
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => getIt<AuthRepository>(),
);

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => getIt<UserRepository>(),
);

final authStateProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    _bootstrap();
    return AuthState.initial();
  }

  Future<void> _bootstrap() async {
    final repo = ref.read(authRepositoryProvider);
    final reg = await repo.isRegistered();
    final isReg = reg.when(
      onSuccess: (v) => v,
      onFailure: (_) => false,
    );
    if (isReg) {
      final res = await repo.getCurrentUser();
      state = res.when(
        onSuccess: (user) => state.copyWith(
          isLoading: false,
          isRegistered: true,
          user: user,
          clearError: true,
        ),
        onFailure: (f) => state.copyWith(
          isLoading: false,
          isRegistered: false,
          error: f.message,
        ),
      );
    } else {
      state = state.copyWith(isLoading: false, isRegistered: false);
    }
  }

  Future<Result<User>> register({
    required String userId,
    String? nickname,
    String? phoneNumber,
  }) async {
    final repo = ref.read(authRepositoryProvider);
    state = state.copyWith(isLoading: true, clearError: true);
    final res = await repo.register(
      userId: userId,
      nickname: nickname,
      phoneNumber: phoneNumber,
    );
    return res.when(
      onSuccess: (user) {
        state = state.copyWith(
          isLoading: false,
          isRegistered: true,
          user: user,
        );
        return Result.success(user);
      },
      onFailure: (f) {
        state = state.copyWith(isLoading: false, error: f.message);
        return Result.failure(f);
      },
    );
  }

  Future<void> logout() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.logout();
    state = state.copyWith(
      isRegistered: false,
      user: null,
      clearError: true,
    );
  }

  Future<Result<User>> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    final repo = ref.read(authRepositoryProvider);
    state = state.copyWith(isLoading: true, clearError: true);
    final res = await repo.verifyOtp(
      phoneNumber: phoneNumber,
      otp: otp,
    );
    return res.when(
      onSuccess: (user) {
        state = state.copyWith(
          isLoading: false,
          isRegistered: true,
          user: user,
        );
        return Result.success(user);
      },
      onFailure: (f) {
        state = state.copyWith(isLoading: false, error: f.message);
        return Result.failure(f);
      },
    );
  }

  /// Persist [user] through the user repository (remote + secure storage),
  /// then update local state. Returns the persisted [User] on success.
  Future<Result<User>> persistUser(User user) async {
    final repo = ref.read(userRepositoryProvider);
    final res = await repo.updateProfile(user);
    return res.when(
      onSuccess: (saved) {
        state = state.copyWith(user: saved);
        return Result.success(saved);
      },
      onFailure: (f) {
        state = state.copyWith(error: f.message);
        return Result.failure(f);
      },
    );
  }
}
