// ignore_for_file: non_constant_identifier_names

import 'package:klump_checkout/src/domain/entities/disbursement_status_response.dart';

class DisbursementStatusResponseModel extends DisbursementStatusResponse {
  const DisbursementStatusResponseModel({
    required super.isCompleted,
    required super.isSuccessful,
    required super.message,
    required super.next_repayment_date,
  });

  factory DisbursementStatusResponseModel.fromJson(Map<String, dynamic> json) =>
      DisbursementStatusResponseModel(
        isCompleted: json["is_completed"],
        isSuccessful: json["success"],
        message: json["message"],
        next_repayment_date: json["next_repayment_date"],
      );

  Map<String, dynamic> toJson() => {
        "is_completed": isCompleted,
        "success": isSuccessful,
        "message": message,
        "next_repayment_date": next_repayment_date,
      };
}
