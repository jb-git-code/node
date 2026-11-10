import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CompletionProfileCard extends StatelessWidget {
  final String name, handle, email;
  final AsyncValue<int> createdCountAsync, savedCountAsync, totalStarsAsync;
  final bool hasProfilePic, hasLinkedIn, hasGitHub;

  const CompletionProfileCard({
    Key? key,
    required this.name,
    required this.handle,
    required this.email,
    required this.createdCountAsync,
    required this.savedCountAsync,
    required this.totalStarsAsync,
    this.hasProfilePic = false,
    this.hasLinkedIn = false,
    this.hasGitHub = false,
  }) : super(key: key);

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
    final dark = Theme.of(context).brightness == Brightness.dark;
    final text = dark ? Colors.white : const Color(0xFF14261A);
    final sub = text.withOpacity(0.6);
    final accent = dark ? const Color(0xFF6EE7A0) : const Color(0xFF1B8A4B);
    final accent2 = dark ? const Color(0xFF38BDF8) : const Color(0xFF14B8A6);

    return Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
            border: Border.all(color: accent.withOpacity(dark ? 0.18 : 0.12)),
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(dark ? 0.12 : 0.15),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            children: [
              _avatar(dark, text, accent, accent2),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      handle,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: accent,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _pill(
                          Icons.hub_rounded,
                          createdCountAsync,
                          dark,
                          text,
                          accent,
                        ),
                        _pill(
                          Icons.bookmark_rounded,
                          savedCountAsync,
                          dark,
                          text,
                          accent,
                        ),
                        _pill(
                          Icons.star_rounded,
                          totalStarsAsync,
                          dark,
                          text,
                          accent,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: sub),
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

  Widget _avatar(bool dark, Color text, Color a1, Color a2) {
    final pct = _completion;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: pct),
      duration: 1400.ms,
      curve: Curves.easeOutCubic,
      builder: (_, p, __) => SizedBox(
        width: 104,
        height: 104,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // CustomPaint(
            //   size: const Size(104, 104),
            //   painter: _RingPainter(p, [a1, a2], text.withOpacity(0.08)),
            // ),
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dark ? const Color(0xFF223229) : Colors.white,
              ),
              child: Icon(
                Icons.person_rounded,
                size: 48,
                color: text.withOpacity(0.5),
              ),
            ),
            // Positioned(
            //   bottom: 0,
            //   right: 0,
            //   child: Container(
            //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            //     decoration: BoxDecoration(
            //       gradient: LinearGradient(colors: [a1, a2]),
            //       borderRadius: BorderRadius.circular(20),
            //     ),
            //     child: Text(
            //       '${(p * 100).round()}%',
            //       style: TextStyle(
            //         fontSize: 11,
            //         fontWeight: FontWeight.w800,
            //         color: dark ? const Color(0xFF0E1512) : Colors.white,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack);
  }

  Widget _pill(
    IconData icon,
    AsyncValue<int> v,
    bool dark,
    Color text,
    Color accent,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 7, 12, 7),
      decoration: BoxDecoration(
        color: dark
            ? Colors.white.withOpacity(0.07)
            : Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: text.withOpacity(0.06)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: accent),
          const SizedBox(width: 6),
          v.when(
            data: (n) => TweenAnimationBuilder<int>(
              tween: IntTween(begin: 0, end: n),
              duration: 1000.ms,
              curve: Curves.easeOutCubic,
              builder: (_, val, __) => Text(
                '$val',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: text,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
            loading: () =>
                Text('–', style: TextStyle(color: text.withOpacity(0.4))),
            error: (_, __) =>
                const Text('!', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final List<Color> colors;
  final Color track;
  _RingPainter(this.progress, this.colors, this.track);

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 5.0;
    final rect = (Offset.zero & size).deflate(stroke / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0, math.pi * 2, false, paint..color = track);
    if (progress <= 0) return;

    final sweep = math.max(progress * math.pi * 2, 0.01);
    paint.shader = SweepGradient(
      endAngle: sweep,
      colors: colors,
      transform: const GradientRotation(-math.pi / 2),
    ).createShader(rect);
    canvas.drawArc(rect, -math.pi / 2, sweep, false, paint);
  }

  @override
  bool shouldRepaint(_RingPainter o) =>
      o.progress != progress || o.colors != colors;
}
