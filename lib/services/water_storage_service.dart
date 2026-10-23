
import '../models/drink.dart';

class WaterStorageService {
  final List<Drink> _drinks = [];

  List<Drink> get drinks => List.unmodifiable(_drinks);

  void addDrink(Drink drink) {
    _drinks.insert(0, drink);
  }

  void removeDrink(Drink drink) {
    _drinks.remove(drink);
  }

  void clearDrinks() {
    _drinks.clear();
  }
}
