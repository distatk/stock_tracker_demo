import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:stock_tracker_demo/constants/urls.dart';
import 'package:stock_tracker_demo/data_models/stock.dart';
import 'package:stock_tracker_demo/pages/home_page.dart';
import 'package:stock_tracker_demo/services/stock_info_service.dart';
import 'package:stock_tracker_demo/test_utils/test_utils.dart';

import 'home_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<StockInfoService>(),
])
class MockClient extends Mock implements http.Client {
  MockClient({
    required this.mockedResult,
    this.mockedStatus = 200,
  });

  final Map<String, dynamic> mockedResult;
  final int mockedStatus;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return Future<http.StreamedResponse>.value(
      http.StreamedResponse(
        Stream.value(utf8.encode(jsonEncode(mockedResult))),
        mockedStatus,
      ),
    );
  }
}

void main() {
  late MockStockInfoService mockStockInfoService;
  late ValueNotifier<GraphQLClient> client;
  late MockClient mockHttpClient;

  setUp(() {
    mockStockInfoService = MockStockInfoService();
    mockHttpClient = MockClient(
      mockedResult: {
        'data': {
          '__typename': 'Query',
          'jittaRanking': {
            'data': List.generate(
              6,
              (index) => Stock.testStock
                  .copyWith(
                    rank: index + 1,
                    jittaScore: (index + 1) * 1.5,
                  )
                  .toJson(),
            ),
          }
        }
      },
    );

    client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: HttpLink(Urls.baseUrl, httpClient: mockHttpClient),
        cache: GraphQLCache(),
      ),
    );

    when(mockStockInfoService.getSectors())
        .thenAnswer((_) async => ['Consumer', 'Energy', 'Financials']);

    // when()
  });

  Future<void> pumpPage(WidgetTester tester) async {
    await TestUtils.pumpWidget(
      tester,
      GraphQLProvider(
        client: client,
        child: MyHomePage(title: 'Stock Tracker Demo'),
      ),
      providers: [
        Provider<StockInfoService>.value(value: mockStockInfoService),
      ],
    );
  }

  group(MyHomePage, () {
    testWidgets('should have all elements', (tester) async {
      await pumpPage(tester);

      expect(find.byKey(Key('SectorDropdown')), findsOneWidget);
      expect(find.byKey(Key('MarketDropdown')), findsOneWidget);
      expect(find.byKey(Key('DropdownSection')), findsOneWidget);
    });

    testWidgets('should initially fetch', (tester) async {
      await pumpPage(tester);

      verify(mockStockInfoService.getSectors());
    });

    testGoldens('should match golden file', (tester) async {
      await pumpPage(tester);
      await multiScreenGolden(tester, 'home_page', devices: [
        Device.iphone11,
        Device.phone.copyWith(name: "smallPhone"),
      ]);
    });
  });
}
