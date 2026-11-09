
import 'package:flutter/material.dart';
class HydrationCard extends StatelessWidget {
  final int intake, goal, remaining;
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
    return Card(
      color: const Color(0xFF2878F0),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Today’s hydration',
                    style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 12),
                Text('$intake ml',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold)),
                Text('of $goal ml',
                    style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 20),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: Colors.white30,
                  valueColor:
                      const AlwaysStoppedAnimation(Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(height: 12),
                Text(
                  remaining == 0
                      ? 'Daily goal completed! 🎉'
                      : '$remaining ml remaining',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            const Positioned(
              top: 0,
              right: 0,
              child: Icon(Icons.water_drop,
                  color: Colors.white24, size: 45),
            ),
          ],
        ),
      ),
    );
  }
}
