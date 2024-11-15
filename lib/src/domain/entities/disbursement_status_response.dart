// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

class DisbursementStatusResponse extends Equatable {
  final bool isCompleted;
  final bool isSuccessful;
  final String message;
  final String? next_repayment_date;
  final String? responseMessage;
  final dynamic transaction;

  const DisbursementStatusResponse({
    required this.isCompleted,
    required this.isSuccessful,
    required this.message,
    required this.next_repayment_date,
    required this.responseMessage,
    required this.transaction,
  });

  @override
  List<Object?> get props => [
        isCompleted,
        isSuccessful,
        message,
        next_repayment_date,
        responseMessage,
        transaction,
      ];
}
