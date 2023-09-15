import 'package:klump_checkout/klump_checkout.dart';

class PartnerModel extends Partner {
  const PartnerModel({
    required super.id,
    required super.name,
    required super.slug,
    super.logo,
    required super.isActive,
    required super.requiresPrequalification,
    super.interest,
    super.minLoanAmount,
    super.maxLoanAmount,
    super.minAge,
    required super.config,
    super.createdAt,
    super.updatedAt,
    super.nextStep,
  });

  factory PartnerModel.fromJson(Map<String, dynamic> json) => PartnerModel(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        logo: json["logo"],
        isActive: json["is_active"],
        requiresPrequalification: json["requires_prequalification"],
        interest: json["interest"],
        minLoanAmount: json["min_loan_amount"],
        maxLoanAmount: json["max_loan_amount"],
        minAge: json["min_age"],
        config: json["config"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        nextStep: json['next_step'] == null
            ? null
            : NextStepModel.fromJson(json['next_step']),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "logo": logo,
        "is_active": isActive,
        "requires_prequalification": requiresPrequalification,
        "interest": interest,
        "min_loan_amount": minLoanAmount,
        "max_loan_amount": maxLoanAmount,
        "min_age": minAge,
        "config": config,
        "created_at": createdAt,
        "updated_at": updatedAt?.toIso8601String(),
      };
}
