/// Shared widget: avatar with initials fallback and tonal color hash.
library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:friendzchat/theme/app_dimensions.dart';

class ContactAvatar extends StatelessWidget {
  const ContactAvatar({
    super.key,
    required this.name,
    this.photoUrl,
    this.size = 48,
  });

  final String name;
  final String? photoUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final initials = _initials(name);
    final scheme = Theme.of(context).colorScheme;
    final color = _colorFor(initials, scheme);

    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: photoUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (_, __) => _fallback(initials, color, size),
          errorWidget: (_, __, ___) => _fallback(initials, color, size),
        ),
      );
    }
    return _fallback(initials, color, size);
  }

  Widget _fallback(String initials, Color color, double size) => Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color, color.withValues(alpha: 0.7)],
          ),
          shape: BoxShape.circle,
        ),
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: size / 2.6,
            letterSpacing: 0.5,
          ),
        ),
      );

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  Color _colorFor(String seed, ColorScheme scheme) {
    final hash = seed.codeUnits.fold<int>(0, (a, b) => a + b);
    final colors = [
      scheme.primary,
      scheme.secondary,
      scheme.tertiary,
      scheme.primary,
      scheme.secondary,
    ];
    return colors[hash % colors.length];
  }
}

/// Standardised spacing helpers.
class SpacerGap extends StatelessWidget {
  const SpacerGap({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(width: size, height: size);
}