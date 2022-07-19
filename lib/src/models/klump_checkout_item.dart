class KlumpCheckoutItem {
  final String? imageUrl;
  final String? itemUrl;
  final String name;
  final double unitPrice;
  final int quantity;

  KlumpCheckoutItem(
    this.imageUrl,
    this.itemUrl,
    this.name,
    this.unitPrice,
    this.quantity,
  );

  Map<String, dynamic> toJson() => {
        'image_url': imageUrl ?? '',
        'item_url': itemUrl ?? '',
        'name': name,
        'unit_price': unitPrice,
        'quantity': quantity,
      };
}
