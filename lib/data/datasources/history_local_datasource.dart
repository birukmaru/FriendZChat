/// Local Hive-backed call history data source.
library;

import 'dart:async';
import 'dart:convert';

import 'package:hive/hive.dart';

import 'package:friendzchat/core/constants/app_constants.dart';
import 'package:friendzchat/core/errors/exceptions.dart';
import 'package:friendzchat/core/storage/hive_storage_service.dart';
import 'package:friendzchat/data/models/call_record_dto.dart';

abstract interface class HistoryLocalDataSource {
  Future<List<CallRecordDto>> getAll({int limit = 100, int offset = 0});
  Future<CallRecordDto> save(CallRecordDto dto);
  Future<void> delete(String id);
  Future<void> clear();
  Stream<List<CallRecordDto>> watch();
}

class HistoryLocalDataSourceImpl implements HistoryLocalDataSource {
  HistoryLocalDataSourceImpl({required HiveStorageService hive}) : _hive = hive;

  final HiveStorageService _hive;

  Future<Box<dynamic>> _box() async {
    if (Hive.isBoxOpen(AppConstants.historyBox)) {
      return Hive.box<dynamic>(AppConstants.historyBox);
    }
    return Hive.openBox<dynamic>(AppConstants.historyBox);
  }

  Future<List<CallRecordDto>> _readAll() async {
    try {
      final box = await _box();
      final list = box.values
          .whereType<String>()
          .map(jsonDecode)
          .cast<Map<String, dynamic>>()
          .map(CallRecordDto.fromJson)
          .toList();
      list.sort((a, b) => b.startedAt.compareTo(a.startedAt));
      return list;
    } catch (e) {
      throw CacheException('Failed to read history', cause: e);
    }
  }

  @override
  Future<List<CallRecordDto>> getAll({int limit = 100, int offset = 0}) async {
    final all = await _readAll();
    if (offset >= all.length) return const [];
    final end = (offset + limit).clamp(0, all.length);
    return all.sublist(offset, end);
  }

  @override
  Future<CallRecordDto> save(CallRecordDto dto) async {
    try {
      final box = await _box();
      await box.put(dto.id, jsonEncode(dto.toJson()));
      return dto;
    } catch (e) {
      throw CacheException('Failed to save history entry', cause: e);
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      final box = await _box();
      await box.delete(id);
    } catch (e) {
      throw CacheException('Failed to delete history entry', cause: e);
    }
  }

  @override
  Future<void> clear() async {
    try {
      final box = await _box();
      await box.clear();
    } catch (e) {
      throw CacheException('Failed to clear history', cause: e);
    }
  }

  @override
  Stream<List<CallRecordDto>> watch() async* {
    yield await _readAll();
    yield* _hive.watch(AppConstants.historyBox).asyncMap((_) => _readAll());
  }
}