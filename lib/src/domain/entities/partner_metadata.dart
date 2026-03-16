// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

class PartnerMetadata extends Equatable {
  final dynamic partnerType;
  final dynamic customerType;
  final dynamic dropdownMessage;
  final dynamic allowDynamicDownpayment;

  const PartnerMetadata({
    required this.partnerType,
    required this.customerType,
    required this.dropdownMessage,
    required this.allowDynamicDownpayment,
  });

  @override
  List<Object?> get props => [
        partnerType,
        customerType,
        dropdownMessage,
        allowDynamicDownpayment,
      ];
}
