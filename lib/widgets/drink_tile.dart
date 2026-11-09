
import 'package:flutter/material.dart';
import '../models/drink.dart';

class DrinkTile extends StatelessWidget {
  final Drink drink;

  const DrinkTile({super.key, required this.drink});

  @override
  Widget build(BuildContext context) {
    final time = TimeOfDay.fromDateTime(drink.time);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFE8F0FF),
          child: Icon(Icons.water_drop, color: Color(0xFF2878F0)),
        ),
        title: Text('${drink.amount} ml',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(time.format(context)),
        trailing: const Icon(Icons.check_circle, color: Colors.green),
      ),
    );
  }
}
