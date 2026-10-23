
import 'package:flutter/material.dart';
import 'progress_ring.dart';

const Color hydrationBlue = Color(0xFF2878F0);

class HydrationCard extends StatelessWidget {
  final int intake;
  final int goal;
  final int remaining;
  final double progress;

  const HydrationCard({
    super.key,
    required this.intake,
    required this.goal,
    required this.remaining,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 500;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF3689FF),
                Color(0xFF3156D9),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: hydrationBlue.withValues(alpha:0.22),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Stack(
              children: [
                const Positioned(
                  top: -65,
                  right: -35,
                  child: _DecorativeCircle(size: 190),
                ),
                const Positioned(
                  bottom: -95,
                  left: 100,
                  child: _DecorativeCircle(size: 190),
                ),
                Padding(
                  padding: EdgeInsets.all(wide ? 30 : 22),
                  child: wide
                      ? Row(
                          children: [
                            Expanded(child: _heroText()),
                            const SizedBox(width: 20),
                            ProgressRing(
                              progress: progress,
                              size: 156,
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            _heroText(),
                            const SizedBox(height: 22),
                            Center(
                              child: ProgressRing(
                                progress: progress,
                                size: 142,
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _heroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.water_drop_rounded,
              color: Colors.white70,
              size: 18,
            ),
            SizedBox(width: 7),
            Text(
              "TODAY'S HYDRATION",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            '${(intake / 1000).toStringAsFixed(2)} L',
            style: const TextStyle(
              fontSize: 44,
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.5,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'of ${(goal / 1000).toStringAsFixed(1)} L daily goal',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha:0.17),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            progress >= 1
                ? '🎉 Daily goal reached!'
                : '💧 ${(remaining / 1000).toStringAsFixed(2)} L to go',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _DecorativeCircle extends StatelessWidget {
  final double size;

  const _DecorativeCircle({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha:0.07),
        border: Border.all(
          color: Colors.white.withValues(alpha:0.08),
        ),
      ),
    );
  }
}
