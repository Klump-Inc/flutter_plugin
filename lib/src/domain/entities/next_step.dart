import 'package:equatable/equatable.dart';
import 'package:klump_checkout/src/src.dart';

class NextStep extends Equatable {
  final String? name;
  final String? method;
  final DisplayDataModel? displayData;
  final List<FormFieldModel>? formFields;
  final String? redirectUrl;
  final String? api;
  final dynamic timeout;

  const NextStep({
    this.name,
    this.method,
    this.displayData,
    this.formFields,
    this.redirectUrl,
    this.api,
    this.timeout,
  });
  @override
  List<Object?> get props => [
        name,
        method,
        displayData,
        redirectUrl,
        api,
        timeout,
      ];
}
