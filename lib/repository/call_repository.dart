/// CallRepository — bridges [CallService] and history persistence.
library;

import 'package:uuid/uuid.dart';

import 'package:friendzchat/core/errors/exceptions.dart';
import 'package:friendzchat/core/errors/failures.dart';
import 'package:friendzchat/data/datasources/history_local_datasource.dart';
import 'package:friendzchat/data/models/call_record_dto.dart';
import 'package:friendzchat/domain/entities/call_record.dart';
import 'package:friendzchat/domain/repositories/repositories.dart';
import 'package:friendzchat/services/call_service.dart';
import 'package:friendzchat/utils/result.dart';

class CallRepositoryImpl implements CallRepository {
  CallRepositoryImpl({
    required CallService callService,
    required HistoryLocalDataSource historyLocal,
  })  : _callService = callService,
        _history = historyLocal;

  final CallService _callService;
  final HistoryLocalDataSource _history;
  final Uuid _uuid = const Uuid();

  @override
  Future<Result<CallRecord>> startCall({
    required String userId,
    required String displayName,
    String? photoUrl,
  }) async {
    try {
      final result = await _callService.placeCall(
        userId: userId,
        displayName: displayName,
      );
      final record = CallRecord(
        id: _uuid.v4(),
        remoteUserId: userId,
        remoteName: displayName,
        remotePhotoUrl: photoUrl,
        startedAt: result.startedAt,
        direction: CallDirection.outgoing,
      );
      await _history.save(CallRecordDto.fromEntity(record));
      return Result.success(record);
    } catch (e) {
      return Result.failure(_toFailure(e));
    }
  }

  @override
  Future<Result<CallRecord>> recordCall(CallRecord record) async {
    try {
      await _history.save(CallRecordDto.fromEntity(record));
      return Result.success(record);
    } catch (e) {
      return Result.failure(_toFailure(e));
    }
  }

  @override
  Future<Result<void>> cancelCall(String recordId) async {
    try {
      await _history.delete(recordId);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(_toFailure(e));
    }
  }

  Failure _toFailure(Object e) {
    if (e is AppException) {
      if (e is NetworkException) return NetworkFailure(e.message);
      if (e is ValidationException) return ValidationFailure(e.message);
      if (e is PermissionDeniedException) {
        return PermissionDeniedFailure(e.message);
      }
    }
    return UnknownFailure(e.toString());
  }
}