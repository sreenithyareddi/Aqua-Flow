
import 'package:flutter/material.dart';
import 'models/drink.dart';
import 'screens/dashboard_screen.dart';
import 'screens/history_screen.dart';

const blue = Color(0xFF2878F0);
const pageColor = Color(0xFFF4F7FC);

void main() => runApp(const AquaFlowApp());

class AquaFlowApp extends StatelessWidget {
  const AquaFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AquaFlow',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: pageColor,
        colorScheme: ColorScheme.fromSeed(seedColor: blue),
        cardColor: Colors.white,
      ),
      home: const WaterHome(),
    );
  }
}

class WaterHome extends StatefulWidget {
  const WaterHome({super.key});

  @override
  State<WaterHome> createState() => _WaterHomeState();
}

class _WaterHomeState extends State<WaterHome> {
  int intake = 0, goal = 2500, page = 0;
  final List<Drink> drinks = [];

  int get remaining => (goal - intake).clamp(0, goal).toInt();
  double get progress => (intake / goal).clamp(0.0, 1.0).toDouble();

  void addWater(int amount) {
    if (amount <= 0) return;

    setState(() {
      intake += amount;
      drinks.insert(0, Drink(
        amount: amount,
        time: DateTime.now(),
      ));
    });
  }

  Future<int?> getAmount(String title, int initial, int min, int max) async {
    final controller = TextEditingController(text: initial == 0 ? '' : '$initial');

    final value = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Amount in millilitres',
            suffixText: 'ml',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final n = int.tryParse(controller.text.trim());
              if (n != null && n >= min && n <= max) {
                Navigator.pop(ctx, n);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    controller.dispose();
    return value;
  }

  Future<void> addCustomWater() async {
    final amount = await getAmount('Add water', 0, 1, 5000);
    if (amount != null && mounted) addWater(amount);
  }

  Future<void> editGoal() async {
    final value = await getAmount('Edit daily goal', goal, 250, 10000);
    if (value != null && mounted) setState(() => goal = value);
  }

  void resetDay() {
    setState(() {
      intake = 0;
      drinks.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.of(context).size.width >= 850;

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
        onViewHistory: () => setState(() => page = 1),
      ),
      HistoryScreen(
        drinks: drinks,
        intake: intake,
        goal: goal,
        onReset: resetDay,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Row(children: [
          Icon(Icons.water_drop_rounded, color: blue),
          SizedBox(width: 10),
          Text('AquaFlow',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ]),
      ),
      body: Row(children: [
        if (desktop)
          NavigationRail(
            selectedIndex: page,
            onDestinationSelected: (v) => setState(() => page = v),
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home_rounded),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.history_rounded),
                label: Text('History'),
              ),
            ],
          ),
        if (desktop) const VerticalDivider(width: 1),
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: IndexedStack(index: page, children: pages),
            ),
          ),
        ),
      ]),
      bottomNavigationBar: desktop
          ? null
          : NavigationBar(
              selectedIndex: page,
              onDestinationSelected: (v) => setState(() => page = v),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.history_rounded),
                  label: 'History',
                ),
              ],
            ),
    );
  }
}
