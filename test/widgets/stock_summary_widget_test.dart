import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stock_tracker_demo/test_utils/test_utils.dart';
import 'package:stock_tracker_demo/widgets/stock_summary_widget.dart';

void main() {
  const testText =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed '
      'do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
      'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris '
      'nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in '
      'reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla '
      'pariatur. Excepteur sint occaecat cupidatat non proident, sunt in '
      'culpa qui officia deserunt mollit anim id est laborum.';
  group(StockSummaryWidget, () {
    testWidgets('should have all elements', (tester) async {
      await TestUtils.pumpWidget(
        tester,
        StockSummaryWidget(
          summaryText: testText,
        ),
      );

      expect(find.byType(StockSummaryWidget), findsOneWidget);
      expect(find.byKey(Key('Title')), findsOneWidget);
      expect(find.byKey(Key('AnimationSection')), findsOneWidget);
      expect(find.byKey(Key('SummaryText')), findsOneWidget);
      expect(find.byKey(Key('Gradient')), findsOneWidget);
      expect(find.byKey(Key('ButtonRow')), findsOneWidget);
    });

    testWidgets('should match golden file', (tester) async {
      TestUtils.setScreenSizePhone(tester);
      await TestUtils.pumpWidget(
        tester,
        Container(
          key: Key('TestWidget'),
          color: Colors.white,
          child: Column(
            children: [
              StockSummaryWidget(summaryText: testText),
              Divider(),
              StockSummaryWidget(summaryText: testText),
            ],
          ),
        ),
      );

      await tester.tap(find.byKey(Key('ButtonRow')).last);
      await tester.pumpAndSettle();

      await expectLater(
        find.byKey(Key('TestWidget')),
        matchesGoldenFile('stock_summary_widget.png'),
      );
    });
  });
}
