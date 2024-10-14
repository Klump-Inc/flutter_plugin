import 'package:flutter/material.dart';
import 'package:klump_checkout/klump_checkout.dart';

class KCCheckBox extends StatelessWidget {
  const KCCheckBox(
      {super.key,
      required this.value,
      this.onChanged,
      required this.textWidget});
  final bool value;
  final void Function(bool?)? onChanged;
  final Widget textWidget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          materialTapTargetSize: MaterialTapTargetSize.padded,
          onChanged: onChanged,
          activeColor: KCColors.primary,
          side: const BorderSide(color: KCColors.primary, width: 2),
        ),
        Expanded(child: textWidget),
      ],
    );
  }
}
