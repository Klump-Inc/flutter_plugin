import 'package:equatable/equatable.dart';

class RepaymentSchedule extends Equatable {
  final double principal;
  final double interest;
  final double monthlyRepayment;
  final double principalBalance;
  final String repaymentDate;

  const RepaymentSchedule({
    required this.principal,
    required this.interest,
    required this.monthlyRepayment,
    required this.principalBalance,
    required this.repaymentDate,
  });

  @override
  List<Object?> get props => [
        principal,
        interest,
        monthlyRepayment,
        principalBalance,
        repaymentDate,
      ];
}