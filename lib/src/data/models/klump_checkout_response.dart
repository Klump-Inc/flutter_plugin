import 'package:equatable/equatable.dart';

class KlumpCheckoutResponse extends Equatable {
  final CheckoutStatus status;
  final String message;
  final Map<String, dynamic>? data;

  const KlumpCheckoutResponse(
    this.status,
    this.message,
    this.data,
  );

  @override
  List<Object?> get props => [
        status,
        message,
        data,
      ];
}

enum CheckoutStatus {
  success,
  error,
}
