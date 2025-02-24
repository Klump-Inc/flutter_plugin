import 'package:flutter/material.dart';

void selectDateAndroid(
  BuildContext context, {
  required void Function(DateTime?) onDateSelected,
  required DateTime? initialDate,
}) async {
  final DateTime? selectedDate = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: DateTime(1800),
    lastDate: DateTime(2099),
  );
  onDateSelected(selectedDate ?? DateTime.now());
}
