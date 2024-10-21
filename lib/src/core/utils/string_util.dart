import 'package:intl/intl.dart';

class KCStringUtil {
  static String formatAmount(double value) {
    final f = NumberFormat('#,##0.00', 'en_US');
    return f.format(value);
  }

  static String removeSpaces(String text) {
    return text.replaceAll(RegExp(' +'), '');
  }

  static String formatDate(DateTime dateTime) {
    final formatter = DateFormat('MMM d, yyyy');
    return formatter.format(dateTime);
  }

  static String formatServerDate(DateTime dateTime) {
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  static double convertTextFigure(String amount) {
    if (amount.contains('₦') || amount.contains(',')) {
      return double.tryParse(amount.replaceAll('₦', '').replaceAll(',', '')) ??
          0;
    } else {
      return double.tryParse(amount) ?? 0;
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
