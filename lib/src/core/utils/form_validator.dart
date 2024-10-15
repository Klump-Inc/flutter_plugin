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

  static String? errorDOB(DateTime? dob, String message, bool showError) {
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
}
