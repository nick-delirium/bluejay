import 'package:intl/intl.dart';

String fullDateFromMs(int entryTs, bool isUtc) {
  DateTime timestamp =
      DateTime.fromMillisecondsSinceEpoch(entryTs * 1000, isUtc: isUtc);
  return DateFormat('dd MMM, HH:mm')
      .format(isUtc ? timestamp : timestamp.toLocal());
}
