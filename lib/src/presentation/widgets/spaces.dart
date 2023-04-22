import 'package:flutter/material.dart';

class XSpace extends StatelessWidget {
  const XSpace(
    this.width, {
    super.key,
  });
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}

class YSpace extends StatelessWidget {
  const YSpace(
    this.height, {
    super.key,
  });
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}
