import 'package:flutter/material.dart';
import 'package:klump_checkout/src/src.dart';

class KCPrimaryButton extends StatelessWidget {
  const KCPrimaryButton({
    super.key,
    required this.title,
    this.onTap,
    this.disabled = false,
  });
  final void Function()? onTap;
  final String title;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: disabled ? null : onTap,
      child: Container(
        height: 60,
        width: double.infinity,
        color: !disabled ? KCColors.primary : KCColors.primary.withOpacity(0.5),
        child: Center(
          child: KCHeadline5(
            title,
            color: KCColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class KCSecondaryButton extends StatelessWidget {
  const KCSecondaryButton({
    super.key,
    required this.title,
    this.onTap,
    this.disabled = false,
  });
  final void Function()? onTap;
  final String title;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: disabled ? null : onTap,
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: KCColors.white,
          border: Border.all(color: KCColors.primary),
        ),
        child: Center(
          child: KCHeadline5(
            title,
            color: !disabled
                ? KCColors.primary
                : KCColors.primary.withOpacity(0.5),
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
