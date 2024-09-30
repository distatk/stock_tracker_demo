import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:stock_tracker_demo/data_models/stock_detail.dart';
import 'package:stock_tracker_demo/widgets/stock_summary_widget.dart';

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

  Widget _buildStockInfo(
    BuildContext context,
    Map<String, dynamic> stockDetailJson,
  ) {
    // Uses isolate prevent ui jank
    final stockDetailFuture = compute<Map<String, dynamic>, StockDetail>(
      StockDetail.fromJson,
      stockDetailJson,
    );
    return FutureBuilder<StockDetail>(
      future: stockDetailFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final stockDetail = snapshot.data!;
          return Column(
            children: [
              if (stockDetail.summary != null)
                _buildSummary(context, stockDetail.summary!),
              Divider(),
            ],
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
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildStockInfo(context, result.data!['stock']),
        );
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
