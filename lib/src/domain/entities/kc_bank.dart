import 'package:equatable/equatable.dart';

class KCBank extends Equatable {
  const KCBank({required this.name, required this.logo, required this.alias});

  final String name;
  final String logo;
  final String alias;
  @override
  List<Object?> get props => [
        name,
        logo,
        alias,
      ];
}
