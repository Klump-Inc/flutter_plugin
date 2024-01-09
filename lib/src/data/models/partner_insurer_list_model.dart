import 'package:klump_checkout/src/src.dart';

class PartnerInsurerListModel {
  PartnerInsurerListModel({
    required this.data,
  });

  final List<PartnerInsurerModel> data;
  factory PartnerInsurerListModel.fromJson(Map<String, dynamic> json) =>
      PartnerInsurerListModel(
        data: List<PartnerInsurerModel>.from(
          json["data"].map((x) => PartnerInsurerModel.fromJson(x)),
        ),
      );
}
