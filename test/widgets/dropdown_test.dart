import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stock_tracker_demo/constants/enum.dart';
import 'package:stock_tracker_demo/test_utils/test_utils.dart';
import 'package:stock_tracker_demo/widgets/dropdown.dart';

void main() {
  group(DropdownMenuWidget, () {
    testWidgets('should match golden file', (tester) async {
      TestUtils.setScreenSizePhone(tester);
      await TestUtils.pumpWidget(
        tester,
        Container(
          key: Key('TestWidget'),
          child: Center(
            child: DropdownMenuWidget(
              label: 'Market',
              valueList: Market.values.map((e) => e.dropdownMenuEntry).toList(),
            ),
          ),
        ),
      );

      await expectLater(
        find.byKey(Key('TestWidget')),
        matchesGoldenFile('dropdown.png'),
      );
    });

    testWidgets('should match golden file', (tester) async {
      TestUtils.setScreenSizePhone(tester);
      await TestUtils.pumpWidget(
        tester,
        Container(
          key: Key('TestWidget'),
          child: Center(
            child: DropdownMenuWidget(
              valueList: Market.values.map((e) => e.dropdownMenuEntry).toList(),
            ),
          ),
        ),
      );

      await expectLater(
        find.byKey(Key('TestWidget')),
        matchesGoldenFile('dropdown_no_label.png'),
      );
    });
  });
}
