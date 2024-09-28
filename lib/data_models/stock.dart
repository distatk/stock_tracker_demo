class Stock {
  const Stock({
    required this.id,
    required this.stockId,
    required this.rank,
    required this.symbol,
    required this.title,
    required this.exchange,
    required this.jittaScore,
    this.nativeName,
    required this.industry,
    required this.sector,
  })  : assert(jittaScore >= 0, 'jittaScore must be >= 0'),
        assert(jittaScore <= 10, 'jittaScore must be <= 10');

  final String id;
  final int stockId;
  final int rank;
  final String symbol;
  final String title;
  final String exchange;
  final double jittaScore;
  final String? nativeName;
  final String? industry;
  final String? sector;

  static Stock testStock = Stock(
    id: 'BKK:TEST',
    stockId: 1,
    rank: 1,
    symbol: 'test symbol',
    title: 'test title',
    exchange: 'test exchange',
    jittaScore: 1.0,
    nativeName: 'test nativeName',
    industry: 'test industry',
    sector: 'test sector',
  );

  Stock copyWith({
    String? id,
    int? stockId,
    int? rank,
    String? symbol,
    String? title,
    String? exchange,
    double? jittaScore,
    String? nativeName,
    String? industry,
    String? sector,
  }) {
    return Stock(
      id: id ?? this.id,
      stockId: stockId ?? this.stockId,
      rank: rank ?? this.rank,
      symbol: symbol ?? this.symbol,
      title: title ?? this.title,
      exchange: exchange ?? this.exchange,
      jittaScore: jittaScore ?? this.jittaScore,
      nativeName: nativeName ?? this.nativeName,
      industry: industry ?? this.industry,
      sector: sector ?? this.sector,
    );
  }

  static Stock fromJson(Map<String, dynamic> json) {
    final scoreNum = json['jittaScore'] as num;
    final jittaScore = scoreNum.toDouble();
    return Stock(
      id: json['id'] as String,
      stockId: json['stockId'] as int,
      rank: json['rank'] as int,
      symbol: json['symbol'] as String,
      title: json['title'] as String,
      exchange: json['exchange'] as String,
      jittaScore: jittaScore,
      nativeName: json['nativeName'] as String?,
      industry: json['industry'] as String?,
      sector: json['sector']?['name'] as String?,
    );
  }
}
