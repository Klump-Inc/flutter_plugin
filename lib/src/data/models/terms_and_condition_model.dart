import 'package:klump_checkout/src/domain/domain.dart';

class TermsAndConditionModel extends TermsAndCondition {
  const TermsAndConditionModel({
    required super.title,
    required super.text,
    required super.doc,
    required super.version,
    required super.channel,
  });

  factory TermsAndConditionModel.fromJson(Map<String, dynamic> json) =>
      TermsAndConditionModel(
        title: json["title"],
        text: json["text"],
        doc: json["doc"],
        version: json["version"],
        channel: json["channel"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "text": text,
        "doc": doc,
        "version": version,
        "channel": channel,
      };
}
