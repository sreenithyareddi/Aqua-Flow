
import 'package:flutter/material.dart';
import '../models/drink.dart';
import '../widgets/drink_tile.dart';

const Color historyBlue = Color(0xFF2878F0);

class HistoryScreen extends StatelessWidget {
  final List<Drink> drinks;
  final int intake;
  final int goal;
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
    final groupedDrinks = <String, List<Drink>>{};

    for (final drink in drinks) {
      final date = drink.time;
      final key = '${date.day}/${date.month}/${date.year}';
      groupedDrinks.putIfAbsent(key, () => []).add(drink);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Drink History',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Review the water you have logged.',
            style: TextStyle(color: Colors.blueGrey),
          ),
          const SizedBox(height: 24),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: historyBlue,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Today's intake",
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(intake / 1000).toStringAsFixed(2)} L',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Goal: ${(goal / 1000).toStringAsFixed(1)} L',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: goal > 0
                        ? (intake / goal).clamp(0.0, 1.0)
                        : 0,
                    minHeight: 9,
                    backgroundColor: Colors.white30,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Logged drinks',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text('${drinks.length} drinks'),
            ],
          ),

          const SizedBox(height: 14),

          if (drinks.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.water_drop_outlined,
                    size: 42,
                    color: historyBlue,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No drinks logged yet',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Your recorded drinks will appear here.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            ...groupedDrinks.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 12,
                      bottom: 8,
                    ),
                    child: Text(
                      entry.key,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: historyBlue,
                      ),
                    ),
                  ),
                  ...entry.value.map(
                    (drink) => DrinkTile(drink: drink),
                  ),
                ],
              );
            }),

          const SizedBox(height: 20),

          if (drinks.isNotEmpty)
            Align(
              alignment: Alignment.center,
              child: TextButton.icon(
                onPressed: () => _confirmReset(context),
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text('Clear today’s history'),
              ),
            ),
        ],
      ),
    );
  }

  void _confirmReset(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear history?'),
        content: const Text(
          'This will remove all logged drinks for today.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              onReset();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
