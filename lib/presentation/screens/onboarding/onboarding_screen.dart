/// Onboarding — three pages explaining what FriendZChat is.
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:friendzchat/core/constants/app_constants.dart';
import 'package:friendzchat/core/router/app_routes.dart';
import 'package:friendzchat/core/strings/strings.dart';
import 'package:friendzchat/presentation/providers/prefs_provider.dart';
import 'package:friendzchat/presentation/widgets/primary_button.dart';
import 'package:friendzchat/theme/app_colors.dart';
import 'package:friendzchat/theme/app_dimensions.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  static const List<_OnboardingPage> _pages = [
    _OnboardingPage(
      eyebrowKey: 'onboarding.eyebrow.welcome',
      titleKey: 'onboarding.title.welcome',
      bodyKey: 'onboarding.body.welcome',
      icon: Icons.shield_moon_rounded,
      gradient: [Color(0xFF6366F1), Color(0xFF0E7C7B)],
    ),
    _OnboardingPage(
      eyebrowKey: 'onboarding.eyebrow.howItWorks',
      titleKey: 'onboarding.title.howItWorks',
      bodyKey: 'onboarding.body.howItWorks',
      icon: Icons.hub_rounded,
      gradient: [Color(0xFF0E7C7B), Color(0xFF17BEBB)],
    ),
    _OnboardingPage(
      eyebrowKey: 'onboarding.eyebrow.getStarted',
      titleKey: 'onboarding.title.getStarted',
      bodyKey: 'onboarding.body.getStarted',
      icon: Icons.badge_rounded,
      gradient: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
    ),
  ];

  Future<void> _next() async {
    if (_index < _pages.length - 1) {
      await _controller.nextPage(
        duration: AppDurations.medium,
        curve: Curves.easeInOutCubic,
      );
    } else {
      await ref.read(prefsStateProvider.notifier).markOnboardingComplete();
      if (!mounted) return;
      context.go(AppRoutes.register);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final last = _index == _pages.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.l,
                AppSpacing.s,
                AppSpacing.s,
                0,
              ),
              child: Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      await ref
                          .read(prefsStateProvider.notifier)
                          .markOnboardingComplete();
                      if (!mounted) return;
                      context.go(AppRoutes.register);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.onSurfaceVariant,
                    ),
                    child: Text(context.strings['onboarding.skip']),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) => _OnboardingPageView(page: _pages[i]),
              ),
            ),
            const SizedBox(height: AppSpacing.l),
            _DotIndicator(count: _pages.length, index: _index),
            const SizedBox(height: AppSpacing.xl),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
              child: PrimaryButton(
                label: last
                    ? context.strings['onboarding.getStarted']
                    : context.strings['onboarding.continue'],
                icon: last ? Icons.arrow_forward_rounded : null,
                onPressed: _next,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage {
  const _OnboardingPage({
    required this.eyebrowKey,
    required this.titleKey,
    required this.bodyKey,
    required this.icon,
    required this.gradient,
  });
  final String eyebrowKey;
  final String titleKey;
  final String bodyKey;
  final IconData icon;
  final List<Color> gradient;
}

class _OnboardingPageView extends StatelessWidget {
  const _OnboardingPageView({required this.page});
  final _OnboardingPage page;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 176,
            height: 176,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: page.gradient,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: page.gradient.first.withValues(alpha: 0.35),
                  blurRadius: 48,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Icon(
              page.icon,
              size: 80,
              color: Colors.white,
            ),
          )
              .animate()
              .scale(
                duration: AppDurations.medium,
                curve: Curves.easeOutBack,
              ),
          const SizedBox(height: AppSpacing.huge),
          Text(
            context.strings[page.eyebrowKey].toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: page.gradient.first,
              letterSpacing: 1.6,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            context.strings[page.titleKey],
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.15,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          Text(
            context.strings[page.bodyKey],
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _DotIndicator extends StatelessWidget {
  const _DotIndicator({required this.count, required this.index});
  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: AppDurations.short,
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: active ? 28 : 8,
          decoration: BoxDecoration(
            color: active
                ? primary
                : Theme.of(context).colorScheme.outlineVariant,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
        );
      }),
    );
  }
}