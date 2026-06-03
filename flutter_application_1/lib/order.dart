class Order {
  final String id;
  final String date;
  final double total;
  final String status;
  final List<CartItem> items;

  Order({
    required this.id,
    required this.date,
    required this.total,
    required this.status,
    this.items = const [],
  });
}

class CartItem {
  final String name;
  final double price;
  final int quantity;

  CartItem({
    required this.name,
    required this.price,
    required this.quantity,
  });
}