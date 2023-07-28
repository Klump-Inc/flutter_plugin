import 'package:equatable/equatable.dart';

class PartnerInsurer extends Equatable {
  final String name;
  final int value;

  const PartnerInsurer({
    required this.name,
    required this.value,
  });

  @override
  List<Object?> get props => [name, value];
}
