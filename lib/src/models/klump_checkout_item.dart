class KlumpCheckoutItem {
  final String? imageUrl;
  final String? itemUrl;
  final String name;
  final double unitPrice;
  final int quantity;

  KlumpCheckoutItem({
    this.imageUrl,
    this.itemUrl,
    required this.name,
    required this.unitPrice,
    required this.quantity,
  });

  Map<String, dynamic> toMap() => {
        'image_url': "'${imageUrl ?? ''}'",
        'item_url': "'${itemUrl ?? ''}'",
        'name': "'$name'",
        'unit_price': "'$unitPrice'",
        'quantity': quantity,
      };
}
