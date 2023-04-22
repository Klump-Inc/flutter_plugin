import 'package:klump_checkout/src/core/core.dart';

class KCFormValidator {
  static String? errorEmail(String? text, String message) {
    if (text == null) {
      return null;
    } else if (text.isEmpty) {
      return message;
    } else if (KCEmailValidator.validEmail(text) == false) {
      return 'Email must be a valid email address';
    } else {
      return '';
    }
  }

  static String? errorPassword(String? text, String message) {
    if (text == null) {
      return null;
    } else if (text.isEmpty) {
      return message;
    } else if (text.length <= 7) {
      return 'Password must have 8 or more characters';
    } else {
      return '';
    }
  }

  static String? errorOTP(String? text, String message) {
    if (text == null) {
      return null;
    } else if (text.isEmpty) {
      return message;
    } else if (text.length < 6) {
      return 'OTP must have 6 numbers';
    } else {
      return '';
    }
  }

  static String? errorPhoneNumber(String? text, String message) {
    if (text == null) {
      return null;
    } else if (text.isEmpty) {
      return message;
    } else if (KCStringUtil.removeSpaces(text).length != 11) {
      return 'Phone number must have 11 characters';
    } else {
      return '';
    }
  }

  static String? errorAccountNumber(String? text, String message) {
    if (text == null) {
      return null;
    } else if (text.isEmpty) {
      return message;
    } else if (text.length != 10) {
      return 'Incomplte account number';
    } else {
      return '';
    }
  }
}
