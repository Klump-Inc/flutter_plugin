import 'package:equatable/equatable.dart';

class KlumpUser extends Equatable {
  final String firstname;
  final String lastname;
  final double? maxLoanLimit;
  final bool? requiresUserCredential;

  const KlumpUser({
    required this.firstname,
    required this.lastname,
    required this.maxLoanLimit,
    required this.requiresUserCredential,
  });

  @override
  List<Object?> get props => [
        firstname,
        lastname,
        maxLoanLimit,
        requiresUserCredential,
      ];
}
