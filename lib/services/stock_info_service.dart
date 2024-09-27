import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:stock_tracker_demo/constants/keys.dart';
import 'package:stock_tracker_demo/constants/queries.dart';

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
}
