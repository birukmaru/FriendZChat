/// Contact detail screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:friendzchat/core/router/app_routes.dart';
import 'package:friendzchat/domain/entities/contact.dart';
import 'package:friendzchat/presentation/providers/contacts_provider.dart';
import 'package:friendzchat/presentation/widgets/contact_avatar.dart';
import 'package:friendzchat/presentation/widgets/empty_state_view.dart';
import 'package:friendzchat/presentation/widgets/primary_button.dart';
import 'package:friendzchat/theme/app_dimensions.dart';
import 'package:friendzchat/utils/extensions.dart';

class ContactDetailScreen extends ConsumerWidget {
  const ContactDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(contactsProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: contacts.when(
        data: (list) {
          final contact = list.firstWhere(
            (c) => c.id == id,
            orElse: () => const Contact(
              id: '',
              userId: '',
              name: 'Unknown',
            ),
          );
          if (contact.id.isEmpty) {
            return const EmptyStateView(
              icon: Icons.person_off_rounded,
              title: 'Contact not found',
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.l,
              AppSpacing.s,
              AppSpacing.l,
              AppSpacing.huge,
            ),
            children: [
              Center(
                child: Column(
                  children: [
                    ContactAvatar(
                      name: contact.name,
                      photoUrl: contact.photoUrl,
                      size: 96,
                    ),
                    const SizedBox(height: AppSpacing.l),
                    Text(
                      contact.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.m,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.primaryContainer,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        'ID ${contact.userId}',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: scheme.onPrimaryContainer,
                          letterSpacing: 1.6,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.huge),
              _DetailRow(
                icon: Icons.call_rounded,
                label: 'Dial destination',
                value: contact.dialDestination,
              ),
              if (contact.phoneNumber != null)
                _DetailRow(
                  icon: Icons.phone_rounded,
                  label: 'Phone',
                  value: contact.phoneNumber!,
                ),
              if (contact.notes != null)
                _DetailRow(
                  icon: Icons.description_rounded,
                  label: 'Notes',
                  value: contact.notes!,
                ),
              const SizedBox(height: AppSpacing.huge),
              PrimaryButton(
                label: 'Call ${contact.name}',
                icon: Icons.call_rounded,
                onPressed: () =>
                    context.push(AppRoutes.callTo(contact.userId)),
              ),
              const SizedBox(height: AppSpacing.l),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(
                        contact.isFavorite
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                      ),
                      label: Text(
                        contact.isFavorite
                            ? 'Favourited'
                            : 'Add to favourites',
                      ),
                      onPressed: () async {
                        final res = await ref
                            .read(contactsProvider.notifier)
                            .toggleFavorite(contact.id);
                        if (context.mounted) {
                          res.when(
                            onSuccess: (_) => null,
                            onFailure: (f) =>
                                context.showSnack(f.message, isError: true),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.m),
                  Material(
                    color: scheme.errorContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.m),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.m),
                      onTap: () async {
                        final res = await ref
                            .read(contactsProvider.notifier)
                            .delete(contact.id);
                        if (!context.mounted) return;
                        res.when(
                          onSuccess: (_) => context.pop(),
                          onFailure: (f) =>
                              context.showSnack(f.message, isError: true),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.l,
                          vertical: AppSpacing.m,
                        ),
                        child: Icon(
                          Icons.delete_rounded,
                          color: scheme.error,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.s),
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.m),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.s),
            ),
            child:
                Icon(icon, size: 20, color: scheme.onPrimaryContainer),
          ),
          const SizedBox(width: AppSpacing.l),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
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