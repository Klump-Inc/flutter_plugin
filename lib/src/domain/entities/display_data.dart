import 'package:equatable/equatable.dart';

class DisplayData extends Equatable {
  final String? title;
  final String? subTitle;
  final String? smallText;
  final List<dynamic>? list;
  final String? createPartnerAccountText;
  final String? createPartnerAccountUrl;
  final String? text;
  final dynamic version;
  final List<dynamic>? carousel;
  final String? subText;

  const DisplayData({
    this.title,
    this.subTitle,
    this.smallText,
    this.list,
    this.createPartnerAccountText,
    this.createPartnerAccountUrl,
    this.text,
    this.version,
    this.carousel,
    this.subText,
  });

  @override
  List<Object?> get props => [
        title,
        subTitle,
        smallText,
        list,
        createPartnerAccountText,
        createPartnerAccountUrl,
        text,
        version,
        carousel,
        subText,
      ];
}
