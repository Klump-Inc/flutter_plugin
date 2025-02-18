import 'package:equatable/equatable.dart';

class FormFieldModel extends Equatable {
  final String? type;
  final String? name;
  final String? label;
  final String? placeholder;
  final List? options;
  final dynamic smalltext;
  final dynamic min;
  final dynamic max;
  final dynamic value;

  const FormFieldModel({
    this.type,
    this.name,
    this.label,
    this.placeholder,
    this.options,
    this.smalltext,
    this.max,
    this.min,
    this.value,
  });
  factory FormFieldModel.fromJson(Map<String, dynamic> json) => FormFieldModel(
        type: json['type'],
        name: json['name'],
        label: json['label'],
        placeholder: json['placeholder'],
        options: json['options'],
        smalltext: json['smalltext'],
        min: json['min'],
        max: json['max'],
        value: json['value'],
      );

  @override
  List<Object?> get props => [
        type,
        name,
        label,
        placeholder,
        options,
        smalltext,
        min,
        max,
        value,
      ];
}
