import 'package:equatable/equatable.dart';

class KCBank extends Equatable {
  const KCBank({required this.name, required this.logo});

  final String name;
  final String logo;
  @override
  List<Object?> get props => [
        name,
        logo,
      ];
}
