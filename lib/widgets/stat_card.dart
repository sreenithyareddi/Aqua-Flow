
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Color iconColor;
  final double width;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: iconColor,
                  child: Icon(icon, color: const Color(0xFF2878F0)),
                ),
                const SizedBox(height: 12),
                Text(title,
                    style: const TextStyle(color: Colors.blueGrey)),
                const SizedBox(height: 5),
                Text(value,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
