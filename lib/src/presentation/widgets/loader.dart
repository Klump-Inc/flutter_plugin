import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klump_checkout/klump_checkout.dart';

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
