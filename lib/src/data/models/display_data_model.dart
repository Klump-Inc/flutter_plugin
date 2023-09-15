import 'package:klump_checkout/src/src.dart';

class DisplayDataModel extends DisplayData {
  const DisplayDataModel({
    super.title,
    super.subTitle,
    super.list,
    super.createPartnerAccountText,
    super.createPartnerAccountUrl,
  });
  factory DisplayDataModel.fromJson(Map<String, dynamic> json) =>
      DisplayDataModel(
        title: json['title'],
        subTitle: json['subtitle'],
        list: json['list'],
        createPartnerAccountText: json['create_partner_account_text'],
        createPartnerAccountUrl: json['create_partner_account_url'],
      );
}
