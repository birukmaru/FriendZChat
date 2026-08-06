/// Manual dependency injection container.
///
/// Backed by `get_it` so any class — widget, repository, controller —
/// can resolve its dependencies by constructor injection or
/// `getIt<MyService>()`.
library;

import 'package:get_it/get_it.dart';

import 'package:friendzchat/core/network/dio_client.dart';
import 'package:friendzchat/core/network/network_info.dart';
import 'package:friendzchat/core/storage/hive_storage_service.dart';
import 'package:friendzchat/core/storage/local_storage_service.dart';
import 'package:friendzchat/core/storage/secure_storage_service.dart';
import 'package:friendzchat/data/datasources/contact_local_datasource.dart';
import 'package:friendzchat/data/datasources/history_local_datasource.dart';
import 'package:friendzchat/data/datasources/notification_local_datasource.dart';
import 'package:friendzchat/data/datasources/settings_local_datasource.dart';
import 'package:friendzchat/data/datasources/user_remote_datasource.dart';
import 'package:friendzchat/domain/repositories/repositories.dart';
import 'package:friendzchat/repository/auth_repository.dart';
import 'package:friendzchat/repository/call_repository.dart';
import 'package:friendzchat/repository/contact_repository.dart';
import 'package:friendzchat/repository/history_repository.dart';
import 'package:friendzchat/repository/notification_repository.dart';
import 'package:friendzchat/repository/settings_repository.dart';
import 'package:friendzchat/repository/user_repository.dart';
import 'package:friendzchat/services/api_service.dart';
import 'package:friendzchat/services/auth_service.dart';
import 'package:friendzchat/services/call_service.dart';
import 'package:friendzchat/services/contact_service.dart';
import 'package:friendzchat/services/notification_service.dart';
import 'package:friendzchat/utils/logger.dart';

/// Global service locator.  Access via `getIt<MyService>()`.
final GetIt getIt = GetIt.instance;

/// Register all dependencies.  Call once at app startup.
Future<void> configureDependencies({
  String? baseUrl,
  bool useMockApi = true,
}) async {
  if (getIt.isRegistered<DioClient>()) return;

  // ─── Core ──────────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageServiceImpl(),
  );
  final localStorage = await LocalStorageServiceImpl.create();
  getIt.registerSingleton<LocalStorageService>(localStorage);
  getIt.registerLazySingleton<HiveStorageService>(
    () => HiveStorageServiceImpl(),
  );
  await getIt<HiveStorageService>().init();

  getIt.registerLazySingleton<DioClient>(
    () => DioClientImpl(
      baseUrl: baseUrl,
      tokenProvider: () async => getIt<SecureStorageService>()
          .read('private_call.auth_token'),
    ),
  );
  getIt.registerLazySingleton<NetworkInfo>(() {
    final info = NetworkInfoImpl();
    info.start();
    return info;
  });

  // ─── Services ──────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<AuthService>(
    () => AuthServiceImpl(secure: getIt<SecureStorageService>()),
  );
  getIt.registerLazySingleton<CallService>(
    () => DialerCallService(),
  );
  getIt.registerLazySingleton<ContactService>(
    () => ContactServiceImpl(hive: getIt<HiveStorageService>()),
  );
  getIt.registerLazySingleton<NotificationService>(
    () => NotificationServiceImpl(hive: getIt<HiveStorageService>()),
  );
  getIt.registerLazySingleton<ApiService>(
    () => useMockApi
        ? MockApiService()
        : ApiServiceImpl(dio: getIt<DioClient>().dio),
  );

  // ─── Data sources ──────────────────────────────────────────────────────────
  getIt.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(api: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ContactLocalDataSource>(
    () => ContactLocalDataSourceImpl(hive: getIt<HiveStorageService>()),
  );
  getIt.registerLazySingleton<HistoryLocalDataSource>(
    () => HistoryLocalDataSourceImpl(hive: getIt<HiveStorageService>()),
  );
  getIt.registerLazySingleton<NotificationLocalDataSource>(
    () => NotificationLocalDataSourceImpl(hive: getIt<HiveStorageService>()),
  );
  getIt.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(local: getIt<LocalStorageService>()),
  );

  // ─── Repositories ──────────────────────────────────────────────────────────
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remote: getIt<UserRemoteDataSource>(),
      secure: getIt<SecureStorageService>(),
      authService: getIt<AuthService>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remote: getIt<UserRemoteDataSource>(),
      secure: getIt<SecureStorageService>(),
      local: getIt<LocalStorageService>(),
    ),
  );
  getIt.registerLazySingleton<ContactRepository>(
    () => ContactRepositoryImpl(
      local: getIt<ContactLocalDataSource>(),
      remote: getIt<UserRemoteDataSource>(),
    ),
  );
  getIt.registerLazySingleton<CallRepository>(
    () => CallRepositoryImpl(
      callService: getIt<CallService>(),
      historyLocal: getIt<HistoryLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<HistoryRepository>(
    () => HistoryRepositoryImpl(local: getIt<HistoryLocalDataSource>()),
  );
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      local: getIt<NotificationLocalDataSource>(),
      notificationService: getIt<NotificationService>(),
    ),
  );
  getIt.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(
      local: getIt<SettingsLocalDataSource>(),
      secure: getIt<SecureStorageService>(),
      prefs: getIt<LocalStorageService>(),
    ),
  );

  AppLogger.i('DI initialised');
}

/// Tear down all singletons — useful in tests.
Future<void> resetDependencies() async {
  await getIt.reset();
}