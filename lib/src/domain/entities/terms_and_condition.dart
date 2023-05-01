import 'package:equatable/equatable.dart';

class TermsAndCondition extends Equatable {
  final String termsAndConditions;
  final String version;
  final String channel;

  const TermsAndCondition({
    required this.termsAndConditions,
    required this.version,
    required this.channel,
  });

  @override
  List<Object?> get props => [
        termsAndConditions,
        version,
        channel,
      ];
}
