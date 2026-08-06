/// Hive-backed cache for contacts, history, notifications.
///
/// Hive is initialised once at app start.
library;

import 'dart:async';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:friendzchat/utils/logger.dart';

/// Wraps a named [Box] with a typed API.
abstract interface class HiveStorageService {
  Future<void> init();
  Future<void> close();
  Box<dynamic> box(String name);
  Future<void> put(String boxName, String key, dynamic value);
  Future<void> putAll(String boxName, Map<String, dynamic> entries);
  dynamic get(String boxName, String key);
  Future<void> delete(String boxName, String key);
  Future<void> clearBox(String boxName);
  Stream<BoxEvent> watch(String boxName, {String? key});
}

class HiveStorageServiceImpl implements HiveStorageService {
  HiveStorageServiceImpl();

  bool _initialised = false;

  @override
  Future<void> init() async {
    if (_initialised) return;
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    _initialised = true;
    AppLogger.i('Hive initialised at ${dir.path}');
  }

  @override
  Future<void> close() async {
    await Hive.close();
    _initialised = false;
  }

  @override
  Box<dynamic> box(String name) {
    if (!Hive.isBoxOpen(name)) {
      // Boxes opened lazily — callers wrap with await.
      throw StateError(
        'Box $name is not open. Open it explicitly with Hive.openBox first.',
      );
    }
    return Hive.box<dynamic>(name);
  }

  @override
  Future<void> put(String boxName, String key, dynamic value) async {
    final box = await _ensure(boxName);
    await box.put(key, value);
  }

  @override
  Future<void> putAll(String boxName, Map<String, dynamic> entries) async {
    final box = await _ensure(boxName);
    await box.putAll(entries);
  }

  @override
  dynamic get(String boxName, String key) {
    if (!Hive.isBoxOpen(boxName)) return null;
    return Hive.box<dynamic>(boxName).get(key);
  }

  @override
  Future<void> delete(String boxName, String key) async {
    final box = await _ensure(boxName);
    await box.delete(key);
  }

  @override
  Future<void> clearBox(String boxName) async {
    final box = await _ensure(boxName);
    await box.clear();
  }

  @override
  Stream<BoxEvent> watch(String boxName, {String? key}) {
    if (!Hive.isBoxOpen(boxName)) {
      throw StateError('Box $boxName is not open');
    }
    final box = Hive.box<dynamic>(boxName);
    return key == null ? box.watch() : box.watch(key: key);
  }

  Future<Box<dynamic>> _ensure(String name) async {
    if (!Hive.isBoxOpen(name)) {
      return Hive.openBox<dynamic>(name);
    }
    return Hive.box<dynamic>(name);
  }
}