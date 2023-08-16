import 'package:klump_checkout/klump_checkout.dart';

class PartnerListModel {
  final List<PartnerModel> data;

  PartnerListModel({
    required this.data,
  });

  factory PartnerListModel.fromJson(Map<String, dynamic> json) =>
      PartnerListModel(
        data: List<PartnerModel>.from(
            json["data"].map((x) => PartnerModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
