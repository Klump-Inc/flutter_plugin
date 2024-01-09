import 'package:klump_checkout/src/src.dart';

class PartnerInsurerModel extends PartnerInsurer {
  const PartnerInsurerModel({
    required super.name,
    required super.value,
  });

  factory PartnerInsurerModel.fromJson(Map<String, dynamic> json) =>
      PartnerInsurerModel(
        name: json['name'],
        value: json['value'],
      );
}
