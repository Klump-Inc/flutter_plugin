import 'package:equatable/equatable.dart';

class KCBankEntity extends Equatable {
  const KCBankEntity({required this.name, required this.logo});

  final String name;
  final String logo;
  @override
  List<Object?> get props => [
        name,
        logo,
      ];
}
