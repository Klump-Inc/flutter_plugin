import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:klump_checkout/src/core/core.dart';

class LogoHeaderWidget extends StatelessWidget {
  const LogoHeaderWidget({
    super.key,
    this.logo,
    this.onTap,
  });

  final Widget? logo;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: onTap ?? () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: SvgPicture.asset(
              KCAssets.arrowBack,
              package: 'klump_checkout',
            ),
          ),
        ),
        if (logo != null) logo!,
        const SizedBox(width: 50)
      ],
    );
  }
}
