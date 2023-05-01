import 'package:klump_checkout/src/domain/domain.dart';

class TermsAndConditionModel extends TermsAndCondition {
  const TermsAndConditionModel({
    required super.termsAndConditions,
    required super.version,
    required super.channel,
  });

  factory TermsAndConditionModel.fromJson(Map<String, dynamic> json) =>
      TermsAndConditionModel(
        termsAndConditions: json["termsAndConditions"],
        version: json["version"],
        channel: json["channel"],
      );

  Map<String, dynamic> toJson() => {
        "termsAndConditions": termsAndConditions,
        "version": version,
        "channel": channel,
      };
}
