import 'package:intl/intl.dart';

String formatUsdFromCents(int cents) {
  final value = cents / 100;
  if (value == value.roundToDouble()) {
    return '\$${value.toStringAsFixed(0)}';
  }
  return '\$${value.toStringAsFixed(2)}';
}

String formatShortDate(DateTime? date) {
  if (date == null) return '--';
  return DateFormat('dd MMM, yyyy').format(date.toLocal());
}
