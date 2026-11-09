
import 'package:flutter/material.dart';
import '../models/drink.dart';
import '../widgets/drink_tile.dart';

class HistoryScreen extends StatelessWidget {
  final List<Drink> drinks;
  final int intake, goal;
  final VoidCallback onReset;

  const HistoryScreen({
    super.key,
    required this.drinks,
    required this.intake,
    required this.goal,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('Water History',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                const Text('Total daily intake'),
                const SizedBox(height: 8),
                Text('$intake ml',
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold,
                        color: Color(0xFF2878F0))),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  color: const Color(0xFF2878F0),
                  value: (intake / goal).clamp(0.0, 1.0),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(height: 6),
                Text('Goal: $goal ml'),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),
        const Text('All drinks',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),

        if (drinks.isEmpty)
          const Padding(
            padding: EdgeInsets.all(30),
            child: Center(child: Text('No drinks recorded yet.')),
          )
        else
          ...drinks.map((d) => DrinkTile(drink: d)),

        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: drinks.isEmpty ? null : onReset,
          icon: const Icon(Icons.delete_outline),
          label: const Text('Reset today'),
        ),
      ],
    );
  }
}
