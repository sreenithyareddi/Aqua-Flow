
import 'package:flutter/material.dart';
import '../models/drink.dart';
import '../widgets/drink_tile.dart';
import '../widgets/hydration_card.dart';
import '../widgets/quick_add_button.dart';
import '../widgets/stat_card.dart';

const Color dashboardBlue = Color(0xFF2878F0);
const Color dashboardNavy = Color(0xFF172B4D);

class DashboardScreen extends StatelessWidget {
  final int intake;
  final int goal;
  final int remaining;
  final double progress;
  final List<Drink> drinks;

  final ValueChanged<int> onAddWater;
  final VoidCallback onAddCustomWater;
  final VoidCallback onEditGoal;
  final VoidCallback onViewHistory;
  final VoidCallback onUndo;
  final VoidCallback onReset;

  final bool reminderEnabled;
  final ValueChanged<bool> onReminderChanged;

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
    required this.onUndo,
    required this.onReset,
    required this.reminderEnabled,
    required this.onReminderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 650;
        final padding =
            constraints.maxWidth < 380 ? 14.0 : 24.0;

        final buttonWidth = constraints.maxWidth < 380
            ? ((constraints.maxWidth - 24) / 3)
                .clamp(85.0, 180.0)
            : 160.0;

        return SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, Hydrator! 👋',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.8,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Small sips, big difference.',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: () =>
                        onReminderChanged(!reminderEnabled),
                    tooltip: 'Toggle reminder preference',
                    icon: Icon(
                      reminderEnabled
                          ? Icons.notifications_active_rounded
                          : Icons.notifications_off_rounded,
                    ),
                  ),
                ],
              ),

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
                    icon: Icons.flag_rounded,
                    iconColor: const Color(0xFFE8F0FF),
                    width: wide ? 210 : 150,
                    onTap: onEditGoal,
                  ),
                  StatCard(
                    title: 'Remaining',
                    value:
                        '${(remaining / 1000).toStringAsFixed(2)} L',
                    icon: Icons.water_drop_rounded,
                    iconColor: const Color(0xFFDDF7F1),
                    width: wide ? 210 : 150,
                  ),
                  StatCard(
                    title: 'Completed',
                    value: '${(progress * 100).round()}%',
                    icon: Icons.bolt_rounded,
                    iconColor: const Color(0xFFFFEFD9),
                    width: wide ? 210 : 150,
                  ),
                ],
              ),

              const SizedBox(height: 28),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Quick add',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: onAddCustomWater,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Custom'),
                  ),
                ],
              ),

              const SizedBox(height: 5),
              const Text(
                'How much water did you drink?',
                style: TextStyle(color: Colors.blueGrey),
              ),
              const SizedBox(height: 16),

              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [150, 250, 500]
                    .map(
                      (amount) => QuickAddButton(
                        amount: amount,
                        width: buttonWidth,
                        onTap: () => onAddWater(amount),
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 28),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent drinks',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextButton(
                    onPressed: onViewHistory,
                    child: const Text('View all'),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              if (drinks.isEmpty)
                const _EmptyCard(
                  icon: Icons.local_drink_rounded,
                  title: 'Your day starts here',
                  subtitle: 'Add your first glass of water above.',
                )
              else
                ...drinks
                    .take(3)
                    .map((drink) => DrinkTile(drink: drink)),

              const SizedBox(height: 22),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFE7F3FF),
                      Color(0xFFF1EDFF),
                    ],
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.tips_and_updates_rounded,
                      size: 34,
                      color: Color(0xFF386CE0),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your daily tip',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: dashboardNavy,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Keep a water bottle nearby and drink '
                            'regularly throughout the day.',
                            style: TextStyle(
                              color: Color(0xFF526681),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Center(
                child: TextButton.icon(
                  onPressed: drinks.isEmpty ? null : onUndo,
                  icon: const Icon(Icons.undo_rounded),
                  label: const Text('Undo last drink'),
                ),
              ),

              Center(
                child: TextButton(
                  onPressed: drinks.isEmpty ? null : onReset,
                  child: const Text('Reset today'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, size: 36, color: dashboardBlue),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
