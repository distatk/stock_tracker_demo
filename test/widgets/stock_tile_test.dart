import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stock_tracker_demo/data_models/stock.dart';
import 'package:stock_tracker_demo/test_utils/test_utils.dart';
import 'package:stock_tracker_demo/widgets/stock_tile.dart';

void main() {
  group(StockTile, () {
    testWidgets('should have all elements', (tester) async {
      await TestUtils.pumpWidget(
        tester,
        StockTile(stock: Stock.testStock),
      );

      expect(find.byType(StockTile), findsOneWidget);
      expect(find.byKey(Key('Ranking')), findsOneWidget);
      expect(find.byKey(Key('NameAndSubtitle')), findsOneWidget);
      expect(find.byKey(Key('Body')), findsOneWidget);
    });

    testWidgets('should match golden file', (tester) async {
      TestUtils.setScreenSizePhone(tester);
      await TestUtils.pumpWidget(
        tester,
        Container(
          key: Key('TestWidget'),
          child: Column(
            children: List.generate(
              6,
              (index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: StockTile(
                  stock: Stock.testStock.copyWith(
                    rank: index + 1,
                    jittaScore: (index + 1) * 1.5,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await expectLater(
        find.byKey(Key('TestWidget')),
        matchesGoldenFile('stock_tiles.png'),
      );
    });
  });
}
