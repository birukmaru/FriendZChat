/// Contacts list with search and favourites.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:friendzchat/core/router/app_routes.dart';
import 'package:friendzchat/domain/entities/contact.dart';
import 'package:friendzchat/presentation/providers/contacts_provider.dart';
import 'package:friendzchat/presentation/widgets/contact_avatar.dart';
import 'package:friendzchat/presentation/widgets/empty_state_view.dart';
import 'package:friendzchat/presentation/widgets/page_header.dart';
import 'package:friendzchat/presentation/widgets/shimmer_box.dart';
import 'package:friendzchat/theme/app_dimensions.dart';

class ContactsScreen extends ConsumerStatefulWidget {
  const ContactsScreen({super.key});

  @override
  ConsumerState<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends ConsumerState<ContactsScreen> {
  String _query = '';
  bool _onlyFavourites = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contacts = ref.watch(contactsProvider);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: PageHeader(
            eyebrow: 'People',
            title: 'Contacts',
            subtitle: 'Manage the people you call most.',
            trailing: Row(
              children: [
                IconButton(
                  tooltip:
                      _onlyFavourites ? 'Show all' : 'Show favourites',
                  icon: Icon(
                    _onlyFavourites
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: theme.colorScheme.primary,
                  ),
                  onPressed: () =>
                      setState(() => _onlyFavourites = !_onlyFavourites),
                ),
                IconButton.filledTonal(
                  tooltip: 'Add contact',
                  icon: const Icon(Icons.person_add_alt_1_rounded),
                  onPressed: () => context.push(AppRoutes.contactsAdd),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.l,
            0,
            AppSpacing.l,
            AppSpacing.l,
          ),
          sliver: SliverToBoxAdapter(
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search_rounded),
                hintText: 'Search by name or ID',
              ),
              onChanged: (v) => setState(() => _query = v.toLowerCase()),
            ),
          ),
        ),
        contacts.when(
          data: (list) => _buildList(list),
          loading: () => const SliverToBoxAdapter(
            child: ShimmerListPlaceholder(),
          ),
          error: (e, _) => SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.l),
              child: Text('$e'),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.huge)),
      ],
    );
  }

  Widget _buildList(List<Contact> list) {
    Iterable<Contact> filtered = list;
    if (_onlyFavourites) filtered = filtered.where((c) => c.isFavorite);
    if (_query.isNotEmpty) {
      filtered = filtered.where((c) =>
          c.name.toLowerCase().contains(_query) ||
          c.userId.contains(_query));
    }
    final result = filtered.toList();
    if (result.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyStateView(
          icon: Icons.person_search_rounded,
          title: 'No contacts',
          message: _query.isEmpty && !_onlyFavourites
              ? 'Tap + to add your first FriendZChat contact.'
              : 'Try a different filter.',
          actionLabel: 'Add contact',
          onAction: () => context.push(AppRoutes.contactsAdd),
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
      sliver: SliverList.separated(
        itemCount: result.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.s),
        itemBuilder: (_, i) => _ContactCard(contact: result[i]),
      ),
    );
  }
}

class _ContactCard extends ConsumerWidget {
  const _ContactCard({required this.contact});
  final Contact contact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.l),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.contactDetailFor(contact.id)),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: scheme.outlineVariant),
            borderRadius: BorderRadius.circular(AppRadius.l),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.l,
            vertical: AppSpacing.m,
          ),
          child: Row(
            children: [
              ContactAvatar(
                name: contact.name,
                photoUrl: contact.photoUrl,
                size: 48,
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
              IconButton(
                tooltip: contact.isFavorite ? 'Unfavourite' : 'Favourite',
                icon: Icon(
                  contact.isFavorite
                      ? Icons.star_rounded
                      : Icons.star_border_rounded,
                  color: theme.colorScheme.primary,
                ),
                onPressed: () => ref
                    .read(contactsProvider.notifier)
                    .toggleFavorite(contact.id),
              ),
              Material(
                color: theme.colorScheme.primary,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () =>
                      context.push(AppRoutes.callTo(contact.userId)),
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
      ),
    );
  }
}