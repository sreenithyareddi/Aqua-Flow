
import 'package:flutter/material.dart';

class QuickAddButton extends StatelessWidget {
  final int amount;
  final double width;
  final VoidCallback onTap;

  const QuickAddButton({
    super.key,
    required this.amount,
    required this.width,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFF2878F0)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Column(children: [
          const Icon(Icons.water_drop, color: Color(0xFF2878F0)),
          const SizedBox(height: 6),
          Text('$amount ml',
              style: const TextStyle(
                  color: Color(0xFF172B4D),
                  fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }
}
