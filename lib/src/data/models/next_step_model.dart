import 'package:klump_checkout/klump_checkout.dart';

class NextStepModel extends NextStep {
  const NextStepModel({
    super.name,
    super.method,
    super.displayData,
    super.formFields,
    super.redirectUrl,
    super.api,
    super.timeout,
  });

  factory NextStepModel.fromJson(Map<String, dynamic> json) => NextStepModel(
        name: json['name'],
        method: json['method'],
        displayData: json["display_data"] == null
            ? null
            : DisplayDataModel.fromJson(json['display_data']),
        formFields: json["form_fields"] == null
            ? null
            : List<FormFieldModel>.from(
                json["form_fields"].map((x) => FormFieldModel.fromJson(x))),
        redirectUrl: json['redirect_url'],
        api: json['api'],
        timeout: json['timeout'],
      );
}
