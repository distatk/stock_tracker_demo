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

  factory PriceHistory.fromJson(Map<String, dynamic> json) {
    return PriceHistory(
      id: json['id'] as String,
      value: json['value'] as double,
      year: json['year'] as int,
      month: json['month'] as int,
    );
  }
}
