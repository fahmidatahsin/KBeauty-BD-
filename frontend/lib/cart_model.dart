import 'package:flutter/material.dart';

import 'cart_service.dart';

class CartItem {
  final String productId;
  final Map<String, String> product;
  int quantity;

  CartItem({
    required this.productId,
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
  final CartService _cartService = CartService();

  final List<CartItem> _items = [];

  bool _isLoading = false;

  // ============================================================
  // GETTERS
  // ============================================================

  List<CartItem> get items => List.unmodifiable(_items);

  bool get isLoading => _isLoading;

  int get totalItems {
    return _items.fold(0, (total, item) => total + item.quantity);
  }

  double get totalPrice {
    return _items.fold(0, (total, item) => total + item.totalPrice);
  }

  // ============================================================
  // LOAD CART
  // ============================================================

  Future<void> loadCart() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _cartService.getCart();

      _items.clear();

      final rawItems = data['items'];

      if (rawItems is List) {
        for (final rawItem in rawItems) {
          if (rawItem is! Map) {
            continue;
          }

          final product = rawItem['product'];

          if (product is! Map) {
            continue;
          }

          final productId = product['_id']?.toString() ?? '';

          if (productId.isEmpty) {
            continue;
          }

          final rawQuantity = rawItem['quantity'];

          final quantity = rawQuantity is int
              ? rawQuantity
              : int.tryParse(rawQuantity?.toString() ?? '1') ?? 1;

          _items.add(
            CartItem(
              productId: productId,
              product: {
                'id': productId,
                'name': product['name']?.toString() ?? '',
                'brand': product['brand']?.toString() ?? '',
                'price': product['price']?.toString() ?? '0',
                'image': product['image']?.toString() ?? '',
                'rating': product['rating']?.toString() ?? '',
              },
              quantity: quantity < 1 ? 1 : quantity,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Load cart error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // ADD TO CART
  // ============================================================

  Future<void> add(Map<String, String> product, int quantity) async {
    final productId = product['id'] ?? '';

    if (productId.isEmpty) {
      debugPrint('Product ID missing');
      return;
    }

    if (quantity < 1) {
      debugPrint('Invalid quantity');
      return;
    }

    try {
      await _cartService.addToCart(productId, quantity);

      await loadCart();
    } catch (e) {
      debugPrint('Add to cart error: $e');
      rethrow;
    }
  }

  // ============================================================
  // INCREASE
  // ============================================================

  Future<void> increase(CartItem item) async {
    final newQuantity = item.quantity + 1;

    try {
      await _cartService.updateCart(item.productId, newQuantity);

      item.quantity = newQuantity;

      notifyListeners();
    } catch (e) {
      debugPrint('Increase quantity error: $e');
    }
  }

  // ============================================================
  // DECREASE
  // ============================================================

  Future<void> decrease(CartItem item) async {
    if (item.quantity <= 1) {
      await remove(item);
      return;
    }

    final newQuantity = item.quantity - 1;

    try {
      await _cartService.updateCart(item.productId, newQuantity);

      item.quantity = newQuantity;

      notifyListeners();
    } catch (e) {
      debugPrint('Decrease quantity error: $e');
    }
  }

  // ============================================================
  // REMOVE ITEM
  // ============================================================

  Future<void> remove(CartItem item) async {
    try {
      await _cartService.removeFromCart(item.productId);

      _items.remove(item);

      notifyListeners();
    } catch (e) {
      debugPrint('Remove cart item error: $e');
    }
  }

  // ============================================================
  // CLEAR ENTIRE CART
  // ============================================================

  Future<void> clearCart() async {
    try {
      // First clear backend cart.
      await _cartService.clearCart();

      // Then clear local cart.
      _items.clear();

      notifyListeners();
    } catch (e) {
      debugPrint('Clear cart error: $e');
      rethrow;
    }
  }
}

// ============================================================
// CART SCOPE
// ============================================================

class CartScope extends InheritedNotifier<CartModel> {
  const CartScope({super.key, required CartModel cart, required super.child})
    : super(notifier: cart);

  static CartModel of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CartScope>();

    if (scope == null) {
      throw Exception('CartScope was not found.');
    }

    return scope.notifier!;
  }
}
