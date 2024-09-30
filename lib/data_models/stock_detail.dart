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
    this.priceCurrency,
    this.currencySign,
    required this.latestPrice,
    required this.latestPriceDate,
    required this.factor,
    this.signs = const [],
    this.scoreHistory = const [],
    required this.ranking,
    required this.ipoDate,
  });

  final String? summary;
  final String? priceCurrency;
  final String? currencySign;
  final double latestPrice;
  final DateTime latestPriceDate;
  final Factor factor;
  final List<Sign> signs;
  final List<ScoreHistory> scoreHistory;
  final Ranking ranking;
  final DateTime ipoDate;

  factory StockDetail.fromJson(Map<String, dynamic> json) {
    final summary = json['summary'] as String?;
    final priceCurrency = json['price_currency'] as String?;
    final currencySign = json['currency_sign'] as String?;
    final latestPrice = json['price']['latest']['close'] as num;
    final latestPriceDate =
        DateTime.parse(json['price']['latest']['datetime'] as String);
    final ipoDate = DateTime.parse(json['company']['ipo_date'] as String);
    final factor =
        Factor.fromJson(json['jitta']['factor'] as Map<String, dynamic>);
    final signs = json['jitta']['sign']['last'] as List;
    final ranking =
        Ranking.fromJson(json['comparison']['market'] as Map<String, dynamic>);
    final scoreHistory = json['jitta']['score']['values'] as List;
    return StockDetail(
        id: json['id'] as String,
        stockId: json['stockId'] as int,
        rank: json['comparison']['market']['rank'] as int,
        symbol: json['symbol'] as String,
        title: json['title'] as String,
        exchange: json['exchange'] as String,
        jittaScore: json['jitta']['score']['last']['value'] as double,
        nativeName: json['nativeName'] as String?,
        industry: json['industry'] as String?,
        sector: json['sector']?['name'] as String?,
        ipoDate: ipoDate,
        summary: summary,
        priceCurrency: priceCurrency,
        currencySign: currencySign,
        latestPrice: latestPrice.toDouble(),
        latestPriceDate: latestPriceDate,
        factor: factor,
        signs: signs.map((e) => Sign.fromJson(e)).toList(),
        scoreHistory:
            scoreHistory.map((e) => ScoreHistory.fromJson(e)).toList(),
        ranking: ranking);
  }
}
