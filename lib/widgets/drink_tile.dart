
import 'package:flutter/material.dart';
import '../models/drink.dart';

const Color drinkBlue = Color(0xFF2878F0);

class DrinkTile extends StatelessWidget {
  final Drink drink;

  const DrinkTile({
    super.key,
    required this.drink,
  });

  @override
  Widget build(BuildContext context) {
    final time =
        '${drink.time.hour.toString().padLeft(2, '0')}:'
        '${drink.time.minute.toString().padLeft(2, '0')}';

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: const Color(0xFFE5F2FF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.water_drop_rounded,
            color: drinkBlue,
          ),
        ),
        title: Text(
          '${drink.amount} ml of water',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(time),
        trailing: const Icon(
          Icons.check_circle_rounded,
          color: drinkBlue,
        ),
      ),
    );
  }
}
