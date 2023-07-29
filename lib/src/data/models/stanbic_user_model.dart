import 'package:klump_checkout/src/src.dart';

class StanbicUserModel extends StanbicUser {
  const StanbicUserModel({
    required super.firstname,
    required super.lastname,
    required super.maxLoanLimit,
    required super.requiresUserCredential,
  });

  factory StanbicUserModel.fromJson(Map<String, dynamic> json) =>
      StanbicUserModel(
        firstname: json['user']['firstname'],
        lastname: json['user']['firstname'],
        maxLoanLimit: json['loanLimit']['maxLoanLimit']?.toDouble(),
        requiresUserCredential: json['requiresUserCredential'],
      );
}
