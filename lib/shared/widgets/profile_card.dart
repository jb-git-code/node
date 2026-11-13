import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CompletionProfileCard extends StatelessWidget {
  final String name, handle, email;
  final AsyncValue<int> createdCountAsync, savedCountAsync, totalStarsAsync;
  final bool hasProfilePic, hasLinkedIn, hasGitHub;

  const CompletionProfileCard({
    super.key,
    required this.name,
    required this.handle,
    required this.email,
    required this.createdCountAsync,
    required this.savedCountAsync,
    required this.totalStarsAsync,
    this.hasProfilePic = false,
    this.hasLinkedIn = false,
    this.hasGitHub = false,
  });

  double get _completion =>
      [
        (createdCountAsync.value ?? 0) > 0,
        (savedCountAsync.value ?? 0) > 0,
        hasProfilePic,
        hasLinkedIn,
        hasGitHub,
      ].where((e) => e).length /
      5;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: colors.surface,
            border: Border.all(color: colors.outline), // flat border, no shadow
          ),
          child: Row(
            children: [
              _avatar(colors),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.titleLarge?.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      handle,
                      style: text.bodySmall?.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _pill(LucideIcons.network, createdCountAsync, colors),
                        _pill(LucideIcons.bookmark, savedCountAsync, colors),
                        _pill(LucideIcons.star, totalStarsAsync, colors),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.06, curve: Curves.easeOutCubic);
  }

  Widget _avatar(ColorScheme colors) {
    final pct = _completion;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: pct),
      duration: 1400.ms,
      curve: Curves.easeOutCubic,
      builder: (_, p, _) => SizedBox(
        width: 104,
        height: 104,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Completion ring: solid ink on a light grey track
            CustomPaint(
              size: const Size(104, 104),
              painter: _RingPainter(p, colors.primary, colors.outline),
            ),
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.surfaceContainerHigh,
              ),
              child: Icon(
                LucideIcons.user,
                size: 48,
                color: colors.onSurfaceVariant,
              ),
            ),
            // Percentage badge
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(p * 100).round()}%',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: colors.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack);
  }

  Widget _pill(IconData icon, AsyncValue<int> v, ColorScheme colors) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 7, 12, 7),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colors.onSurfaceVariant),
          const SizedBox(width: 6),
          v.when(
            data: (n) => TweenAnimationBuilder<int>(
              tween: IntTween(begin: 0, end: n),
              duration: 1000.ms,
              curve: Curves.easeOutCubic,
              builder: (_, val, _) => Text(
                '$val',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
            loading: () =>
                Text('–', style: TextStyle(color: colors.onSurfaceVariant)),
            error: (_, _) => Text(
              '!',
              style: TextStyle(color: colors.error), // the red error color
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color track;
  _RingPainter(this.progress, this.color, this.track);

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 5.0;
    final rect = (Offset.zero & size).deflate(stroke / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    // Track (full circle)
    canvas.drawArc(rect, 0, math.pi * 2, false, paint..color = track);
    if (progress <= 0) return;

    // Progress arc (solid color, starts at 12 o'clock)
    final sweep = math.max(progress * math.pi * 2, 0.01);
    canvas.drawArc(rect, -math.pi / 2, sweep, false, paint..color = color);
  }

  @override
  bool shouldRepaint(_RingPainter o) =>
      o.progress != progress || o.color != color || o.track != track;
}
