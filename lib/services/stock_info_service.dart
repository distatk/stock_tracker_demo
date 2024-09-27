import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class StockInfoService {
  StockInfoService({required this.client});

  ValueNotifier<GraphQLClient> client;
}
