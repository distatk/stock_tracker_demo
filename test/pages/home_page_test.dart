import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:stock_tracker_demo/pages/home_page.dart';
import 'package:stock_tracker_demo/services/stock_info_service.dart';
import 'package:stock_tracker_demo/test_utils/test_utils.dart';

import 'home_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<StockInfoService>(),
])
void main() {
  late MockStockInfoService mockStockInfoService;

  setUp(() {
    mockStockInfoService = MockStockInfoService();

    when(mockStockInfoService.getSectors())
        .thenAnswer((_) async => ['Consumer', 'Energy', 'Financials']);
  });

  Future<void> pumpPage(WidgetTester tester) async {
    await TestUtils.pumpWidget(
      tester,
      MyHomePage(title: 'Stock Tracker Demo'),
      providers: [
        Provider<StockInfoService>.value(value: mockStockInfoService)
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

    testGoldens('should match golden file', (tester) async {
      await pumpPage(tester);
      await multiScreenGolden(tester, 'home_page', devices: [
        Device.iphone11,
        Device.phone.copyWith(name: "smallPhone"),
      ]);
    });
  });
}
