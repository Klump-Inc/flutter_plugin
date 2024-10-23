import 'package:klump_checkout/src/src.dart';

class KlumpUserModel extends KlumpUser {
  const KlumpUserModel({
    required super.firstname,
    required super.lastname,
    required super.email,
    required super.maxLoanLimit,
    required super.requiresUserCredential,
    required super.dob,
  });

  factory KlumpUserModel.fromJson(Map<String, dynamic> json) => KlumpUserModel(
        firstname: json['user']?['firstname'],
        lastname: json['user']?['firstname'],
        email: json['user']?['email'],
        dob: json['user']?['date_of_birth'],
        maxLoanLimit: double.tryParse(json['loanLimit']?.toString() ?? ''),
        requiresUserCredential: json['requiresUserCredential'],
      );
}
