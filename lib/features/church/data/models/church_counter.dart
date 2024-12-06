class ChurchCounter {
  final int value;

  const ChurchCounter._(this.value);

  factory ChurchCounter.fromDynamic(dynamic value) {
    if (value == null) return const ChurchCounter._(0);
    if (value is int) return ChurchCounter._(value);
    if (value is String) {
      final parsed = int.tryParse(value);
      return ChurchCounter._(parsed ?? 0);
    }
    if (value is double) return ChurchCounter._(value.toInt());
    return const ChurchCounter._(0);
  }

  ChurchCounter increment() => ChurchCounter._(value + 1);
  ChurchCounter decrement() => ChurchCounter._(value > 0 ? value - 1 : 0);

  @override
  String toString() => value.toString();
}
