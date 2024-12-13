import 'package:klump_checkout/src/src.dart';

class PartnerInsurerModel extends PartnerInsurer {
  const PartnerInsurerModel({
    required super.id,
    required super.insurance,
    required super.rate,
    required super.range,
  });

  factory PartnerInsurerModel.fromJson(Map<String, dynamic> json) =>
      PartnerInsurerModel(
        id: json['id'],
        insurance: json['insurance'],
        rate: json['rate'],
        range: json['range'],
      );
}
