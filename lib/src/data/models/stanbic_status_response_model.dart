import 'package:klump_checkout/src/domain/entities/stanbic_status_response.dart';

class StanbicStatusResponseModel extends StanbicStatusResponse {
  const StanbicStatusResponseModel({
    required super.isCompleted,
    required super.isSuccessful,
    required super.message,
  });

  factory StanbicStatusResponseModel.fromJson(Map<String, dynamic> json) =>
      StanbicStatusResponseModel(
        isCompleted: json["isCompleted"],
        isSuccessful: json["isSuccessful"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "isCompleted": isCompleted,
        "isSuccessful": isSuccessful,
        "message": message,
      };
}
