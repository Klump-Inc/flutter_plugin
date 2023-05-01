import 'package:klump_checkout/klump_checkout.dart';

class RepaymentScheduleModel extends RepaymentSchedule {
  const RepaymentScheduleModel({
    required super.principal,
    required super.interest,
    required super.monthlyRepayment,
    required super.principalBalance,
    required super.repaymentDate,
  });

  factory RepaymentScheduleModel.fromJson(Map<String, dynamic> json) =>
      RepaymentScheduleModel(
        principal: json["principal"]?.toDouble(),
        interest: json["interest"]?.toDouble(),
        monthlyRepayment: json["monthlyRepayment"]?.toDouble(),
        principalBalance: json["principalBalance"]?.toDouble(),
        repaymentDate: json["repayment_date"],
      );

  Map<String, dynamic> toJson() => {
        "principal": principal,
        "interest": interest,
        "monthlyRepayment": monthlyRepayment,
        "principalBalance": principalBalance,
        "repayment_date": repaymentDate,
      };
}
