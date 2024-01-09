import 'package:equatable/equatable.dart';

class DisplayData extends Equatable {
  final String? title;
  final String? subTitle;
  final List<dynamic>? list;
  final String? createPartnerAccountText;
  final String? createPartnerAccountUrl;

  const DisplayData({
    this.title,
    this.subTitle,
    this.list,
    this.createPartnerAccountText,
    this.createPartnerAccountUrl,
  });

  @override
  List<Object?> get props => [
        title,
        subTitle,
        list,
        createPartnerAccountText,
        createPartnerAccountUrl,
      ];
}
