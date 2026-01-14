import 'package:equatable/equatable.dart';
import 'package:klump_checkout/klump_checkout.dart';

class InitiateResponseModel extends Equatable {
  final dynamic message;
  final dynamic totalAmountToBePaid;
  final dynamic currency;
  final dynamic merchant;
  final bool isLive;
  final dynamic interest;
  final dynamic refundWallet;
  final NextStepModel? nextStep;

  const InitiateResponseModel({
    required this.message,
    required this.totalAmountToBePaid,
    required this.currency,
    required this.merchant,
    required this.isLive,
    required this.interest,
    required this.refundWallet,
    required this.nextStep,
  });

  factory InitiateResponseModel.fromJson(Map<String, dynamic> json) =>
      InitiateResponseModel(
        message: json["message"],
        totalAmountToBePaid: json["totalAmountToBePaid"],
        currency: json["currency"],
        merchant: json["merchant"],
        isLive: json["is_live"],
        interest: json["interest"],
        refundWallet: json["refund_wallet"],
        nextStep: json["next_step"] != null
            ? NextStepModel.fromJson(json["next_step"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "totalAmountToBePaid": totalAmountToBePaid,
        "currency": currency,
        "merchant": merchant,
        "is_live": isLive,
        "interest": interest,
        "refund_wallet": refundWallet,
        "next_step": null,
      };

  @override
  List<Object?> get props => [
        merchant,
        currency,
        merchant,
        isLive,
        interest,
        refundWallet,
      ];
}
