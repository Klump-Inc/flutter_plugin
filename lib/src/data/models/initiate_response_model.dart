import 'package:equatable/equatable.dart';

class InitiateResponseModel extends Equatable {
  final dynamic message;
  final dynamic totalAmountToBePaid;
  final dynamic currency;
  final dynamic merchant;
  final bool isLive;
  final dynamic interest;

  const InitiateResponseModel({
    required this.message,
    required this.totalAmountToBePaid,
    required this.currency,
    required this.merchant,
    required this.isLive,
    required this.interest,
  });

  factory InitiateResponseModel.fromJson(Map<String, dynamic> json) =>
      InitiateResponseModel(
        message: json["message"],
        totalAmountToBePaid: json["totalAmountToBePaid"],
        currency: json["currency"],
        merchant: json["merchant"],
        isLive: json["is_live"],
        interest: json["interest"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "totalAmountToBePaid": totalAmountToBePaid,
        "currency": currency,
        "merchant": merchant,
        "is_live": isLive,
        "interest": interest,
      };

  @override
  List<Object?> get props => [
        merchant,
        currency,
        merchant,
        isLive,
        interest,
      ];
}
