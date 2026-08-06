/// Registration screen — collects the 6-digit FriendZChat ID.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:friendzchat/core/constants/app_constants.dart';
import 'package:friendzchat/core/constants/service_constants.dart';
import 'package:friendzchat/core/router/app_routes.dart';
import 'package:friendzchat/presentation/providers/auth_provider.dart';
import 'package:friendzchat/presentation/widgets/primary_button.dart';
import 'package:friendzchat/theme/app_dimensions.dart';
import 'package:friendzchat/utils/extensions.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _nicknameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _callService() async {
    final uri = Uri(scheme: 'tel', path: AppConstants.serviceShortCode);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      context.showSnack('Could not launch the dialer');
    }
  }

  Future<void> _smsService() async {
    final uri = Uri(
      scheme: 'smsto',
      path: AppConstants.serviceShortCode,
      queryParameters: {'body': 'OK'},
    );
    final ok = await canLaunchUrl(uri);
    if (ok) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      context.showSnack('Could not launch the SMS app');
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final id = _idController.text.trim();
    final res = await ref.read(authStateProvider.notifier).register(
          userId: id,
          nickname: _nicknameController.text.trim().isEmpty
              ? null
              : _nicknameController.text.trim(),
          phoneNumber: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
        );
    if (!mounted) return;
    res.when(
      onSuccess: (_) => context.go(AppRoutes.home),
      onFailure: (f) => context.showSnack(f.message, isError: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(authStateProvider);
    return Scaffold(
      appBar: AppBar(
        // No back button — /register is an entry point reached via
        // context.go() (after onboarding or logout), so there's no stack
        // to pop. The "I already have an account" link below covers the
        // path to /login.
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
                  'SET UP ACCOUNT',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.s),
                Text(
                  'Get your ID',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.s),
                Text(
                  'Follow three quick steps to receive your 6-digit FriendZChat ID.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                _Step(
                  index: 1,
                  title: 'Call ${AppConstants.serviceShortCode}',
                  body: 'Dial the service number from your phone.',
                  icon: Icons.phone_rounded,
                  onAction: _callService,
                  actionLabel: 'Call now',
                ),
                _Step(
                  index: 2,
                  title: 'Send "OK" to ${AppConstants.serviceShortCode}',
                  body:
                      'Once the voice prompts finish, text OK to confirm registration.',
                  icon: Icons.sms_rounded,
                  onAction: _smsService,
                  actionLabel: 'Send SMS',
                ),
                _Step(
                  index: 3,
                  title: 'Receive your ID',
                  body:
                      'The system will reply with a 6-digit ID. Enter it below — we\'ll keep it safe.',
                  icon: Icons.badge_rounded,
                ),
                const SizedBox(height: AppSpacing.xxl),
                _SectionLabel('Your 6-digit ID'),
                const SizedBox(height: AppSpacing.s),
                TextFormField(
                  controller: _idController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  style: theme.textTheme.headlineMedium?.copyWith(
                    letterSpacing: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: '000000',
                    counterText: '',
                  ),
                  validator: FormValidators.userId(),
                ),
                const SizedBox(height: AppSpacing.l),
                _SectionLabel('Profile (optional)'),
                const SizedBox(height: AppSpacing.s),
                TextFormField(
                  controller: _nicknameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nickname',
                    hintText: 'How should we greet you?',
                    prefixIcon: Icon(Icons.person_rounded),
                  ),
                ),
                const SizedBox(height: AppSpacing.l),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone number',
                    hintText: 'Used to reach you if your ID is lost',
                    prefixIcon: Icon(Icons.phone_rounded),
                  ),
                  validator: FormValidators.optionalPhone(),
                ),
                const SizedBox(height: AppSpacing.huge),
                PrimaryButton(
                  label: 'Continue',
                  icon: Icons.check_rounded,
                  busy: state.isLoading,
                  onPressed: state.isLoading ? null : _submit,
                ),
                if (state.error != null) ...[
                  const SizedBox(height: AppSpacing.l),
                  _InlineError(message: state.error!),
                ],
                const SizedBox(height: AppSpacing.l),
                Center(
                  child: TextButton(
                    onPressed: () => context.push(AppRoutes.login),
                    child: const Text('I already have an account'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.titleSmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.m,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(AppRadius.m),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_rounded,
            size: 20,
            color: theme.colorScheme.onErrorContainer,
          ),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.index,
    required this.title,
    required this.body,
    required this.icon,
    this.onAction,
    this.actionLabel,
  });

  final int index;
  final String title;
  final String body;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.m),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.l),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.l),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Text(
                '$index',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.l),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    body,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.45,
                    ),
                  ),
                  if (onAction != null && actionLabel != null) ...[
                    const SizedBox(height: AppSpacing.s),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: onAction,
                        icon: Icon(icon, size: 18),
                        label: Text(actionLabel!),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.m,
                          ),
                        ),
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