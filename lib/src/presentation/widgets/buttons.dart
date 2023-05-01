import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klump_checkout/src/src.dart';

class KCPrimaryButton extends StatelessWidget {
  const KCPrimaryButton({
    super.key,
    required this.title,
    this.onTap,
    this.disabled = false,
    this.loading = false,
  });
  final void Function()? onTap;
  final String title;
  final bool disabled, loading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: disabled ? null : onTap,
      child: Container(
        height: 60,
        width: double.infinity,
        color: !disabled ? KCColors.primary : KCColors.primary.withOpacity(0.5),
        child: Center(
          child: loading
              ? const KCButtonLoaderWidget()
              : KCHeadline5(
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

class KCButtonLoaderWidget extends StatelessWidget {
  const KCButtonLoaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 30,
      child: Platform.isIOS
          ? const CupertinoActivityIndicator(
              radius: 15.0,
              color: KCColors.white,
            )
          : const Center(
              child: CircularProgressIndicator(
                color: KCColors.white,
                strokeWidth: 3,
              ),
            ),
    );
  }
}
