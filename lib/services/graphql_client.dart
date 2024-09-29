import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:stock_tracker_demo/constants/urls.dart';

class GraphQLClientCreator {
  static ValueNotifier<GraphQLClient> create() {
    final httpLink = HttpLink(Urls.baseUrl);
    final store = HiveStore();
    final cache = GraphQLCache(store: store);

    final client = ValueNotifier(GraphQLClient(link: httpLink, cache: cache));
    return client;
  }
}
