import 'package:equatable/equatable.dart';

class TermsAndCondition extends Equatable {
  final String? title;
  final String? text;
  final String? doc;
  final String? version;
  final dynamic channel;

  const TermsAndCondition({
    required this.title,
    required this.text,
    required this.doc,
    required this.version,
    required this.channel,
  });

  @override
  List<Object?> get props => [
        title,
        text,
        doc,
        version,
        channel,
      ];
}
