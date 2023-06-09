import 'package:flutter_test/flutter_test.dart';
import 'package:bluejay/utils/time.dart';

void main() {
  group('Full Date Formatting', () {
    test('Ensure correct date formatting', () {
      // Test case 1: Test with a specific timestamp
      int timestamp = 1627584000; // July 29, 2021 18:40:00 utc
      String expectedDate = '29 Jul, 18:40';
      expect(fullDateFromMs(timestamp, true), expectedDate);

      // Test case 2: Test with a different timestamp
      timestamp = 1660867200; // Aug 19, 2022 00:00:00 utc
      expectedDate = '19 Aug, 00:00';
      expect(fullDateFromMs(timestamp, true), expectedDate);

      // Test case 3: Test with a timestamp at a different time of the day
      timestamp = 1672358400; // Dec 30, 2022 00:00:00 utc
      expectedDate = '30 Dec, 00:00';
      expect(fullDateFromMs(timestamp, true), expectedDate);
    });
  });
}
