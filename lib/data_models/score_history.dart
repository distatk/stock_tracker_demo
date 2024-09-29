class ScoreHistory {
  const ScoreHistory({
    required this.value,
    required this.id,
    required this.quarter,
    required this.year,
  });

  final double value;
  final String id;
  final int quarter;
  final int year;

  factory ScoreHistory.fromJson(Map<String, dynamic> json) {
    return ScoreHistory(
      value: json['value'] as double,
      id: json['id'] as String,
      quarter: json['quarter'] as int,
      year: json['year'] as int,
    );
  }
}
