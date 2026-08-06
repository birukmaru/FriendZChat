/// HistoryRepository implementation.
library;

import 'package:friendzchat/core/errors/exceptions.dart';
import 'package:friendzchat/core/errors/failures.dart';
import 'package:friendzchat/data/datasources/history_local_datasource.dart';
import 'package:friendzchat/data/models/call_record_dto.dart';
import 'package:friendzchat/domain/entities/call_record.dart';
import 'package:friendzchat/domain/repositories/repositories.dart';
import 'package:friendzchat/utils/result.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  HistoryRepositoryImpl({required HistoryLocalDataSource local}) : _local = local;

  final HistoryLocalDataSource _local;

  @override
  Future<Result<List<CallRecord>>> getHistory({
    int limit = 100,
    int offset = 0,
  }) async {
    try {
      final dtos = await _local.getAll(limit: limit, offset: offset);
      return Result.success(dtos.map((d) => d.toEntity()).toList());
    } catch (e) {
      return Result.failure(_toFailure(e));
    }
  }

  @override
  Future<Result<void>> addRecord(CallRecord record) async {
    try {
      await _local.save(CallRecordDto.fromEntity(record));
      return const Result.success(null);
    } catch (e) {
      return Result.failure(_toFailure(e));
    }
  }

  @override
  Future<Result<void>> deleteRecord(String id) async {
    try {
      await _local.delete(id);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(_toFailure(e));
    }
  }

  @override
  Future<Result<void>> clear() async {
    try {
      await _local.clear();
      return const Result.success(null);
    } catch (e) {
      return Result.failure(_toFailure(e));
    }
  }

  @override
  Stream<List<CallRecord>> watchHistory() =>
      _local.watch().map((dtos) => dtos.map((d) => d.toEntity()).toList());

  Failure _toFailure(Object e) {
    if (e is AppException) {
      if (e is CacheException) return CacheFailure(e.message);
    }
    return UnknownFailure(e.toString());
  }
}