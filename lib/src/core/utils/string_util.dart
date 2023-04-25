import 'package:intl/intl.dart';

class KCStringUtil {
  static String formatAmount(double value) {
    final f = NumberFormat('#,##0.00', 'en_US');
    return f.format(value);
  }

  static String removeSpaces(String text) {
    return text.replaceAll(RegExp(' +'), '');
  }
}
