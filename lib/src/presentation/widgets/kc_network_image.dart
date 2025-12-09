import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/src/core/core.dart';

class KCNetworkImage extends StatelessWidget {
  const KCNetworkImage(
      {super.key, this.url, this.height = 55, this.width = 55, this.fit});
  final String? url;
  final double? height;
  final double? width;
  final BoxFit? fit;
  @override
  Widget build(BuildContext context) {
    return Image.network(
      url ?? '',
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return SvgPicture.asset(
          KCAssets.klumpLogo,
          package: 'klump_checkout',
        );
      },
    );
  }
}
