
import 'package:flutter/material.dart';

import 'models/drink.dart';
import 'screens/dashboard_screen.dart';
import 'screens/history_screen.dart';
import 'screens/insights_screen.dart';

const Color blue = Color(0xFF2878F0);
const Color navy = Color(0xFF172B4D);
const Color pageColor = Color(0xFFF4F7FC);

void main() {
  runApp(const SmartWaterIntakeApp());
}

class SmartWaterIntakeApp extends StatefulWidget {
  const SmartWaterIntakeApp({super.key});

  @override
  State<SmartWaterIntakeApp> createState() =>
      _SmartWaterIntakeAppState();
}

class _SmartWaterIntakeAppState
    extends State<SmartWaterIntakeApp> {
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AquaFlow',
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: pageColor,
        colorScheme: ColorScheme.fromSeed(seedColor: blue),
        cardColor: Colors.white,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: blue,
          brightness: Brightness.dark,
        ),
      ),
      home: WaterHome(
        darkMode: darkMode,
        onThemeChanged: (value) {
          setState(() => darkMode = value);
        },
      ),
    );
  }
}

class WaterHome extends StatefulWidget {
  final bool darkMode;
  final ValueChanged<bool> onThemeChanged;

  const WaterHome({
    super.key,
    required this.darkMode,
    required this.onThemeChanged,
  });

  @override
  State<WaterHome> createState() => _WaterHomeState();
}

class _WaterHomeState extends State<WaterHome> {
  int intake = 0;
  int goal = 2500;
  int selectedPage = 0;
  bool reminderEnabled = true;

  final List<Drink> drinks = [];

  double get progress => (intake / goal).clamp(0.0, 1.0);

  int get remaining => (goal - intake).clamp(0, goal);

  String get pageTitle {
    if (selectedPage == 1) return 'Water History';
    if (selectedPage == 2) return 'Your Progress';
    return 'Dashboard';
  }

  void addWater(int amount) {
    if (amount <= 0) return;

    setState(() {
      intake += amount;
      drinks.insert(0, Drink(amount: amount, time: DateTime.now()));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added $amount ml of water 💧'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void undoDrink() {
    if (drinks.isEmpty) return;

    setState(() {
      final lastDrink = drinks.removeAt(0);
      intake = (intake - lastDrink.amount).clamp(0, intake);
    });
  }

  void resetDay() {
    setState(() {
      intake = 0;
      drinks.clear();
    });
  }

  Future<void> addCustomWater() async {
    final controller = TextEditingController();

    final amount = await showDialog<int>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add custom amount'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Water in millilitres',
            hintText: 'e.g. 350',
            suffixText: 'ml',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(controller.text.trim());

              if (value != null && value > 0 && value <= 5000) {
                Navigator.pop(dialogContext, value);
              }
            },
            child: const Text('Add water'),
          ),
        ],
      ),
    );

    controller.dispose();

    if (amount != null && mounted) {
      addWater(amount);
    }
  }

  Future<void> editGoal() async {
    final controller = TextEditingController(text: '$goal');

    final value = await showDialog<int>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Daily water goal'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Goal in millilitres',
            suffixText: 'ml',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(controller.text.trim());

              if (value != null &&
                  value >= 250 &&
                  value <= 10000) {
                Navigator.pop(dialogContext, value);
              }
            },
            child: const Text('Save goal'),
          ),
        ],
      ),
    );

    controller.dispose();

    if (value != null && mounted) {
      setState(() => goal = value);
    }
  }

  Future<void> showResetDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset today?'),
        content: const Text(
          'This clears your current intake and drink history.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      resetDay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth >= 850;

        final pages = [
          DashboardScreen(
            intake: intake,
            goal: goal,
            remaining: remaining,
            progress: progress,
            drinks: drinks,
            onAddWater: addWater,
            onAddCustomWater: addCustomWater,
            onEditGoal: editGoal,
            onViewHistory: () {
              setState(() => selectedPage = 1);
            },
            onUndo: undoDrink,
            onReset: showResetDialog,
            reminderEnabled: reminderEnabled,
            onReminderChanged: (value) {
              setState(() => reminderEnabled = value);
            },
          ),
          HistoryScreen(
            drinks: drinks,
            intake: intake,
            goal: goal,
            onReset: resetDay,
          ),
          InsightsScreen(
            intake: intake,
            goal: goal,
            progress: progress,
            drinkCount: drinks.length,
            reminderEnabled: reminderEnabled,
            onReminderChanged: (value) {
              setState(() => reminderEnabled = value);
            },
            onEditGoal: editGoal,
          ),
        ];

        return Scaffold(
          appBar: AppBar(
            backgroundColor:
                Theme.of(context).scaffoldBackgroundColor,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: blue.withValues(alpha:0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.water_drop_rounded,
                    color: blue,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'AquaFlow',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                tooltip: 'Toggle theme',
                onPressed: () {
                  widget.onThemeChanged(!widget.darkMode);
                },
                icon: Icon(
                  widget.darkMode
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Row(
            children: [
              if (desktop)
                NavigationRail(
                  selectedIndex: selectedPage,
                  onDestinationSelected: (index) {
                    setState(() => selectedPage = index);
                  },
                  labelType: NavigationRailLabelType.all,
                  leading: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Icon(
                      Icons.spa_rounded,
                      color: blue,
                      size: 30,
                    ),
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.grid_view_rounded),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.history_rounded),
                      label: Text('History'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.insights_rounded),
                      label: Text('Insights'),
                    ),
                  ],
                ),
              if (desktop) const VerticalDivider(width: 1),
              Expanded(
                child: Column(
                  children: [
                    if (desktop)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          28, 18, 28, 0,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            pageTitle,
                            style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 1120,
                          ),
                          child: IndexedStack(
                            index: selectedPage,
                            children: pages,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: desktop
              ? null
              : NavigationBar(
                  selectedIndex: selectedPage,
                  onDestinationSelected: (index) {
                    setState(() => selectedPage = index);
                  },
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.grid_view_rounded),
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.history_rounded),
                      label: 'History',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.insights_rounded),
                      label: 'Insights',
                    ),
                  ],
                ),
        );
      },
    );
  }
}
