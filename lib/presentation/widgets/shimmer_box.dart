/// Shared widget: shimmer loading placeholder for cards / rows.
library;

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:friendzchat/theme/app_dimensions.dart';

class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    this.height = 16,
    this.width = double.infinity,
    this.radius = AppRadius.s,
  });

  final double height;
  final double width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final highlight =
        isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9);
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      period: const Duration(milliseconds: 1400),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: base,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

/// List-view placeholder with three shimmer rows.
class ShimmerListPlaceholder extends StatelessWidget {
  const ShimmerListPlaceholder({super.key, this.rows = 4});

  final int rows;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.l),
      itemCount: rows,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.l),
      itemBuilder: (_, __) => Row(
        children: const [
          ShimmerBox(height: 56, width: 56, radius: 28),
          SizedBox(width: AppSpacing.l),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(height: 16, width: 160),
                SizedBox(height: AppSpacing.s),
                ShimmerBox(height: 12, width: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}