/// Profile edit screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:friendzchat/core/constants/service_constants.dart';
import 'package:friendzchat/domain/entities/user.dart';
import 'package:friendzchat/presentation/providers/auth_provider.dart';
import 'package:friendzchat/presentation/widgets/primary_button.dart';
import 'package:friendzchat/theme/app_dimensions.dart';
import 'package:friendzchat/utils/extensions.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() =>
      _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nickname;
  late final TextEditingController _phone;
  late final TextEditingController _bio;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authStateProvider).user;
    _nickname = TextEditingController(text: user?.nickname ?? '');
    _phone = TextEditingController(text: user?.phoneNumber ?? '');
    _bio = TextEditingController(text: user?.bio ?? '');
  }

  @override
  void dispose() {
    _nickname.dispose();
    _phone.dispose();
    _bio.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    final current = ref.read(authStateProvider).user;
    if (current == null) return;
    final updated = current.copyWith(
      nickname:
          _nickname.text.trim().isEmpty ? null : _nickname.text.trim(),
      phoneNumber: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
      bio: _bio.text.trim().isEmpty ? null : _bio.text.trim(),
    );
    final res =
        await ref.read(authStateProvider.notifier).persistUser(updated);
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
    final user = ref.watch(authStateProvider).user ?? const User(id: '');
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
                  'EDIT PROFILE',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.primary,
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.s),
                Text(
                  'Make it yours',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
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
                    'ID ${user.id}',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: scheme.onPrimaryContainer,
                      letterSpacing: 1.6,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                TextFormField(
                  controller: _nickname,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nickname',
                    hintText: 'How should we greet you?',
                    prefixIcon: Icon(Icons.person_rounded),
                  ),
                  validator: FormValidators.nickname(),
                ),
                const SizedBox(height: AppSpacing.l),
                TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone (optional)',
                    hintText: 'Used to recover your ID',
                    prefixIcon: Icon(Icons.phone_rounded),
                  ),
                  validator: FormValidators.optionalPhone(),
                ),
                const SizedBox(height: AppSpacing.l),
                TextFormField(
                  controller: _bio,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Bio (optional)',
                    hintText: 'A line about yourself',
                    prefixIcon: Icon(Icons.description_rounded),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: AppSpacing.huge),
                PrimaryButton(
                  label: 'Save changes',
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