import 'package:klump_checkout/src/src.dart';

class PartnerMetadataModel extends PartnerMetadata {
  const PartnerMetadataModel({
    required super.partnerType,
    required super.customerType,
    required super.dropdownMessage,
    required super.allowDynamicDownpayment,
  });

  factory PartnerMetadataModel.fromJson(Map<String, dynamic> json) =>
      PartnerMetadataModel(
        partnerType: json['partner_type'],
        customerType: json['customer_type'],
        dropdownMessage: json['dropdown_message'],
        allowDynamicDownpayment: json['allow_dynamic_downpayment'],
      );

  Map<String, dynamic> toJson() => {
        'partner_type': partnerType,
        'customer_type': customerType,
        'dropdown_message': dropdownMessage,
        'allow_dynamic_downpayment': allowDynamicDownpayment,
      };
}
