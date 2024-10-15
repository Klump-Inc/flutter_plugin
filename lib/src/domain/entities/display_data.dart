import 'package:equatable/equatable.dart';

class DisplayData extends Equatable {
  final String? title;
  final String? subTitle;
  final String? smallText;

  final List<dynamic>? list;
  final String? createPartnerAccountText;
  final String? createPartnerAccountUrl;

  const DisplayData({
    this.title,
    this.subTitle,
    this.smallText,
    this.list,
    this.createPartnerAccountText,
    this.createPartnerAccountUrl,
  });

  @override
  List<Object?> get props => [
        title,
        subTitle,
        smallText,
        list,
        createPartnerAccountText,
        createPartnerAccountUrl,
      ];
}
