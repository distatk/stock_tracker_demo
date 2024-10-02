import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:stock_tracker_demo/constants/urls.dart';
import 'package:stock_tracker_demo/pages/stock_detail_page.dart';
import 'package:stock_tracker_demo/test_utils/mock_http_client.dart';
import 'package:stock_tracker_demo/test_utils/test_utils.dart';
import 'package:stock_tracker_demo/widgets/chart_widget.dart';
import 'package:stock_tracker_demo/widgets/ranking_widget.dart';
import 'package:stock_tracker_demo/widgets/stock_summary_widget.dart';

import '../test_data.dart';

void main() {
  late ValueNotifier<GraphQLClient> client;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient(mockedResult: testStockDetailResponseData);

    client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: HttpLink(Urls.baseUrl, httpClient: mockHttpClient),
        cache: GraphQLCache(),
      ),
    );
  });

  Future<void> pumpPage(WidgetTester tester) async {
    await TestUtils.pumpWidget(
      tester,
      GraphQLProvider(
        client: client,
        child: StockDetailPage(
          id: 'id',
          stockId: 123,
          stockName: 'StockName',
        ),
      ),
    );
  }

  group(StockDetailPage, () {
    testWidgets('should have all elements', (tester) async {
      await pumpPage(tester);

      expect(find.byKey(Key('SymbolAndRanking')), findsOneWidget);
      expect(find.byType(ChartWidget), findsOneWidget);
      expect(find.byType(RankingWidget), findsOneWidget);
      expect(find.byType(StockSummaryWidget), findsOneWidget);
    });

    testGoldens('should match golden file', (tester) async {
      await pumpPage(tester);
      await multiScreenGolden(tester, 'stock_detail_page', devices: [
        Device.iphone11,
        Device.phone.copyWith(name: "smallPhone"),
        Device.phone.copyWith(
          name: "long",
          size: Size(414, 1500),
        ),
      ]);
    });
  });
}
