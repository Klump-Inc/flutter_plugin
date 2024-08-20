import 'package:equatable/equatable.dart';

class FormFieldModel extends Equatable {
  final String? type;
  final String? name;
  final String? label;
  final String? placeholder;
  final List? options;

  const FormFieldModel({
    this.type,
    this.name,
    this.label,
    this.placeholder,
    this.options,
  });
  factory FormFieldModel.fromJson(Map<String, dynamic> json) => FormFieldModel(
        type: json['type'],
        name: json['name'],
        label: json['label'],
        placeholder: json['placeholder'],
        options: json['options'],
      );

  @override
  List<Object?> get props => [
        type,
        name,
        label,
        placeholder,
        options,
      ];
}
