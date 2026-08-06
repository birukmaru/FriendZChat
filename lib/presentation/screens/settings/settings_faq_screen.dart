/// FAQ screen.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:friendzchat/theme/app_dimensions.dart';

class SettingsFaqScreen extends StatelessWidget {
  const SettingsFaqScreen({super.key});

  static const List<_FaqItem> _items = [
    _FaqItem(
      q: 'Why does the dialer open when I call?',
      a:
          'We format the destination as 8776 + ID and hand off to the system dialer, so the call always goes through the carrier\'s private service.',
    ),
    _FaqItem(
      q: 'Where is my data stored?',
      a: 'On your device. We do not upload contacts or call history.',
    ),
    _FaqItem(
      q: 'Can I use a nickname instead of my ID?',
      a:
          'Right now calls are addressed by ID. Nicknames are for your own reference only.',
    ),
    _FaqItem(
      q: 'How do I add a friend\'s ID?',
      a:
          'Open Contacts → Add contact, type their 6-digit ID and a name. The contact is saved on your device.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.l,
            AppSpacing.s,
            AppSpacing.l,
            AppSpacing.l,
          ),
          children: [
            Text(
              'FAQ',
              style: theme.textTheme.labelSmall?.copyWith(
                color: scheme.primary,
                letterSpacing: 1.6,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              'Frequently asked',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              'Quick answers to common questions.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.55,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Container(
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(AppRadius.l),
                border: Border.all(color: scheme.outlineVariant),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  for (var i = 0; i < _items.length; i++) ...[
                    if (i > 0)
                      Divider(
                        height: 1,
                        thickness: 1,
                        indent: AppSpacing.l,
                        color: scheme.outlineVariant,
                      ),
                    Theme(
                      data: theme.copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.l,
                        ),
                        childrenPadding: const EdgeInsets.fromLTRB(
                          AppSpacing.l,
                          0,
                          AppSpacing.l,
                          AppSpacing.m,
                        ),
                        iconColor: scheme.primary,
                        collapsedIconColor: scheme.onSurfaceVariant,
                        title: Text(
                          _items[i].q,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _items[i].a,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: scheme.onSurfaceVariant,
                                height: 1.55,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqItem {
  const _FaqItem({required this.q, required this.a});
  final String q;
  final String a;
}