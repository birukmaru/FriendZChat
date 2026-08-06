/// Call screen — enter a FriendZChat ID and dial 8776 + ID.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:friendzchat/core/constants/app_constants.dart';
import 'package:friendzchat/core/constants/service_constants.dart';
import 'package:friendzchat/core/router/app_routes.dart';
import 'package:friendzchat/domain/entities/contact.dart';
import 'package:friendzchat/domain/repositories/repositories.dart';
import 'package:friendzchat/domain/usecases/usecases.dart';
import 'package:friendzchat/presentation/providers/contacts_provider.dart';
import 'package:friendzchat/presentation/providers/history_provider.dart';
import 'package:friendzchat/presentation/widgets/contact_avatar.dart';
import 'package:friendzchat/presentation/widgets/empty_state_view.dart';
import 'package:friendzchat/presentation/widgets/primary_button.dart';
import 'package:friendzchat/dependency_injection/injection.dart';
import 'package:friendzchat/theme/app_colors.dart';
import 'package:friendzchat/theme/app_dimensions.dart';
import 'package:friendzchat/utils/extensions.dart';

class CallScreen extends ConsumerStatefulWidget {
  const CallScreen({super.key, this.userId});
  final String? userId;

  @override
  ConsumerState<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  late final TextEditingController _controller;
  String _value = '';

  @override
  void initState() {
    super.initState();
    _value = widget.userId ?? '';
    _controller = TextEditingController(text: _value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? get _userId => _controller.text.trim();
  String? get _destination =>
      _userId == null || _userId!.isEmpty ? null : buildDialDestination(_userId!);

  Future<void> _call({String? displayName, String? photoUrl}) async {
    final id = _userId;
    if (id == null || !Validators.isUserId(id)) {
      context.showSnack('Enter a valid 6-digit FriendZChat ID', isError: true);
      return;
    }

    // Prefer the name passed in by the caller (contact-row tap), then any
    // saved contact with this ID, then a friendly ID-only label so the
    // history never reads as "User <id>".
    final contacts = ref.read(contactsProvider).valueOrNull ?? const <Contact>[];
    final saved = contacts.firstWhere(
      (c) => c.userId == id,
      orElse: () => const Contact(id: '', userId: '', name: ''),
    );
    final resolvedName =
        (displayName != null && displayName.trim().isNotEmpty)
            ? displayName.trim()
            : (saved.name.trim().isNotEmpty ? saved.name.trim() : 'Friend $id');
    final resolvedPhoto = photoUrl ?? saved.photoUrl;

    final repo = getIt<CallRepository>();
    final res = await repo.startCall(
      userId: id,
      displayName: resolvedName,
      photoUrl: resolvedPhoto,
    );
    if (!mounted) return;
    res.when(
      onSuccess: (_) {
        ref.read(historyProvider.notifier).refresh();
      },
      onFailure: (f) => context.showSnack(f.message, isError: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final contacts = ref.watch(contactsProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.l,
            AppSpacing.s,
            AppSpacing.l,
            AppSpacing.huge,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'START A CALL',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: scheme.primary,
                  letterSpacing: 1.6,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                'Who are you calling?',
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                'Enter a 6-digit ID or pick a saved contact below.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                maxLength: 6,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                onChanged: (v) => setState(() => _value = v),
                style: theme.textTheme.headlineMedium?.copyWith(
                  letterSpacing: 12,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: '000000',
                  counterText: '',
                  prefixIcon: Icon(Icons.tag_rounded),
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              if (_destination != null)
                _DestinationPreview(destination: _destination!)
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.l,
                    vertical: AppSpacing.m,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppRadius.m),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 18,
                        color: scheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppSpacing.s),
                      Text(
                        'We will dial 8776 + ID',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: AppSpacing.l),
              PrimaryButton(
                label: 'Call now',
                icon: Icons.call_rounded,
                onPressed: _destination == null ? null : () => _call(),
              ),
              const SizedBox(height: AppSpacing.huge),
              contacts.when(
                data: (list) {
                  if (list.isEmpty) {
                    return const EmptyStateView(
                      icon: Icons.contact_phone_rounded,
                      title: 'No contacts yet',
                      message:
                          'Save your favourite FriendZChat IDs for quick access.',
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.s,
                          0,
                          AppSpacing.s,
                          AppSpacing.s,
                        ),
                        child: Text(
                          'SAVED CONTACTS',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                            letterSpacing: 1.6,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: scheme.surface,
                          borderRadius: BorderRadius.circular(AppRadius.l),
                          border: Border.all(color: scheme.outlineVariant),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            for (var i = 0;
                                i < list.take(6).length;
                                i++) ...[
                              if (i > 0)
                                Divider(
                                  height: 1,
                                  indent: AppSpacing.l +
                                      44 +
                                      AppSpacing.l,
                                  color: scheme.outlineVariant,
                                ),
                              _ContactRow(
                                contact: list[i],
                                onTap: () => _call(
                                  displayName: list[i].name,
                                  photoUrl: list[i].photoUrl,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(AppSpacing.l),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Center(child: Text('$e')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DestinationPreview extends StatelessWidget {
  const _DestinationPreview({required this.destination});
  final String destination;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.m,
      ),
      decoration: BoxDecoration(
        gradient: AppColors.callGradient,
        borderRadius: BorderRadius.circular(AppRadius.l),
      ),
      child: Row(
        children: [
          const Icon(Icons.call_rounded, color: Colors.white),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Will dial',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                Text(
                  destination,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.contact, required this.onTap});
  final Contact contact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.l,
          vertical: AppSpacing.m,
        ),
        child: Row(
          children: [
            ContactAvatar(
              name: contact.name,
              photoUrl: contact.photoUrl,
              size: 44,
            ),
            const SizedBox(width: AppSpacing.l),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'ID ${contact.userId}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            Material(
              color: scheme.primary,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onTap,
                child: const Padding(
                  padding: EdgeInsets.all(AppSpacing.s),
                  child: Icon(
                    Icons.call_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}