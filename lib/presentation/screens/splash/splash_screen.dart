/// Splash screen — premium cinematic intro.
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:friendzchat/core/constants/app_constants.dart';
import 'package:friendzchat/core/router/app_routes.dart';
import 'package:friendzchat/presentation/providers/auth_provider.dart';
import 'package:friendzchat/presentation/providers/prefs_provider.dart';
import 'package:friendzchat/theme/app_colors.dart';
import 'package:friendzchat/theme/app_dimensions.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _navigate());
  }

  void _navigate() {
    Future<void>.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      final auth = ref.read(authStateProvider);
      final prefs = ref.read(prefsStateProvider);
      if (!prefs.onboardingComplete) {
        context.go(AppRoutes.onboarding);
      } else if (!auth.isRegistered) {
        context.go(AppRoutes.register);
      } else {
        context.go(AppRoutes.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppColors.premiumGradient),
        child: Stack(
          children: [
            // Soft radial glow behind the logo.
            Positioned(
              top: -120,
              left: -80,
              child: _Glow(
                size: 320,
                color: const Color(0xFF6366F1).withValues(alpha: 0.45),
              ),
            ),
            Positioned(
              bottom: -100,
              right: -60,
              child: _Glow(
                size: 280,
                color: const Color(0xFF17BEBB).withValues(alpha: 0.35),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 132,
                    height: 132,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF6366F1), Color(0xFF0E7C7B)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1)
                              .withValues(alpha: 0.45),
                          blurRadius: 48,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.shield_rounded,
                      size: 64,
                      color: Colors.white,
                    ),
                  )
                      .animate()
                      .scale(
                        duration: AppDurations.long,
                        curve: Curves.easeOutBack,
                      )
                      .then()
                      .shimmer(
                        duration: const Duration(milliseconds: 1200),
                        color: Colors.white24,
                      ),
                  const SizedBox(height: AppSpacing.xxl),
                  Text(
                    AppConstants.serviceName,
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.6,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 350))
                      .slideY(begin: 0.2, end: 0),
                  const SizedBox(height: AppSpacing.s),
                  Text(
                    AppConstants.tagline,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.75),
                      letterSpacing: 0.5,
                    ),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 600)),
                  const SizedBox(height: AppSpacing.huge),
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 900)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withValues(alpha: 0)],
            stops: const [0.0, 1.0],
          ),
        ),
      ),
    );
  }
}