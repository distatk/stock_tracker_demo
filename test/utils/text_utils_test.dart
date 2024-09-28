import 'package:flutter_test/flutter_test.dart';
import 'package:stock_tracker_demo/utils/text_utils.dart';

void main() {
  group('sectorNameToId', () {
    test('should success', () {
      final testStringAndResultList = [
        ('Healthcare', 'HEALTHCARE'),
        ('Energy', 'ENERGY'),
        ('Financials', 'FINANCIALS'),
        ('Consumer staples', 'CONSUMER_STAPLES'),
        ('', ''),
        ('    ', '____'),
        ('____', '____'),
      ];

      for (final item in testStringAndResultList) {
        final result = TextUtils.sectorNameToId(item.$1);
        expect(result, item.$2);
      }
    });
  });
}
