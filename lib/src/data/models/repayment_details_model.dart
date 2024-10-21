import 'package:klump_checkout/klump_checkout.dart';

class RepaymentDetailsModel extends RepaymentDetails {
  const RepaymentDetailsModel({
    required super.accountNumber,
    required super.transactionType,
    required super.amount,
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
    required super.repaymentMetadata,
  });

  factory RepaymentDetailsModel.fromJson(Map<String, dynamic> json) =>
      RepaymentDetailsModel(
        accountNumber: json["accountNumber"],
        transactionType: json["transactionType"],
        amount: json["amount"],
        loanAmount: json["loanAmount"],
        downpaymentAmount: json["downpaymentAmount"],
        monthlyRepayment: json["monthlyRepayment"],
        totalRepayment: json["totalRepayment"],
        managementFee: json["other_charges"]?["managementFee"],
        interest: json["interest"],
        vat: json["vat"],
        insurance: json["insurance"],
        tenor: json["tenor"],
        installment: json["installment"],
        minimumBalanceRequired: json["minimumBalanceRequired"],
        repaymentDay: json["repaymentDay"],
        repaymentSchedules: List<RepaymentScheduleModel>.from(
            json["repaymentSchedules"]
                ?.map((x) => RepaymentScheduleModel.fromJson(x))),
        repaymentMetadata: json["repaymentMetadata"],
      );

  Map<String, dynamic> toJson() => {
        "accountNumber": accountNumber,
        "transactionType": transactionType,
        "amount": amount,
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
            List<dynamic>.from(repaymentSchedules!.map((x) => x.toJson())),
        "repaymentMetadata": repaymentMetadata,
      };
}
