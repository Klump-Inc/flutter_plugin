import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klump_checkout/src/core/styles/styles.dart';

class KCPageLoaderWidget extends StatelessWidget {
  const KCPageLoaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: Platform.isIOS
          ? const CupertinoActivityIndicator(
              radius: 20.0,
              color: KCColors.primary,
            )
          : const Center(
              child: CircularProgressIndicator(
                color: KCColors.primary,
                strokeWidth: 3,
              ),
            ),
    );
  }
}
