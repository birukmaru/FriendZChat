/// Splash screen — premium cinematic intro using the brand logo SVG.
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:friendzchat/core/constants/app_constants.dart';
import 'package:friendzchat/core/router/app_routes.dart';
import 'package:friendzchat/core/strings/strings.dart';
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
                  // Brand logo (SVG) with a halo shadow.
                  Container(
                    width: 132,
                    height: 132,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1)
                              .withValues(alpha: 0.45),
                          blurRadius: 48,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: SvgPicture.asset(
                      'assets/images/icons/ic_logo.svg',
                      fit: BoxFit.cover,
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
                    context.strings['splash.tagline'],
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.75),
                      letterSpacing: 0.5,
                    ),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 600)),
                  const SizedBox(height: AppSpacing.huge),
                  // Three pulsing dots — a chat "typing" indicator that
                  // reinforces the FriendZChat identity (this is a chat
                  // app, after all) instead of a generic spinner.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (i) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                        ),
                        child: _PulseDot(
                          color: Colors.white.withValues(alpha: 0.85),
                          delayMs: 900 + i * 160,
                        ),
                      );
                    }),
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

/// A single chat "typing" dot that pulses in size and opacity.
class _PulseDot extends StatelessWidget {
  const _PulseDot({required this.color, required this.delayMs});

  final Color color;
  final int delayMs;

  @override
  Widget build(BuildContext context) {
    return Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        )
        .animate(onPlay: (c) => c.repeat())
        .scaleXY(
          begin: 0.6,
          end: 1.0,
          duration: const Duration(milliseconds: 700),
          delay: Duration(milliseconds: delayMs),
          curve: Curves.easeInOut,
        )
        .then()
        .scaleXY(
          begin: 1.0,
          end: 0.6,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
        )
        .fade(
          begin: 0.4,
          end: 1.0,
          duration: const Duration(milliseconds: 1400),
          delay: Duration(milliseconds: delayMs),
        );
  }
}