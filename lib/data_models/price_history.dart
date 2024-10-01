class PriceHistory {
  const PriceHistory({
    required this.id,
    required this.value,
    required this.year,
    required this.month,
  });

  final String id;
  final double value;
  final int year;
  final int month;

  DateTime get datetime => DateTime(year, month);

  factory PriceHistory.fromJson(Map<String, dynamic> json) {
    final price = json['value'] as num;
    return PriceHistory(
      id: json['id'] as String,
      value: price.toDouble(),
      year: json['year'] as int,
      month: json['month'] as int,
    );
  }
}
