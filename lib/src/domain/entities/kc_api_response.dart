import 'package:equatable/equatable.dart';
import 'package:klump_checkout/klump_checkout.dart';

class KCAPIResponse extends Equatable {
  final NextStep nextStep;
  final dynamic data;

  const KCAPIResponse({
    required this.nextStep,
    this.data,
  });

  @override
  List<Object?> get props => [nextStep, data];
}
