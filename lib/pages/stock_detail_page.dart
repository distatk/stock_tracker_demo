import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:stock_tracker_demo/data_models/stock_detail.dart';

import '../constants/queries.dart';

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
    return Text(summary);
  }

  Widget _buildStockInfo(
    BuildContext context,
    Map<String, dynamic> stockDetailJson,
  ) {
    log('stockDetailJson: $stockDetailJson');
    // final stockDetailFuture = compute<Map<String, dynamic>, StockDetail>(
    //   StockDetail.fromJson,
    //   stockDetailJson,
    // );
    return FutureBuilder(
      future: Future.value(StockDetail.fromJson(stockDetailJson)),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final stockDetail = snapshot.data!;
          return Column(
            children: [
              if (stockDetail.summary != null)
                _buildSummary(context, stockDetail.summary!),
            ],
          );
        }
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
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
          return Text(result.exception.toString());
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
      body: _buildQueryWidget(context),
    );
  }
}
