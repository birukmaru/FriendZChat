/// Riverpod providers for contacts.
library;

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:friendzchat/dependency_injection/injection.dart';
import 'package:friendzchat/domain/entities/contact.dart';
import 'package:friendzchat/domain/repositories/repositories.dart';
import 'package:friendzchat/utils/result.dart';

final contactRepositoryProvider = Provider<ContactRepository>(
  (ref) => getIt<ContactRepository>(),
);

class ContactsNotifier
    extends AutoDisposeAsyncNotifier<List<Contact>> {
  @override
  Future<List<Contact>> build() async {
    final repo = ref.read(contactRepositoryProvider);
    final res = await repo.getContacts();
    return res.when(
      onSuccess: (list) => list,
      onFailure: (_) => const <Contact>[],
    );
  }

  Future<Result<Contact>> addContact({
    required String userId,
    required String name,
    String? phoneNumber,
    String? notes,
    String? photoUrl,
  }) async {
    final repo = ref.read(contactRepositoryProvider);
    final contact = Contact(
      id: const Uuid().v4(),
      userId: userId,
      name: name,
      phoneNumber: phoneNumber,
      notes: notes,
      photoUrl: photoUrl,
      addedAt: DateTime.now(),
    );
    final res = await repo.addContact(contact);
    if (res.isSuccess) {
      // Fire-and-forget refresh. Safe even if the provider has disposed
      // by the time the write completes; the try/catch swallows any
      // late-arriving state assignment against a torn-down notifier.
      unawaited(_safeRefresh());
    }
    return res;
  }

  Future<Result<Contact>> toggleFavorite(String id) async {
    final repo = ref.read(contactRepositoryProvider);
    final res = await repo.toggleFavorite(id);
    if (res.isSuccess) {
      unawaited(_safeRefresh());
    }
    return res;
  }

  Future<Result<void>> delete(String id) async {
    final repo = ref.read(contactRepositoryProvider);
    final res = await repo.deleteContact(id);
    if (res.isSuccess) {
      unawaited(_safeRefresh());
    }
    return res;
  }

  Future<void> _safeRefresh() async {
    try {
      await refresh();
    } catch (_) {
      // Provider already disposed — nothing to update.
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(contactRepositoryProvider);
      final res = await repo.getContacts();
      return res.when(
        onSuccess: (list) => list,
        onFailure: (_) => const <Contact>[],
      );
    });
  }
}

final contactsProvider =
    AutoDisposeAsyncNotifierProvider<ContactsNotifier, List<Contact>>(
  ContactsNotifier.new,
);