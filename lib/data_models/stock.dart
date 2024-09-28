class Stock {
  const Stock({
    required this.id,
    required this.stockId,
    required this.rank,
    required this.symbol,
    required this.title,
    required this.exchange,
    required this.jittaScore,
    required this.nativeName,
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
  final String nativeName;
  final String industry;
  final String sector;

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
}
