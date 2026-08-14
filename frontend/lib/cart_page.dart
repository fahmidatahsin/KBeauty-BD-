import 'package:flutter/material.dart';
import 'cart_model.dart';
import 'checkout_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  static const Color green = Color(0xFF1C6A50);
  static const Color background = Color(0xFFF7F7F6);

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);

    const double shippingCost = 80.0;
    final double total = cart.totalPrice + shippingCost;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            // ============================================================
            // HEADER
            // ============================================================
            Container(
              height: 82,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 38),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 20,
                    ),
                    label: const Text(
                      'Home',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const Spacer(),

                  const Text(
                    'K-BEAUTY BD',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                      color: Colors.black,
                    ),
                  ),

                  const Spacer(),

                  // Cart icon + item count
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(
                        Icons.shopping_cart_outlined,
                        size: 29,
                        color: Colors.black,
                      ),

                      if (cart.totalItems > 0)
                        Positioned(
                          right: -8,
                          top: -9,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${cart.totalItems}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // ============================================================
            // PAGE CONTENT
            // ============================================================
            Expanded(
              child: cart.items.isEmpty
                  ? _buildEmptyCart(context)
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 35,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 1250,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // =================================================
                              // TITLE
                              // =================================================
                              const Text(
                                'YOUR CART',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                'Review the items you have added to your cart.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                ),
                              ),

                              const SizedBox(height: 28),

                              // =================================================
                              // PRODUCTS
                              // =================================================
                              ...cart.items.map(
                                (item) => _buildCartItem(
                                  context,
                                  cart,
                                  item,
                                ),
                              ),

                              const SizedBox(height: 25),

                              // =================================================
                              // CART TOTALS
                              // =================================================
                              _buildCartTotals(
                                context,
                                cart,
                                shippingCost,
                                total,
                              ),

                              const SizedBox(height: 25),

                              // =================================================
                              // CONTINUE SHOPPING
                              // =================================================
                              Center(
                                child: TextButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    size: 20,
                                  ),
                                  label: const Text(
                                    'Continue Shopping',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ========================================================================
  // CART ITEM
  // ========================================================================

  Widget _buildCartItem(
    BuildContext context,
    CartModel cart,
    CartItem item,
  ) {
    final product = item.product;

    final String image = product['image'] ?? '';
    final String brand = product['brand'] ?? '';
    final String name = product['name'] ?? '';
    final String unitPrice =
        '৳${item.unitPrice.toStringAsFixed(2)}';
    final String itemTotal =
        '৳${item.totalPrice.toStringAsFixed(2)}';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE3E3E3),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 700;

          if (isSmall) {
            return _buildMobileCartItem(
              context,
              cart,
              item,
              image,
              brand,
              name,
              unitPrice,
              itemTotal,
            );
          }

          return _buildDesktopCartItem(
            context,
            cart,
            item,
            image,
            brand,
            name,
            unitPrice,
            itemTotal,
          );
        },
      ),
    );
  }

  // ========================================================================
  // DESKTOP CART ITEM
  // ========================================================================

  Widget _buildDesktopCartItem(
    BuildContext context,
    CartModel cart,
    CartItem item,
    String image,
    String brand,
    String name,
    String unitPrice,
    String itemTotal,
  ) {
    return Row(
      children: [
        // Product image
        SizedBox(
          width: 120,
          height: 120,
          child: Image.asset(
            image,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.image_not_supported_outlined,
                size: 50,
                color: Colors.grey,
              );
            },
          ),
        ),

        const SizedBox(width: 28),

        // Product information
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (brand.isNotEmpty)
                Text(
                  brand.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: green,
                    letterSpacing: 1,
                  ),
                ),

              const SizedBox(height: 7),

              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 9),

              Text(
                unitPrice,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 20),

        // Total price
        SizedBox(
          width: 140,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                itemTotal,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '(${unitPrice} each)',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        // Quantity controls
        _quantityControls(
          cart,
          item,
        ),

        const SizedBox(width: 25),

        // Delete
        IconButton(
          onPressed: () {
            cart.remove(item);
          },
          tooltip: 'Remove item',
          icon: const Icon(
            Icons.delete_outline,
            color: Colors.red,
            size: 27,
          ),
        ),
      ],
    );
  }

  // ========================================================================
  // MOBILE CART ITEM
  // ========================================================================

  Widget _buildMobileCartItem(
    BuildContext context,
    CartModel cart,
    CartItem item,
    String image,
    String brand,
    String name,
    String unitPrice,
    String itemTotal,
  ) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 90,
              height: 90,
              child: Image.asset(
                image,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.image_not_supported_outlined,
                    size: 40,
                    color: Colors.grey,
                  );
                },
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (brand.isNotEmpty)
                    Text(
                      brand.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: green,
                        letterSpacing: 1,
                      ),
                    ),

                  const SizedBox(height: 5),

                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    unitPrice,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),

            IconButton(
              onPressed: () {
                cart.remove(item);
              },
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              itemTotal,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            _quantityControls(
              cart,
              item,
            ),
          ],
        ),
      ],
    );
  }

  // ========================================================================
  // QUANTITY CONTROLS
  // ========================================================================

  Widget _quantityControls(
    CartModel cart,
    CartItem item,
  ) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFDADADA),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              cart.decrease(item);
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 42,
              minHeight: 44,
            ),
            icon: const Icon(
              Icons.remove,
              size: 18,
            ),
          ),

          Container(
            width: 45,
            height: 45,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(
                  color: Color(0xFFDADADA),
                ),
              ),
            ),
            child: Text(
              '${item.quantity}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          IconButton(
            onPressed: () {
              cart.increase(item);
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 42,
              minHeight: 44,
            ),
            icon: const Icon(
              Icons.add,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  // ========================================================================
  // CART TOTALS
  // ========================================================================

  Widget _buildCartTotals(
    BuildContext context,
    CartModel cart,
    double shippingCost,
    double total,
  ) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 930,
        ),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFFDCDCDC),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CART TOTALS',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 25),

              // Total items
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Items',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${cart.totalItems} items',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Subtotal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Subtotal',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '৳${cart.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Shipping
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Shipping',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '৳${shippingCost.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Shipping to Dhaka.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 25),

              const Divider(),

              const SizedBox(height: 20),

              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'TOTAL',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    '৳${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // Checkout button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CheckoutPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  child: const Text(
                    'PROCEED TO CHECKOUT',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========================================================================
  // EMPTY CART
  // ========================================================================

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.shopping_bag_outlined,
              size: 80,
              color: Colors.black26,
            ),

            const SizedBox(height: 20),

            const Text(
              'YOUR CART IS EMPTY',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Add some products to your cart and they will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 35,
                  vertical: 15,
                ),
              ),
              child: const Text(
                'CONTINUE SHOPPING',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}