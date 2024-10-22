import 'package:flutter/material.dart';
import 'package:klump_checkout/klump_checkout.dart';

class KCFormValidator {
  static Color getBorderColor(String? message) {
    if (message == null) {
      return KCColors.grey1;
    } else if (message.isEmpty) {
      return Colors.green.withOpacity(0.50);
    } else {
      return Colors.red.withOpacity(0.50);
    }
  }

  static String? errorGeneric(String? text, String message) {
    if (text == null) {
      return null;
    } else if (text.isEmpty) {
      return message;
    } else {
      return '';
    }
  }

  static String? errorDate(DateTime? dob, String message, bool showError) {
    if (dob == null && !showError) {
      return null;
    } else if (dob == null && showError) {
      return message;
    }
    // else if (DateTime.now().difference(dob!).inDays < (365 * 18)) {
    //   return 'You are not eligible for a loan at this time';
    // }
    else {
      return '';
    }
  }

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
    final hasUpperCase = RegExp('(?:[A-Z])');
    final hasLowerCase = RegExp('(?:[a-z])');
    final hasSymbols = RegExp(r"[!@#$%^&*(),\|+=;.?':{}|<>]");
    final hasANumber = RegExp('(?=.*?[0-9])');
    if (text == null) {
      return null;
    } else if (text.isEmpty) {
      return message;
    } else if (text.length <= 7) {
      return 'Password must have 8 or more characters';
    } else if (!hasANumber.hasMatch(text)) {
      return 'Password must have at least a number';
    } else if (!hasLowerCase.hasMatch(text)) {
      return 'Password must have at a lower character';
    } else if (!hasSymbols.hasMatch(text)) {
      return 'Password must have at a special character';
    } else if (!hasUpperCase.hasMatch(text)) {
      return 'Password must have at a upper character';
    } else {
      return '';
    }
  }

  static String? errorPassword2(String? text, String message) {
    if (text == null) {
      return null;
    } else if (text.isEmpty) {
      return message;
    } else if (text.length <= 4) {
      return 'Password must have 5 or more characters';
    } else {
      return '';
    }
  }

  static String? errorOTP(String? text, String message, [int length = 6]) {
    if (text == null) {
      return null;
    } else if (text.isEmpty) {
      return message;
    } else if (text.length != length) {
      return 'OTP must have $length numbers';
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

  static String? errorNIN(String? text, String message) {
    if (text == null) {
      return null;
    } else if (text.isEmpty) {
      return message;
    } else if (text.length != 11) {
      return 'Invalid NIN';
    } else {
      return '';
    }
  }

  static String? errorAmount(String? text, String message) {
    if (text == null) {
      return null;
    } else if (text.isEmpty) {
      return message;
    } else if (KCStringUtil.convertTextFigure(text) <= 0) {
      return 'Invalid figure';
    } else {
      return '';
    }
  }

  static String? errorMessageIdNumber(
      String? text, String message, String type) {
    final intPasswordRegex =
        RegExp(r'^(?=.*[0-9])(?=.*[A-Za-z])([A-Za-z][A-Za-z0-9]{8,11})$');
    final driverLicenseRegex =
        RegExp(r'^(?=.*[0-9])(?=.*[A-Za-z])([A-Za-z][A-Za-z0-9]{5,11})$');
    final nationalIDRegex = RegExp(r'^[0-9]{11}$');
    final votersCardRegex =
        RegExp(r'^(?=.*[0-9])(?=.*[A-Za-z])([A-Za-z0-9]{9,19})$');
    if (text == null) {
      return null;
    } else if (text.isEmpty) {
      return message;
    } else {
      var error = false;
      switch (type) {
        case INTERNATIONAL_PASSPORT:
          error = !intPasswordRegex.hasMatch(text);
          break;
        case DRIVER_LICENSE:
          error = !driverLicenseRegex.hasMatch(text);
          break;
        case NATIONAL_ID_CARD:
          error = !nationalIDRegex.hasMatch(text);
          break;
        case VOTERS_CARD:
          error = !votersCardRegex.hasMatch(text);
          break;
        default:
      }
      return error ? 'Invalid ID Number' : '';
    }
  }
}
