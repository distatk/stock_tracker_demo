import 'package:graphql_flutter/graphql_flutter.dart';

class TestUtils {
  static QueryResult createMockQueryResponse({
    required String queryCharacterNames,
    required Map<String, dynamic>? data,
    bool isLoading = false,
    String? errorMessage,
  }) {
    final options = QueryOptions(
      document: gql(queryCharacterNames),
    );
    return QueryResult(
      options: options,
      source: isLoading ? QueryResultSource.loading : QueryResultSource.network,
      data: data,
      exception: errorMessage != null
          ? OperationException(
              graphqlErrors: [
                GraphQLError(message: errorMessage),
              ],
            )
          : null,
    );
  }
}
