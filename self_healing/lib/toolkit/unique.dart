import 'dart:math';

class Unique<T> {
  T raw;
  Unique(this.raw);

  @override
  bool operator ==(Object other) {
    return false;
  }

  @override
  int get hashCode {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return random.nextInt(1000000) + timestamp;
  }
}

extension Int on Unique<int> {
}

extension UniqueInt on int {
  Unique<int> get uni => Unique(this);
}
