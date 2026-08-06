/// Login screen — phone + OTP flow (optional, for future REST/Firebase auth).
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:friendzchat/core/constants/service_constants.dart';
import 'package:friendzchat/core/router/app_routes.dart';
import 'package:friendzchat/presentation/providers/auth_provider.dart';
import 'package:friendzchat/presentation/widgets/primary_button.dart';
import 'package:friendzchat/theme/app_dimensions.dart';
import 'package:friendzchat/utils/extensions.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _otpRequested = false;
  bool _busy = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _request() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    final res = await ref.read(authRepositoryProvider).requestOtp(
          _phoneController.text.trim(),
        );
    if (!mounted) return;
    setState(() {
      _busy = false;
      _otpRequested = res.isSuccess;
    });
    res.when(
      onSuccess: (_) => context.showSnack('OTP sent (use 123456 for demo)'),
      onFailure: (f) => context.showSnack(f.message, isError: true),
    );
  }

  Future<void> _verify() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    final res = await ref.read(authStateProvider.notifier).verifyOtp(
          phoneNumber: _phoneController.text.trim(),
          otp: _otpController.text.trim(),
        );
    if (!mounted) return;
    setState(() => _busy = false);
    res.when(
      onSuccess: (_) => context.go(AppRoutes.home),
      onFailure: (f) => context.showSnack(f.message, isError: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
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
                  'WELCOME BACK',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.s),
                Text(
                  'Sign in to FriendZChat',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.s),
                Text(
                  'Enter your phone number and we\'ll send you a one-time code.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone number',
                    hintText: '+1 555 123 4567',
                    prefixIcon: Icon(Icons.phone_rounded),
                  ),
                  validator: FormValidators.optionalPhone(),
                ),
                if (_otpRequested) ...[
                  const SizedBox(height: AppSpacing.l),
                  TextFormField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'One-time code',
                      hintText: '123456',
                      counterText: '',
                      prefixIcon: Icon(Icons.lock_clock_rounded),
                    ),
                    validator: FormValidators.otp(),
                  ),
                ],
                const SizedBox(height: AppSpacing.huge),
                PrimaryButton(
                  label: _otpRequested ? 'Verify & continue' : 'Send OTP',
                  icon:
                      _otpRequested ? Icons.lock_open_rounded : Icons.sms_rounded,
                  busy: _busy,
                  onPressed:
                      _busy ? null : (_otpRequested ? _verify : _request),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}