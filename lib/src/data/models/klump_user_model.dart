import 'package:klump_checkout/src/src.dart';

class KlumpUserModel extends KlumpUser {
  const KlumpUserModel({
    required super.firstname,
    required super.lastname,
    required super.maxLoanLimit,
    required super.requiresUserCredential,
  });

  factory KlumpUserModel.fromJson(Map<String, dynamic> json) => KlumpUserModel(
        firstname: json['user']['firstname'],
        lastname: json['user']['firstname'],
        maxLoanLimit: json['loanLimit'].runtimeType == String
            ? double.tryParse(json['loanLimit']?.toString() ?? '')
            : double.tryParse(
                json['loanLimit']?['maxLoanLimit']?.toString() ?? ''),
        requiresUserCredential: json['requiresUserCredential'],
      );
}
