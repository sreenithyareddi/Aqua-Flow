
import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';

const Color insightsBlue = Color(0xFF2878F0);

class InsightsScreen extends StatelessWidget {
  final int intake;
  final int goal;
  final double progress;
  final int drinkCount;
  final bool reminderEnabled;
  final ValueChanged<bool> onReminderChanged;
  final VoidCallback onEditGoal;

  const InsightsScreen({
    super.key,
    required this.intake,
    required this.goal,
    required this.progress,
    required this.drinkCount,
    required this.reminderEnabled,
    required this.onReminderChanged,
    required this.onEditGoal,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = (goal - intake).clamp(0, goal);
    final completed = intake >= goal;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Insights',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Track your hydration progress.',
            style: TextStyle(color: Colors.blueGrey),
          ),
          const SizedBox(height: 24),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daily goal progress',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    height: 150,
                    width: 150,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 150,
                          width: 150,
                          child: CircularProgressIndicator(
                            value: progress.clamp(0.0, 1.0),
                            strokeWidth: 12,
                            backgroundColor:
                                Colors.blueGrey.withValues(alpha: 0.15),
                            color: insightsBlue,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${(progress * 100).round()}%',
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text('completed'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    completed
                        ? 'Daily goal achieved! Great work.'
                        : '$remaining ml remaining to reach your goal.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Your statistics',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              StatCard(
                title: 'Water consumed',
                value: '${(intake / 1000).toStringAsFixed(2)} L',
                icon: Icons.water_drop_rounded,
                iconColor: insightsBlue,
              ),
              StatCard(
                title: 'Daily goal',
                value: '${(goal / 1000).toStringAsFixed(1)} L',
                icon: Icons.flag_rounded,
                iconColor: Colors.orange,
              ),
              StatCard(
                title: 'Drinks logged',
                value: '$drinkCount',
                icon: Icons.local_drink_rounded,
                iconColor: Colors.teal,
              ),
            ],
          ),

          const SizedBox(height: 24),

          Card(
            elevation: 0,
            child: SwitchListTile(
              value: reminderEnabled,
              onChanged: onReminderChanged,
              secondary: const Icon(
                Icons.notifications_active_outlined,
                color: insightsBlue,
              ),
              title: const Text(
                'Hydration reminders',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Enable or disable the reminder preference.',
              ),
            ),
          ),

          const SizedBox(height: 12),

          Card(
            elevation: 0,
            child: ListTile(
              leading: const Icon(
                Icons.flag_outlined,
                color: insightsBlue,
              ),
              title: const Text(
                'Daily water goal',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('$goal ml per day'),
              trailing: const Icon(Icons.edit_outlined),
              onTap: onEditGoal,
            ),
          ),

          const SizedBox(height: 20),

          const Card(
            elevation: 0,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: insightsBlue),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your current tracking data is stored in memory '
                      'and may reset when the app restarts. Reminders '
                      'are a preference only; notifications are not '
                      'scheduled by this screen.',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
