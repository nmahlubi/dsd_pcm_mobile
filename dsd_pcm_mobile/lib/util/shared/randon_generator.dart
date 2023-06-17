import 'dart:math';

class RandomGenerator {
  int getRandomGeneratedNumber() {
    return Random().nextInt(999999999);
  }

  String getCurrentDateGenerated() {
    return DateTime.now().toString().substring(0, 10);
  }
}
