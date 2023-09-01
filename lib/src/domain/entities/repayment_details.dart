import 'package:equatable/equatable.dart';
import 'package:klump_checkout/klump_checkout.dart';

class RepaymentDetails extends Equatable {
  final String? accountNumber;
  final String? transactionType;
  final double loanAmount;
  final double downpaymentAmount;
  final double monthlyRepayment;
  final double? totalRepayment;
  final double? managementFee;
  final double? interest;
  final dynamic vat;
  final dynamic insurance;
  final dynamic tenor;
  final dynamic installment;
  final dynamic minimumBalanceRequired;
  final dynamic repaymentDay;
  final List<RepaymentScheduleModel> repaymentSchedules;
  final dynamic repaymentMetadata;

  const RepaymentDetails({
    required this.accountNumber,
    required this.transactionType,
    required this.loanAmount,
    required this.downpaymentAmount,
    required this.monthlyRepayment,
    required this.totalRepayment,
    required this.managementFee,
    required this.interest,
    required this.vat,
    required this.insurance,
    required this.tenor,
    required this.installment,
    required this.minimumBalanceRequired,
    required this.repaymentDay,
    required this.repaymentSchedules,
    this.repaymentMetadata,
  });

  @override
  List<Object?> get props => [
        accountNumber,
        transactionType,
        loanAmount,
        downpaymentAmount,
        monthlyRepayment,
        totalRepayment,
        managementFee,
        interest,
        vat,
        insurance,
        tenor,
        installment,
        minimumBalanceRequired,
        repaymentDay,
        repaymentSchedules,
        repaymentMetadata,
      ];
}
