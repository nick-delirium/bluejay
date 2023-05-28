import 'package:intl/intl.dart';

String fullDateFromMs(int entryTs) {
  DateTime timestamp =
      DateTime.fromMillisecondsSinceEpoch(entryTs * 1000, isUtc: true);
  return DateFormat('dd MMM, HH:mm').format(timestamp.toLocal());
}
