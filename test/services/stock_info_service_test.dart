import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:stock_tracker_demo/constants/queries.dart';
import 'package:stock_tracker_demo/services/stock_info_service.dart';
import 'package:stock_tracker_demo/test_utils/test_utils.dart';

import 'stock_info_service_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GraphQLClient>(),
])
void main() {
  late MockGraphQLClient mockClient;
  late StockInfoService stockInfoService;

  setUp(() {
    mockClient = MockGraphQLClient();
    stockInfoService = StockInfoService(client: mockClient);
  });

  group('getSectors', () {
    test('should return list of sectors', () async {
      final testData = {
        '__typename': 'Query',
        'listJittaSectorType': [
          {'__typename': 'Sector', 'name': 'Consumer'},
          {'__typename': 'Sector', 'name': 'Energy'},
          {'__typename': 'Sector', 'name': 'Financials'},
        ],
      };
      final testQueryResult = TestUtils.createMockQueryResponse(
          queryCharacterNames: Queries.getSectors, data: testData);
      when(mockClient.query(any)).thenAnswer((_) async => testQueryResult);
      final result = await stockInfoService.getSectors();

      final expectedResult = ['Consumer', 'Energy', 'Financials'];
      for (final item in expectedResult) {
        expect(result.contains(item), true);
      }
      expect(result.length, 3);
    });
  });
}
