import 'package:equatable/equatable.dart';

class KlumpUser extends Equatable {
  final String firstname;
  final String lastname;
  final String email;

  final double? maxLoanLimit;
  final bool? requiresUserCredential;

  const KlumpUser({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.maxLoanLimit,
    required this.requiresUserCredential,
  });

  @override
  List<Object?> get props => [
        firstname,
        lastname,
        email,
        maxLoanLimit,
        requiresUserCredential,
      ];
}
