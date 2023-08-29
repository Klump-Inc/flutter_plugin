import 'package:klump_checkout/src/domain/entities/disbursement_status_response.dart';

class DisbursementStatusResponseModel extends DisbursementStatusResponse {
  const DisbursementStatusResponseModel({
    required super.isCompleted,
    required super.isSuccessful,
    required super.message,
  });

  factory DisbursementStatusResponseModel.fromJson(Map<String, dynamic> json) =>
      DisbursementStatusResponseModel(
        isCompleted: json["is_completed"],
        isSuccessful: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "is_completed": isCompleted,
        "success": isSuccessful,
        "message": message,
      };
}
