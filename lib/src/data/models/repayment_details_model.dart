import 'package:klump_checkout/klump_checkout.dart';

class RepaymentDetailsModel extends RepaymentDetails {
  const RepaymentDetailsModel({
    required super.accountNumber,
    required super.transactionType,
    required super.instantBuyAmount,
    required super.loanAmount,
    required super.downpaymentAmount,
    required super.monthlyRepayment,
    required super.totalRepayment,
    required super.managementFee,
    required super.interest,
    required super.vat,
    required super.insurance,
    required super.tenor,
    required super.installment,
    required super.minimumBalanceRequired,
    required super.repaymentDay,
    required super.repaymentSchedules,
    super.repaymentMetadata,
  });

  factory RepaymentDetailsModel.fromJson(Map<String, dynamic> json) =>
      RepaymentDetailsModel(
        accountNumber: json["accountNumber"],
        transactionType: json["transactionType"],
        instantBuyAmount: json["instantBuyAmount"].toDouble(),
        loanAmount: json["loanAmount"].toDouble(),
        downpaymentAmount: json["downpaymentAmount"].toDouble(),
        monthlyRepayment: json["monthlyRepayment"]?.toDouble(),
        totalRepayment: json["totalRepayment"]?.toDouble(),
        managementFee: json["managementFee"]?.toDouble(),
        interest: json["interest"]?.toDouble(),
        vat: json["vat"]?.toDouble(),
        insurance: json["insurance"]?.toDouble(),
        tenor: json["tenor"],
        installment: json["installment"],
        minimumBalanceRequired: json["minimumBalanceRequired"]?.toDouble(),
        repaymentDay: json["repaymentDay"],
        repaymentSchedules: List<RepaymentScheduleModel>.from(
            json["repaymentSchedules"]
                .map((x) => RepaymentScheduleModel.fromJson(x))),
        repaymentMetadata: json["repaymentMetadata"],
      );

  Map<String, dynamic> toJson() => {
        "accountNumber": accountNumber,
        "transactionType": transactionType,
        "instantBuyAmount": instantBuyAmount,
        "loanAmount": loanAmount,
        "downpaymentAmount": downpaymentAmount,
        "monthlyRepayment": monthlyRepayment,
        "totalRepayment": totalRepayment,
        "managementFee": managementFee,
        "interest": interest,
        "vat": vat,
        "insurance": insurance,
        "tenor": tenor,
        "installment": installment,
        "minimumBalanceRequired": minimumBalanceRequired,
        "repaymentDay": repaymentDay,
        "repaymentSchedules":
            List<dynamic>.from(repaymentSchedules.map((x) => x.toJson())),
        "repaymentMetadata": repaymentMetadata,
      };
}
