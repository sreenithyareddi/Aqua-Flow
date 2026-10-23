
import 'package:flutter/material.dart';

const Color quickBlue = Color(0xFF2878F0);

class QuickAddButton extends StatelessWidget {
  final int amount;
  final VoidCallback onTap;
  final double width;

  const QuickAddButton({
    super.key,
    required this.amount,
    required this.onTap,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha:0.15),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5F2FF),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.water_drop_rounded,
                    color: quickBlue,
                    size: 25,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '$amount ml',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '+ Add water',
                  style: TextStyle(
                    color: quickBlue,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
