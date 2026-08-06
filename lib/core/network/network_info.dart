/// Network connectivity helper.
library;

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rxdart/rxdart.dart';

import 'package:friendzchat/utils/logger.dart';

abstract interface class NetworkInfo {
  Stream<bool> get onConnectivityChanged;
  Future<bool> get isConnected;
  Future<bool> hasInternet();
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;
  final BehaviorSubject<bool> _connected$ = BehaviorSubject.seeded(true);

  @override
  Stream<bool> get onConnectivityChanged => _connected$.stream.distinct();

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return _isOnline(results);
  }

  @override
  Future<bool> hasInternet() => isConnected;

  /// Subscribes once to the underlying connectivity stream.
  void start() {
    _connectivity.onConnectivityChanged.listen((results) {
      final online = _isOnline(results);
      _connected$.add(online);
      AppLogger.i('Connectivity: $online ($results)');
    }, onError: (Object e) => AppLogger.w('Connectivity error', error: e));
  }

  Future<void> dispose() async {
    await _connected$.close();
  }

  bool _isOnline(List<ConnectivityResult> results) {
    return results.any((r) => r != ConnectivityResult.none);
  }
}