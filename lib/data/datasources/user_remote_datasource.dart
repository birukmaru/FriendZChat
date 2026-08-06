/// Remote data source for the user — wraps the API service.
library;

import 'package:friendzchat/core/errors/exceptions.dart';
import 'package:friendzchat/data/models/user_dto.dart';
import 'package:friendzchat/services/api_service.dart';

abstract interface class UserRemoteDataSource {
  Future<UserDto> register({
    required String userId,
    String? nickname,
    String? phoneNumber,
  });
  Future<UserDto> getProfile();
  Future<UserDto> updateProfile(UserDto dto);
  Future<void> requestOtp(String phoneNumber);
  Future<UserDto> verifyOtp({required String phoneNumber, required String otp});
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  UserRemoteDataSourceImpl({required ApiService api}) : _api = api;

  final ApiService _api;

  @override
  Future<UserDto> register({
    required String userId,
    String? nickname,
    String? phoneNumber,
  }) async {
    try {
      return await _api.registerUser(
        userId: userId,
        nickname: nickname,
        phoneNumber: phoneNumber,
      );
    } catch (e) {
      throw _toException(e);
    }
  }

  @override
  Future<UserDto> getProfile() async {
    try {
      return await _api.getProfile();
    } catch (e) {
      throw _toException(e);
    }
  }

  @override
  Future<UserDto> updateProfile(UserDto dto) async {
    try {
      return await _api.updateProfile(dto);
    } catch (e) {
      throw _toException(e);
    }
  }

  @override
  Future<void> requestOtp(String phoneNumber) async {
    try {
      await _api.requestOtp(phoneNumber);
    } catch (e) {
      throw _toException(e);
    }
  }

  @override
  Future<UserDto> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      return await _api.verifyOtp(phoneNumber: phoneNumber, otp: otp);
    } catch (e) {
      throw _toException(e);
    }
  }

  Exception _toException(Object e) {
    if (e is AppException) return e;
    return UnknownException(e.toString(), cause: e);
  }
}