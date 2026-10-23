
import 'package:flutter/material.dart';

class ProgressRing extends StatelessWidget {
  final double progress;
  final double size;

  const ProgressRing({
    super.key,
    required this.progress,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress),
      duration: const Duration(milliseconds: 700),
      builder: (context, value, child) {
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: 1,
                  strokeWidth: 11,
                  color: Colors.white.withValues(alpha:0.22),
                ),
              ),
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: 11,
                  strokeCap: StrokeCap.round,
                  backgroundColor: Colors.transparent,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.water_drop_rounded,
                    color: Colors.white,
                    size: 25,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${(value * 100).round()}%',
                    style: TextStyle(
                      fontSize: size * 0.19,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'completed',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
