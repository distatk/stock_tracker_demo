import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:stock_tracker_demo/constants/keys.dart';
import 'package:stock_tracker_demo/constants/queries.dart';

import '../data_models/pagination_model.dart';
import '../data_models/stock.dart';

class StockInfoService {
  StockInfoService({required this.client});

  GraphQLClient client;

  Future<List<String>> getSectors() async {
    final query = gql(Queries.getSectors);
    final result = await client.query(QueryOptions(document: query));
    final resultList = result.data![Keys.listJittaSectorType] as List;
    final sectorStringList = <String>[];
    for (final item in resultList) {
      sectorStringList.add(item[Keys.name]);
    }
    return sectorStringList;
  }

  Future<PaginationModel<Stock>> getStockList({
    required String market,
    required String sector,
    int? page,
    int? limit,
  }) async {
    final query = gql(Queries.getStockList);
    final variables = {
      'market': market,
      // 'sector': sector,
      'page': page,
      'limit': limit
    };
    final result =
        await client.query(QueryOptions(document: query, variables: variables));
    final resultList = result.data![Keys.jittaRanking][Keys.data] as List;
    final totalDataCount = result.data![Keys.jittaRanking][Keys.count];
    final stockList = <Stock>[];
    for (final item in resultList) {
      stockList.add(Stock.fromJson(item));
    }
    print('[getStockList] stockList: $stockList');
    return PaginationModel(
      objectList: stockList,
      totalDataCount: totalDataCount,
    );
  }
}
