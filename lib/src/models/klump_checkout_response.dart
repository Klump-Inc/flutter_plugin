class KlumpCheckoutHandler {
  final CheckoutStatus status;
  final Map<String, dynamic>? data;

  KlumpCheckoutHandler(
    this.status,
    this.data,
  );
}

enum CheckoutStatus {
  pending,
  success,
  error,
}
