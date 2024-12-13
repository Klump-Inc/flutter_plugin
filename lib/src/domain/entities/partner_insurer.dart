import 'package:equatable/equatable.dart';

class PartnerInsurer extends Equatable {
  final dynamic id;
  final dynamic insurance;
  final dynamic rate;
  final dynamic range;

  const PartnerInsurer({
    required this.id,
    required this.insurance,
    required this.rate,
    required this.range,
  });

  @override
  List<Object?> get props => [
        id,
        insurance,
        rate,
        range,
      ];
}
