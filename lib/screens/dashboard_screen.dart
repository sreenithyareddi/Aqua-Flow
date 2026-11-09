
import 'package:flutter/material.dart';
import '../models/drink.dart';
import '../widgets/drink_tile.dart';
import '../widgets/hydration_card.dart';
import '../widgets/quick_add_button.dart';
import '../widgets/stat_card.dart';

const blue = Color(0xFF2878F0);
const navy = Color(0xFF172B4D);

class DashboardScreen extends StatelessWidget {
  final int intake, goal, remaining;
  final double progress;
  final List<Drink> drinks;
  final ValueChanged<int> onAddWater;
  final VoidCallback onAddCustomWater, onEditGoal, onViewHistory;

  const DashboardScreen({
    super.key,
    required this.intake,
    required this.goal,
    required this.remaining,
    required this.progress,
    required this.drinks,
    required this.onAddWater,
    required this.onAddCustomWater,
    required this.onEditGoal,
    required this.onViewHistory,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final wide = c.maxWidth >= 650;
      final pad = c.maxWidth < 380 ? 14.0 : 24.0;
      final w = c.maxWidth < 380
          ? ((c.maxWidth - 24) / 3).clamp(85.0, 180.0)
          : 160.0;

      return SingleChildScrollView(
        padding: EdgeInsets.all(pad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Hello, Hydrator! 👋',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Small sips, big difference.',
                style: TextStyle(color: Colors.blueGrey)),
            const SizedBox(height: 24),

            HydrationCard(
              intake: intake,
              goal: goal,
              remaining: remaining,
              progress: progress,
            ),

            const SizedBox(height: 22),

            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                StatCard(
                  title: 'Daily goal',
                  value: '${(goal / 1000).toStringAsFixed(1)} L',
                  icon: Icons.flag,
                  iconColor: const Color(0xFFE8F0FF),
                  width: wide ? 210 : 150,
                  onTap: onEditGoal,
                ),
                StatCard(
                  title: 'Remaining',
                  value: '${(remaining / 1000).toStringAsFixed(2)} L',
                  icon: Icons.water_drop,
                  iconColor: const Color(0xFFDDF7F1),
                  width: wide ? 210 : 150,
                ),
                StatCard(
                  title: 'Completed',
                  value: '${(progress * 100).round()}%',
                  icon: Icons.bolt,
                  iconColor: const Color(0xFFFFEFD9),
                  width: wide ? 210 : 150,
                ),
              ],
            ),

            const SizedBox(height: 28),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Quick add',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: onAddCustomWater,
                  icon: const Icon(Icons.add),
                  label: const Text('Custom'),
                ),
              ],
            ),
            const Text('How much water did you drink?',
                style: TextStyle(color: Colors.blueGrey)),
            const SizedBox(height: 16),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [150, 250, 500].map((a) =>
                QuickAddButton(
                  amount: a,
                  width: w,
                  onTap: () => onAddWater(a),
                ),
              ).toList(),
            ),

            const SizedBox(height: 28),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recent drinks',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: onViewHistory,
                  child: const Text('View all'),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (drinks.isEmpty)
              const _EmptyCard()
            else
              ...drinks.take(3).map((d) => DrinkTile(drink: d)),

            const SizedBox(height: 22),
          ],
        ),
      );
    });
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(children: [
        Icon(Icons.local_drink, size: 36, color: blue),
        SizedBox(height: 10),
        Text('Your day starts here',
            style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text('Add your first glass of water above.',
            textAlign: TextAlign.center),
      ]),
    );
  }
}
