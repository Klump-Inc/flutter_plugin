import 'package:flutter/material.dart';
import 'package:klump_checkout/klump_checkout.dart';

class KCTextArea extends StatelessWidget {
  const KCTextArea({
    super.key,
    required this.controller,
    this.validationMessage,
  });
  final TextEditingController? controller;
  final String? validationMessage;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: 6,
      maxLines: 8,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        fontFamily: KCFonts.avenir,
        color: KCColors.black3,
      ),
      decoration: InputDecoration(
        hintText: 'Enter feedback here',
        hintStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          fontFamily: KCFonts.avenir,
          color: KCColors.grey2,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: KCFormValidator.getBorderColor(
                validationMessage, KCColors.primary),
            width: 0.88,
          ),
          borderRadius: BorderRadius.circular(4.42),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: KCFormValidator.getBorderColor(
                validationMessage, KCColors.primary),
            width: 0.88,
          ),
          borderRadius: BorderRadius.circular(4.42),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: KCFormValidator.getBorderColor(
                validationMessage, KCColors.primary),
            width: 0.88,
          ),
          borderRadius: BorderRadius.circular(4.42),
        ),
      ),
    );
  }
}
