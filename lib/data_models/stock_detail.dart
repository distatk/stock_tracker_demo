import 'package:stock_tracker_demo/data_models/factor.dart';
import 'package:stock_tracker_demo/data_models/ranking.dart';
import 'package:stock_tracker_demo/data_models/score_history.dart';
import 'package:stock_tracker_demo/data_models/sign.dart';
import 'package:stock_tracker_demo/data_models/stock.dart';

class StockDetail extends Stock {
  const StockDetail({
    required super.id,
    required super.stockId,
    required super.rank,
    required super.symbol,
    required super.title,
    required super.exchange,
    required super.jittaScore,
    super.nativeName,
    super.industry,
    super.sector,
    this.summary,
    required this.priceCurrency,
    required this.currencySign,
    required this.latestPrice,
    required this.latestPriceDate,
    required this.factor,
    this.signs = const [],
    this.scoreHistory = const [],
    required this.ranking,
    required this.ipoDate,
  });

  final String? summary;
  final String priceCurrency;
  final String currencySign;
  final double latestPrice;
  final DateTime latestPriceDate;
  final Factor factor;
  final List<Sign> signs;
  final List<ScoreHistory> scoreHistory;
  final Ranking ranking;
  final DateTime ipoDate;

  factory StockDetail.fromJson(Map<String, dynamic> json) {
    final summary = json['summary'] as String?;
    final priceCurrency = json['priceCurrency'] as String;
    final currencySign = json['currencySign'] as String;
    final latestPrice = json['latestPrice'] as double;
    final latestPriceDate = DateTime.parse(json['latestPriceDate'] as String);
    final ipoDate = DateTime.parse(json['ipo_date'] as String);
    final factor = Factor.fromJson(json['factor'] as Map<String, dynamic>);
    final signs = json['signs'] as List;
    final ranking = Ranking.fromJson(json['ranking'] as Map<String, dynamic>);
    final scoreHistory = json['scoreHistory'] as List;
    return StockDetail(
        id: json['id'] as String,
        stockId: json['stockId'] as int,
        rank: json['rank'] as int,
        symbol: json['symbol'] as String,
        title: json['title'] as String,
        exchange: json['exchange'] as String,
        jittaScore: json['jittaScore'] as double,
        nativeName: json['nativeName'] as String?,
        industry: json['industry'] as String?,
        sector: json['sector']?['name'] as String?,
        ipoDate: ipoDate,
        summary: summary,
        priceCurrency: priceCurrency,
        currencySign: currencySign,
        latestPrice: latestPrice,
        latestPriceDate: latestPriceDate,
        factor: factor,
        signs: signs.map((e) => Sign.fromJson(e)).toList(),
        scoreHistory:
            scoreHistory.map((e) => ScoreHistory.fromJson(e)).toList(),
        ranking: ranking);
  }
}
