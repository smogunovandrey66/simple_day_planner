import 'package:intl/intl.dart';

extension DatetimeExt on DateTime {
  String formatTask() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  String toTimeTask() {
    return DateFormat('HH:mm').format(this);
  }
}

extension StringExt on String {
  DateTime toDateTimeTask() {
    return DateFormat('yyyy-MM-dd').parse(this);
  }
}
