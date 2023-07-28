import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:klump_checkout/src/src.dart';

class KCTextBase extends StatelessWidget {
  const KCTextBase(
    this.text, {
    this.style,
    this.textAlign = TextAlign.left,
    this.overflow = TextOverflow.visible,
    this.maxLines,
    super.key,
  });
  final String? text;
  final TextStyle? style;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    assert(text != null, 'test can not be null');
    return Text(
      text ?? '',
      style: const TextStyle(
        fontFamily: KCFonts.avenir,
      ).merge(style),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}

class KCBodyText1 extends KCTextBase {
  KCBodyText1(
    String super.text, {
    super.key,
    TextStyle? style,
    Color color = KCColors.black3,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    super.textAlign,
    super.overflow,
    super.maxLines,
    double? height,
  }) : super(
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            fontWeight: fontWeight,
            height: height,
          ).merge(style),
        );
}

class KCHeadline2 extends KCTextBase {
  KCHeadline2(
    String super.text, {
    super.key,
    TextStyle? style,
    Color color = KCColors.primary,
    double fontSize = 27,
    FontWeight fontWeight = FontWeight.w900,
    super.textAlign,
    super.overflow,
    super.maxLines,
    double? height,
  }) : super(
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            fontWeight: fontWeight,
            height: height,
          ).merge(style),
        );
}

class KCHeadline3 extends KCTextBase {
  KCHeadline3(
    String super.text, {
    super.key,
    TextStyle? style,
    Color color = KCColors.primary,
    double fontSize = 22,
    FontWeight fontWeight = FontWeight.w900,
    super.textAlign,
    super.overflow,
    super.maxLines,
    double? height,
  }) : super(
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            fontWeight: fontWeight,
            height: height,
          ).merge(style),
        );
}

class KCHeadline4 extends KCTextBase {
  KCHeadline4(
    String super.text, {
    super.key,
    TextStyle? style,
    Color color = KCColors.black1,
    double fontSize = 15,
    FontWeight fontWeight = FontWeight.w900,
    super.textAlign,
    super.overflow,
    super.maxLines = 1,
    double? height,
  }) : super(
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            fontWeight: fontWeight,
            height: height,
          ).merge(style),
        );
}

class KCHeadline5 extends KCTextBase {
  KCHeadline5(
    String super.text, {
    super.key,
    TextStyle? style,
    Color color = KCColors.black3,
    double fontSize = 15,
    FontWeight fontWeight = FontWeight.w500,
    super.textAlign,
    super.overflow,
    super.maxLines,
    double? height,
  }) : super(
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            fontWeight: fontWeight,
            height: height,
          ).merge(style),
        );
}

class KCAutoSizedText extends StatelessWidget {
  const KCAutoSizedText(
    this.text, {
    super.key,
    this.color = KCColors.black3,
    this.fontSize = 15,
    this.fontWeight = FontWeight.w500,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.height,
  });

  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      maxLines: maxLines,
      textAlign: TextAlign.left,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: KCFonts.avenir,
        fontWeight: fontWeight,
        height: height,
      ),
    );
  }
}
