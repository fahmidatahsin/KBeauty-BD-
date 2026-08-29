import 'package:flutter/material.dart';

import 'auth_service.dart';
import 'cart_model.dart';
import 'login_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _checkingLogin = true;
  bool _isLoggedIn = false;
  bool _clearing = false;

  @override
  void initState() {
    super.initState();

    _initializeCart();
  }

  // ============================================================
  // INITIALIZE
  // ============================================================

  Future<void> _initializeCart() async {
    final loggedIn = await AuthService.isLoggedIn();

    if (!mounted) return;

    setState(() {
      _isLoggedIn = loggedIn;
      _checkingLogin = false;
    });

    if (loggedIn) {
      await CartScope.of(context).loadCart();
    }
  }

  // ============================================================
  // LOGIN
  // ============================================================

  Future<void> _login() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );

    if (result == true && mounted) {
      setState(() {
        _isLoggedIn = true;
      });

      await CartScope.of(context).loadCart();
    }
  }

  // ============================================================
  // CLEAR CART
  // ============================================================

  Future<void> _clearCart() async {
    final cart = CartScope.of(context);

    if (cart.items.isEmpty) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear Cart?'),
          content: const Text(
            'Are you sure you want to remove all products from your cart?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('CANCEL'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('CLEAR CART'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      setState(() {
        _clearing = true;
      });

      await cart.clearCart();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cart cleared successfully.')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to clear cart: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _clearing = false;
        });
      }
    }
  }

  // ============================================================
  // IMAGE
  // ============================================================

  Widget _productImage(String image) {
    if (image.isEmpty) {
      return const Icon(
        Icons.image_not_supported_outlined,
        size: 60,
        color: Colors.black26,
      );
    }

    if (image.startsWith('http://') || image.startsWith('https://')) {
      return Image.network(
        image,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.image_not_supported_outlined,
            size: 60,
            color: Colors.black26,
          );
        },
      );
    }

    return Image.asset(
      image,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(
          Icons.image_not_supported_outlined,
          size: 60,
          color: Colors.black26,
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    if (_checkingLogin) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // ==========================================================
    // LOGIN REQUIRED
    // ==========================================================

    if (!_isLoggedIn) {
      return Scaffold(
        appBar: AppBar(title: const Text('MY CART')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.shopping_bag_outlined,
                  size: 90,
                  color: Colors.black38,
                ),

                const SizedBox(height: 25),

                const Text(
                  'Please login to view your cart.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                ElevatedButton(onPressed: _login, child: const Text('LOGIN')),
              ],
            ),
          ),
        ),
      );
    }

    // ==========================================================
    // LOGGED-IN CART
    // ==========================================================

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MY CART',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          AnimatedBuilder(
            animation: CartScope.of(context),
            builder: (context, child) {
              final cart = CartScope.of(context);

              if (cart.items.isEmpty) {
                return const SizedBox.shrink();
              }

              return TextButton(
                onPressed: _clearing ? null : _clearCart,
                child: const Text(
                  'CLEAR CART',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: CartScope.of(context),
        builder: (context, child) {
          final cart = CartScope.of(context);

          // ====================================================
          // LOADING
          // ====================================================

          if (cart.isLoading && cart.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // ====================================================
          // EMPTY
          // ====================================================

          if (cart.items.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 90,
                      color: Colors.black26,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Your cart is empty.',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Add some products to your cart.',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            );
          }

          // ====================================================
          // CART LIST
          // ====================================================

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(18),
                  itemCount: cart.items.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 12);
                  },
                  itemBuilder: (context, index) {
                    final item = cart.items[index];

                    return _cartItem(cart, item);
                  },
                ),
              ),

              // ==================================================
              // BOTTOM TOTAL
              // ==================================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'TOTAL ITEMS',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${cart.totalItems}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'TOTAL',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            '৳${cart.totalPrice.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Checkout will be available soon.',
                                ),
                              ),
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(13),
                            child: Text(
                              'CHECKOUT',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ============================================================
  // CART ITEM
  // ============================================================

  Widget _cartItem(CartModel cart, CartItem item) {
    final product = item.product;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ==================================================
          // IMAGE
          // ==================================================

          SizedBox(
            width: 95,
            height: 95,
            child: _productImage(product['image'] ?? ''),
          ),

          const SizedBox(width: 15),

          // ==================================================
          // INFO
          // ==================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'] ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  product['brand'] ?? '',
                  style: const TextStyle(
                    color: Color(0xFF1C6A50),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  '৳${item.unitPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // ==================================================
                // QUANTITY CONTROLS
                // ==================================================
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        cart.decrease(item);
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        cart.increase(item);
                      },
                      icon: const Icon(Icons.add_circle_outline),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ==================================================
          // DELETE
          // ==================================================
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  cart.remove(item);
                },
                icon: const Icon(Icons.delete_outline, color: Colors.red),
              ),

              const SizedBox(height: 20),

              Text(
                '৳${item.totalPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
