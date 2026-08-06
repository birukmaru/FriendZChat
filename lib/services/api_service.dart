/// API service — abstracts the network calls.
///
/// Two implementations:
///
/// * [ApiServiceImpl] — uses [Dio] to talk to a real backend.
/// * [MockApiService] — returns deterministic mock responses so the UI
///   can be developed before a backend exists.
///
/// Both implement [ApiService] so swapping is invisible to consumers.
library;

import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';

import '../core/errors/exceptions.dart';
import '../data/models/user_dto.dart';
import '../utils/logger.dart';

abstract interface class ApiService {
  Future<UserDto> registerUser({
    required String userId,
    String? nickname,
    String? phoneNumber,
  });
  Future<UserDto> getProfile();
  Future<UserDto> updateProfile(UserDto dto);
  Future<void> requestOtp(String phoneNumber);
  Future<UserDto> verifyOtp({
    required String phoneNumber,
    required String otp,
  });
  Future<void> logout();
}

/// Real backend implementation backed by Dio.
class ApiServiceImpl implements ApiService {
  ApiServiceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<UserDto> registerUser({
    required String userId,
    String? nickname,
    String? phoneNumber,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/register',
        data: {
          'userId': userId,
          if (nickname != null) 'nickname': nickname,
          if (phoneNumber != null) 'phoneNumber': phoneNumber,
        },
      );
      _ensureSuccess(res);
      return UserDto.fromJson(res.data!);
    } on DioException catch (e) {
      throw _toException(e);
    } catch (e) {
      throw UnknownException(e.toString(), cause: e);
    }
  }

  @override
  Future<UserDto> getProfile() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/profile');
      _ensureSuccess(res);
      return UserDto.fromJson(res.data!);
    } on DioException catch (e) {
      throw _toException(e);
    } catch (e) {
      throw UnknownException(e.toString(), cause: e);
    }
  }

  @override
  Future<UserDto> updateProfile(UserDto dto) async {
    try {
      final res = await _dio.put<Map<String, dynamic>>(
        '/profile/update',
        data: dto.toJson(),
      );
      _ensureSuccess(res);
      return UserDto.fromJson(res.data!);
    } on DioException catch (e) {
      throw _toException(e);
    } catch (e) {
      throw UnknownException(e.toString(), cause: e);
    }
  }

  @override
  Future<void> requestOtp(String phoneNumber) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/auth/otp',
        data: {'phoneNumber': phoneNumber},
      );
      _ensureSuccess(res);
    } on DioException catch (e) {
      throw _toException(e);
    } catch (e) {
      throw UnknownException(e.toString(), cause: e);
    }
  }

  @override
  Future<UserDto> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/auth/verify',
        data: {'phoneNumber': phoneNumber, 'otp': otp},
      );
      _ensureSuccess(res);
      return UserDto.fromJson(res.data!);
    } on DioException catch (e) {
      throw _toException(e);
    } catch (e) {
      throw UnknownException(e.toString(), cause: e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post<void>('/auth/logout');
    } on DioException catch (e) {
      throw _toException(e);
    }
  }

  void _ensureSuccess(Response<dynamic> res) {
    final code = res.statusCode ?? 0;
    if (code < 200 || code >= 300) {
      throw ServerException(
        'Request failed: $code',
        statusCode: code,
      );
    }
  }

  Exception _toException(DioException e) {
    final code = e.response?.statusCode;
    if (code == 401 || code == 403) {
      return AuthException(e.message ?? 'Auth failed', statusCode: code);
    }
    if (code != null) {
      return ServerException(
        e.message ?? 'Server error',
        statusCode: code,
      );
    }
    return NetworkException(e.message ?? 'Network error', cause: e);
  }
}

/// In-memory mock implementation — used until the backend is live.
class MockApiService implements ApiService {
  MockApiService({Duration latency = const Duration(milliseconds: 250)})
      : _latency = latency;

  final Duration _latency;
  UserDto? _user;

  @override
  Future<UserDto> registerUser({
    required String userId,
    String? nickname,
    String? phoneNumber,
  }) async {
    await _wait();
    if (!RegExp(r'^\d{6}$').hasMatch(userId)) {
      throw const ValidationException('Invalid 6-digit ID');
    }
    _user = UserDto(
      id: userId,
      nickname: nickname,
      phoneNumber: phoneNumber,
      isVerified: true,
      createdAt: DateTime.now(),
    );
    AppLogger.i('Mock register: $userId');
    return _user!;
  }

  @override
  Future<UserDto> getProfile() async {
    await _wait();
    if (_user == null) {
      throw const ServerException('Not registered', statusCode: 404);
    }
    return _user!;
  }

  @override
  Future<UserDto> updateProfile(UserDto dto) async {
    await _wait();
    _user = dto;
    return dto;
  }

  @override
  Future<void> requestOtp(String phoneNumber) async {
    await _wait();
    AppLogger.i('Mock OTP sent to $phoneNumber (use 123456)');
  }

  @override
  Future<UserDto> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    await _wait();
    if (otp != '123456') {
      throw const AuthException('Invalid OTP', statusCode: 401);
    }
    final rng = Random();
    final id = (100000 + rng.nextInt(899999)).toString();
    _user = UserDto(
      id: id,
      phoneNumber: phoneNumber,
      isVerified: true,
      createdAt: DateTime.now(),
    );
    return _user!;
  }

  @override
  Future<void> logout() async {
    await _wait();
    _user = null;
  }

  Future<void> _wait() => Future<void>.delayed(_latency);
}
