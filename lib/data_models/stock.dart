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
  });

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
}
