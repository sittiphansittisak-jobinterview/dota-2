import 'package:intl/intl.dart';

class StringFormatter {
  static String? numberWithCommas(number, {int decimalPlaces = 2}) {
    if (number is! num) return null;
    final parts = number.toStringAsFixed(decimalPlaces).split('.');
    final formatter = NumberFormat.decimalPattern();
    final wholePart = formatter.format(int.parse(parts[0]));
    final formattedNumber = '$wholePart${decimalPlaces > 0 ? '.' : ''}${parts.length > 1 ? parts[1] : ''}';
    return formattedNumber;
  }
}
