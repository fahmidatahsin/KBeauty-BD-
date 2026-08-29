import 'package:flutter/material.dart';

import 'auth_service.dart';
import 'cart_model.dart';
import 'login_page.dart';
import 'services/order_service.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _checkingLogin = true;
  bool _isLoggedIn = false;
  bool _clearing = false;
  bool _placingOrder = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

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
  // CHECKOUT
  // ============================================================

  Future<void> _openCheckout() async {
    final cart = CartScope.of(context);

    if (cart.items.isEmpty) {
      return;
    }

    _nameController.clear();
    _addressController.clear();
    _contactController.clear();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.90,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    22,
                    20,
                    22,
                    MediaQuery.of(context).viewInsets.bottom + 25,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ==================================================
                      // TITLE
                      // ==================================================

                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'CHECKOUT',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        'Enter your delivery information',
                        style: TextStyle(color: Colors.black54, fontSize: 15),
                      ),

                      const SizedBox(height: 25),

                      // ==================================================
                      // NAME
                      // ==================================================
                      const Text(
                        'Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'Enter your full name',
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // ==================================================
                      // ADDRESS
                      // ==================================================
                      const Text(
                        'Address',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: _addressController,
                        maxLines: 3,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'Enter your delivery address',
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(bottom: 42),
                            child: Icon(Icons.location_on_outlined),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // ==================================================
                      // CONTACT
                      // ==================================================
                      const Text(
                        'Contact No.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: _contactController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: '01XXXXXXXXX',
                          prefixIcon: const Icon(Icons.phone_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // ==================================================
                      // PAYMENT METHOD
                      // ==================================================
                      const Text(
                        'Payment Method',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F7F5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF1C6A50)),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.money_outlined,
                              color: Color(0xFF1C6A50),
                              size: 28,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Cash on Delivery',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    'Pay when your order is delivered.',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.check_circle, color: Color(0xFF1C6A50)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      // ==================================================
                      // ORDER SUMMARY
                      // ==================================================
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Items',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '${cart.totalItems}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Amount',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  '৳${cart.totalPrice.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      // ==================================================
                      // PLACE ORDER
                      // ==================================================
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: FilledButton(
                          onPressed: _placingOrder
                              ? null
                              : () async {
                                  final name = _nameController.text.trim();
                                  final address = _addressController.text
                                      .trim();
                                  final contact = _contactController.text
                                      .trim();

                                  // ==============================
                                  // VALIDATION
                                  // ==============================

                                  if (name.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please enter your name.',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  if (address.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please enter your delivery address.',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  if (contact.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please enter your contact number.',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  if (contact.length < 10) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please enter a valid contact number.',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  // ==============================
                                  // PLACE ORDER
                                  // ==============================

                                  setModalState(() {
                                    _placingOrder = true;
                                  });

                                  try {
                                    final result =
                                        await OrderService.placeOrder(
                                          customerName: name,
                                          address: address,
                                          contactNo: contact,
                                        );

                                    if (!mounted) return;

                                    // Close checkout sheet
                                    Navigator.pop(context);

                                    final order = result['order'];

                                    final orderId = order != null
                                        ? order['_id']?.toString()
                                        : null;

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: const Duration(seconds: 5),
                                        content: Text(
                                          orderId != null
                                              ? 'Order placed successfully! Order ID: $orderId'
                                              : 'Order placed successfully!',
                                        ),
                                      ),
                                    );

                                    // Reload cart
                                    await CartScope.of(context).loadCart();
                                  } catch (e) {
                                    if (!mounted) return;

                                    setModalState(() {
                                      _placingOrder = false;
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Failed to place order: $e',
                                        ),
                                      ),
                                    );
                                  }
                                },
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF1C6A50),
                          ),
                          child: _placingOrder
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'PLACE ORDER',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
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

    // ============================================================
    // LOGIN REQUIRED
    // ============================================================

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

    // ============================================================
    // LOGGED-IN CART
    // ============================================================

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

          // ======================================================
          // LOADING
          // ======================================================

          if (cart.isLoading && cart.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // ======================================================
          // EMPTY
          // ======================================================

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

          // ======================================================
          // CART LIST
          // ======================================================

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

                      // ==================================================
                      // CHECKOUT BUTTON
                      // ==================================================
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _placingOrder ? null : _openCheckout,
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

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _contactController.dispose();

    super.dispose();
  }
}
