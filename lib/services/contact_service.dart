/// System contacts service — bridges platform contacts with our contacts.
library;

import '../core/storage/hive_storage_service.dart';

/// Currently the app uses a local-only contact store.  This service is a
/// placeholder for a future integration with the platform address book.
abstract interface class ContactService {
  Future<void> syncFromDevice();
}

class ContactServiceImpl implements ContactService {
  ContactServiceImpl({required HiveStorageService hive}) : _hive = hive;

  final HiveStorageService _hive;

  @override
  Future<void> syncFromDevice() async {
    // No-op stub.  Future work: read platform contacts via `flutter_contacts`,
    // match phone numbers to known FriendZChat IDs and offer to merge.
  }
}
