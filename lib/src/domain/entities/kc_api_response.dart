import 'package:equatable/equatable.dart';
import 'package:klump_checkout/klump_checkout.dart';

class KCAPIResponse extends Equatable {
  final NextStep nextStep;
  final dynamic data;
  final dynamic message;

  const KCAPIResponse({
    required this.nextStep,
    this.data,
    this.message,
  });

  @override
  List<Object?> get props => [
        nextStep,
        data,
        message,
      ];
}
