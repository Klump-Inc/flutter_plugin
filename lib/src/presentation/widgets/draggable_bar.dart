import 'package:flutter/material.dart';
import 'package:klump_checkout/src/core/core.dart';

class DraggableBar extends StatelessWidget {
  const DraggableBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 4.96,
        width: 35.73,
        margin: const EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          color: KCColors.black2.withOpacity(0.24),
          borderRadius: BorderRadius.circular(9.92367),
        ),
      ),
    );
  }
}
