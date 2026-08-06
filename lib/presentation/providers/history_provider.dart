/// Riverpod providers for call history.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:friendzchat/dependency_injection/injection.dart';
import 'package:friendzchat/domain/entities/call_record.dart';
import 'package:friendzchat/domain/repositories/repositories.dart';

final historyRepositoryProvider = Provider<HistoryRepository>(
  (ref) => getIt<HistoryRepository>(),
);

class HistoryNotifier extends AutoDisposeAsyncNotifier<List<CallRecord>> {
  @override
  Future<List<CallRecord>> build() async {
    final repo = ref.read(historyRepositoryProvider);
    final res = await repo.getHistory();
    return res.when(
      onSuccess: (list) => list,
      onFailure: (_) => const <CallRecord>[],
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(historyRepositoryProvider);
      final res = await repo.getHistory();
      return res.when(
        onSuccess: (list) => list,
        onFailure: (_) => const <CallRecord>[],
      );
    });
  }

  Future<void> clear() async {
    final repo = ref.read(historyRepositoryProvider);
    await repo.clear();
    await refresh();
  }

  Future<void> delete(String id) async {
    final repo = ref.read(historyRepositoryProvider);
    await repo.deleteRecord(id);
    await refresh();
  }
}

final historyProvider =
    AutoDisposeAsyncNotifierProvider<HistoryNotifier, List<CallRecord>>(
  HistoryNotifier.new,
);