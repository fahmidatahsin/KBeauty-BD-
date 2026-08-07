import 'package:flutter/material.dart';

class CartItem {
  final Map<String, String> product;
  int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });

  double get unitPrice {
    final value = product['price'] ?? '0';
    return double.tryParse(value.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
  }

  double get totalPrice => unitPrice * quantity;
}

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalItems =>
      _items.fold(0, (total, item) => total + item.quantity);

  double get totalPrice =>
      _items.fold(0, (total, item) => total + item.totalPrice);

  void add(Map<String, String> product, int quantity) {
    final existingItem = _items.where(
      (item) => item.product['name'] == product['name'],
    );

    if (existingItem.isNotEmpty) {
      existingItem.first.quantity += quantity;
    } else {
      _items.add(
        CartItem(
          product: Map<String, String>.from(product),
          quantity: quantity,
        ),
      );
    }

    notifyListeners();
  }

  void increase(CartItem item) {
    item.quantity++;
    notifyListeners();
  }

  void decrease(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(item);
    }
    notifyListeners();
  }

  void remove(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }
  void clear() {
  _items.clear();
  notifyListeners();
}
}

class CartScope extends InheritedNotifier<CartModel> {
  const CartScope({
    super.key,
    required CartModel cart,
    required super.child,
  }) : super(notifier: cart);

  static CartModel of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<CartScope>();

    if (scope == null) {
      throw Exception('CartScope was not found.');
    }

    return scope.notifier!;
  }
}