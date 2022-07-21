import 'package:equatable/equatable.dart';

class KlumpCheckoutResponse extends Equatable {
  final CheckoutStatus status;
  final Map<String, dynamic>? data;

  const KlumpCheckoutResponse(
    this.status,
    this.data,
  );

  @override
  List<Object?> get props => [
        status,
        data,
      ];
}

enum CheckoutStatus {
  success,
  error,
}
