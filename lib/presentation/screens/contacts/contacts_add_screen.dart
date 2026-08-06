/// Add / edit contact screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:friendzchat/core/constants/service_constants.dart';
import 'package:friendzchat/core/router/app_routes.dart';
import 'package:friendzchat/presentation/providers/contacts_provider.dart';
import 'package:friendzchat/presentation/widgets/primary_button.dart';
import 'package:friendzchat/theme/app_dimensions.dart';
import 'package:friendzchat/utils/extensions.dart';

class ContactsAddScreen extends ConsumerStatefulWidget {
  const ContactsAddScreen({super.key});

  @override
  ConsumerState<ContactsAddScreen> createState() =>
      _ContactsAddScreenState();
}

class _ContactsAddScreenState extends ConsumerState<ContactsAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    final res = await ref.read(contactsProvider.notifier).addContact(
          userId: _idController.text.trim(),
          name: _nameController.text.trim(),
          phoneNumber: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        );
    if (!mounted) return;
    setState(() => _busy = false);

    res.when(
      onSuccess: (_) => context.pop(),
      onFailure: (f) => context.showSnack(f.message, isError: true),
    );
  }

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.l,
            AppSpacing.s,
            AppSpacing.l,
            AppSpacing.l,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'ADD CONTACT',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.primary,
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.s),
                Text(
                  'Save a FriendZChat ID',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.s),
                Text(
                  'Add the people you call so they\'re always within reach.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                TextFormField(
                  controller: _idController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'FriendZChat ID',
                    hintText: '6 digits',
                    prefixIcon: Icon(Icons.tag_rounded),
                    counterText: '',
                  ),
                  validator: FormValidators.userId(),
                ),
                const SizedBox(height: AppSpacing.l),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'What should we call them?',
                    prefixIcon: Icon(Icons.person_rounded),
                  ),
                  validator: FormValidators.nickname(),
                ),
                const SizedBox(height: AppSpacing.l),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone number (optional)',
                    prefixIcon: Icon(Icons.phone_rounded),
                  ),
                  validator: FormValidators.optionalPhone(),
                ),
                const SizedBox(height: AppSpacing.l),
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                    hintText: 'Anything to remember about this contact',
                    prefixIcon: Icon(Icons.note_rounded),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: AppSpacing.huge),
                PrimaryButton(
                  label: 'Save contact',
                  icon: Icons.check_rounded,
                  busy: _busy,
                  onPressed: _busy ? null : _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}