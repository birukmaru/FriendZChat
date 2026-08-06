/// Repository abstractions (contracts).
///
/// Concrete implementations live in `lib/repository/` and are wired up
/// in DI.  Presentation and use-cases depend only on these interfaces.
library;

import 'package:friendzchat/domain/entities/app_notification.dart';
import 'package:friendzchat/domain/entities/app_settings.dart';
import 'package:friendzchat/domain/entities/call_record.dart';
import 'package:friendzchat/domain/entities/contact.dart';
import 'package:friendzchat/domain/entities/user.dart';
import 'package:friendzchat/utils/result.dart';

abstract class AuthRepository {
  /// Returns the locally registered user, if any.
  Future<Result<User?>> getCurrentUser();

  /// Stores a freshly-registered user ID and profile.
  Future<Result<User>> register({
    required String userId,
    String? nickname,
    String? phoneNumber,
  });

  /// Validates a 6-digit ID before saving.
  Future<Result<void>> validateUserId(String userId);

  /// Returns true if a user is registered.
  Future<Result<bool>> isRegistered();

  /// Clears local credentials.
  Future<Result<void>> logout();

  /// Send an OTP to [phoneNumber].
  Future<Result<void>> requestOtp(String phoneNumber);

  /// Verify [otp] matches the one sent to [phoneNumber].
  Future<Result<User>> verifyOtp({required String phoneNumber, required String otp});
}

abstract class UserRepository {
  Future<Result<User>> fetchProfile();
  Future<Result<User>> updateProfile(User user);
  Future<Result<String>> exportUserId();
  Future<Result<void>> setNickname(String nickname);
  Future<Result<void>> setPhoto(String photoPath);
}

abstract class ContactRepository {
  Future<Result<List<Contact>>> getContacts();
  Future<Result<Contact>> getContact(String id);
  Future<Result<Contact>> addContact(Contact contact);
  Future<Result<Contact>> updateContact(Contact contact);
  Future<Result<void>> deleteContact(String id);
  Future<Result<Contact>> toggleFavorite(String id);
  Stream<List<Contact>> watchContacts();
}

abstract class CallRepository {
  Future<Result<CallRecord>> startCall({
    required String userId,
    required String displayName,
    String? photoUrl,
  });
  Future<Result<CallRecord>> recordCall(CallRecord record);
  Future<Result<void>> cancelCall(String recordId);
}

abstract class HistoryRepository {
  Future<Result<List<CallRecord>>> getHistory({int limit = 100, int offset = 0});
  Future<Result<void>> addRecord(CallRecord record);
  Future<Result<void>> deleteRecord(String id);
  Future<Result<void>> clear();
  Stream<List<CallRecord>> watchHistory();
}

abstract class NotificationRepository {
  Future<Result<List<AppNotification>>> getNotifications();
  Future<Result<void>> add(AppNotification notification);
  Future<Result<void>> markRead(String id);
  Future<Result<void>> markAllRead();
  Future<Result<void>> clear();
  Stream<List<AppNotification>> watchNotifications();
}

abstract class SettingsRepository {
  Future<Result<AppSettings>> load();
  Future<Result<AppSettings>> update(AppSettings settings);
  Future<Result<AppThemeMode>> getThemeMode();
  Future<Result<AppLanguage>> getLanguage();
  Future<Result<void>> setThemeMode(AppThemeMode mode);
  Future<Result<void>> setLanguage(AppLanguage language);
  Stream<AppSettings> watch();
}