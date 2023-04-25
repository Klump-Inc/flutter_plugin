import 'package:flutter/material.dart';

double screenWidth(BuildContext context, {double fraction = 1.0}) =>
    MediaQuery.of(context).size.width * fraction;
double screenHeight(BuildContext context, {double fraction = 1.0}) =>
    MediaQuery.of(context).size.height * fraction;
bool checkKeyboardOpened(BuildContext context) =>
    MediaQuery.of(context).viewInsets.bottom > 250;
double getViewInsetsHeight(BuildContext context) =>
    MediaQuery.of(context).viewInsets.bottom;
