import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:stock_tracker_demo/constants/enum.dart';
import 'package:stock_tracker_demo/data_models/stock_detail.dart';
import 'package:stock_tracker_demo/widgets/ranking_widget.dart';
import 'package:stock_tracker_demo/widgets/stock_summary_widget.dart';

import '../constants/queries.dart';
import '../data_models/factor.dart';
import '../data_models/ranking.dart';
import '../data_models/sign.dart';
import '../widgets/chart_widget.dart';
import '../widgets/factor_score_widget.dart';

class StockDetailPage extends StatelessWidget {
  const StockDetailPage({
    required this.id,
    required this.stockId,
    required this.stockName,
    super.key,
  });

  final int stockId;
  final String id;
  final String stockName;

  Widget _buildSummary(BuildContext context, String summary) {
    return StockSummaryWidget(
      summaryText: summary,
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
          ),
          Text('Something went wrong!'),
        ],
      ),
    );
  }

  Widget _buildSymbolAndRanking(
    BuildContext context,
    String symbol,
    Ranking ranking,
  ) {
    return Row(
      key: Key('SymbolAndRanking'),
      children: [
        Expanded(
          child: Text(
            symbol,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        RankingWidget(ranking: ranking),
      ],
    );
  }

  Widget _buildSign(BuildContext context, Sign sign) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            sign.type == SignType.good
                ? Icons.thumb_up_rounded
                : Icons.thumb_down_rounded,
            color: sign.type.color,
          ),
          Gap(8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(sign.title, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(sign.value),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSignsSection(
    BuildContext context,
    List<Sign> signs,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Signs',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Gap(8),
        ...signs.map((sign) => _buildSign(context, sign)),
      ],
    );
  }

  Widget _buildFactorSection(BuildContext context, Factor factor) {
    final factorValueList = factor.values;
    if (factorValueList.isEmpty) {
      return SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Factors',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Gap(8),
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.8,
          ),
          itemCount: factorValueList.length,
          itemBuilder: (context, index) => Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  '${factorValueList[index].name}\n\n',
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),
                Spacer(),
                FactorScoreWidget(
                  value: factorValueList[index].value,
                ),
                Gap(8)
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<StockDetail> _getStockDetailFromJsonFuture(
    Map<String, dynamic> stockDetailJson,
  ) {
    // isolate computation not supported in test
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return Future.value(StockDetail.fromJson(stockDetailJson));
    } else {
      // Uses isolate prevent ui jank
      return compute<Map<String, dynamic>, StockDetail>(
        StockDetail.fromJson,
        stockDetailJson,
      );
    }
  }

  Widget _buildStockInfo(
    BuildContext context,
    Map<String, dynamic> stockDetailJson,
  ) {
    return FutureBuilder<StockDetail>(
      future: _getStockDetailFromJsonFuture(stockDetailJson),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final stockDetail = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildSymbolAndRanking(
                    context,
                    stockDetail.symbol,
                    stockDetail.ranking,
                  ),
                  Divider(),
                  Gap(8),
                  ChartWidget(
                    currentPrice: stockDetail.latestPrice,
                    priceHistory: stockDetail.priceHistory,
                    currency: stockDetail.currencySign ??
                        stockDetail.priceCurrency ??
                        '',
                  ),
                  if (stockDetail.summary != null)
                    _buildSummary(context, stockDetail.summary!),
                  Divider(),
                  _buildSignsSection(context, stockDetail.signs),
                  Divider(),
                  _buildFactorSection(context, stockDetail.factor),
                ],
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return _buildErrorWidget();
        }
        return Center(child: const CircularProgressIndicator());
      },
    );
  }

  Widget _buildQueryWidget(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(Queries.getStockDetail),
        variables: {'id': id, 'stockId': stockId},
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading && result.data == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (result.hasException) {
          return _buildErrorWidget();
        }
        return _buildStockInfo(context, result.data!['stock']);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(stockName),
      ),
      backgroundColor: Colors.white,
      body: _buildQueryWidget(context),
    );
  }
}
