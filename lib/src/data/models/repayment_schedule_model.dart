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
        principal: json["principal"],
        interest: json["interest"],
        monthlyRepayment:
            double.tryParse(json["monthlyRepayment"]?.toString() ?? '') ?? 0,
        principalBalance: json["principalBalance"],
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
