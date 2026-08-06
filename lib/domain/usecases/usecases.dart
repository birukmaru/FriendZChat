/// Use cases — application-specific business rules.
///
/// Each use case has a single `call` method and orchestrates one or more
/// repositories. Keeping the rules here means screens stay thin and the
/// business logic is easy to unit test.
library;

import 'package:friendzchat/core/constants/app_constants.dart';
import 'package:friendzchat/core/constants/service_constants.dart';
import 'package:friendzchat/domain/entities/app_settings.dart';
import 'package:friendzchat/domain/entities/call_record.dart';
import 'package:friendzchat/domain/entities/contact.dart';
import 'package:friendzchat/domain/repositories/repositories.dart';
import 'package:friendzchat/utils/result.dart';

/// Builds the full dial number for a FriendZChat user.
String buildDialDestination(String userId) =>
    '${AppConstants.serviceShortCode}$userId';

class GetCurrentUser {
  GetCurrentUser(this._repo);
  final AuthRepository _repo;
  Future<Result> call() => _repo.getCurrentUser();
}

class RegisterUser {
  RegisterUser(this._repo);
  final AuthRepository _repo;
  Future<Result> call({
    required String userId,
    String? nickname,
    String? phoneNumber,
  }) =>
      _repo.register(
        userId: userId,
        nickname: nickname,
        phoneNumber: phoneNumber,
      );
}

class ValidateUserId {
  ValidateUserId(this._repo);
  final AuthRepository _repo;
  Future<Result> call(String userId) => _repo.validateUserId(userId);
}

class Logout {
  Logout(this._repo);
  final AuthRepository _repo;
  Future<Result> call() => _repo.logout();
}

class ListContacts {
  ListContacts(this._repo);
  final ContactRepository _repo;
  Future<Result<List<Contact>>> call() => _repo.getContacts();
}

class AddContact {
  AddContact(this._repo);
  final ContactRepository _repo;
  Future<Result<Contact>> call(Contact contact) => _repo.addContact(contact);
}

class ToggleFavorite {
  ToggleFavorite(this._repo);
  final ContactRepository _repo;
  Future<Result<Contact>> call(String id) => _repo.toggleFavorite(id);
}

class DeleteContact {
  DeleteContact(this._repo);
  final ContactRepository _repo;
  Future<Result<void>> call(String id) => _repo.deleteContact(id);
}

class MakeCall {
  MakeCall(this._repo);
  final CallRepository _repo;
  Future<Result<CallRecord>> call({
    required String userId,
    required String displayName,
    String? photoUrl,
  }) =>
      _repo.startCall(
        userId: userId,
        displayName: displayName,
        photoUrl: photoUrl,
      );
}

class GetHistory {
  GetHistory(this._repo);
  final HistoryRepository _repo;
  Future<Result<List<CallRecord>>> call({int limit = 100, int offset = 0}) =>
      _repo.getHistory(limit: limit, offset: offset);
}

class LoadSettings {
  LoadSettings(this._repo);
  final SettingsRepository _repo;
  Future<Result<AppSettings>> call() => _repo.load();
}

class UpdateSettings {
  UpdateSettings(this._repo);
  final SettingsRepository _repo;
  Future<Result<AppSettings>> call(AppSettings s) => _repo.update(s);
}

/// Quick inline validators that don't need a repo.
class QuickValidators {
  QuickValidators._();
  static bool isValidUserId(String id) => Validators.isUserId(id);
  static String dialDestination(String userId) =>
      buildDialDestination(userId);
}