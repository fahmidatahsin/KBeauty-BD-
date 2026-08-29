import 'package:flutter/material.dart';
import 'cart_model.dart';

class ProductDetailPage extends StatefulWidget {
  final Map<String, String> product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final TextEditingController quantityController = TextEditingController(
    text: '1',
  );

  bool isAddingToCart = false;

  bool get isSoldOut => widget.product['price'] == 'SOLD OUT';

  String get description {
    final name = widget.product['name'] ?? '';

    if (name.contains('Pad')) {
      return 'Hydrating toner pads that gently refresh the skin and help prepare it for the next steps in your skincare routine.';
    }

    if (name.contains('Sun Cream') ||
        name.contains('Sun Stick') ||
        name.contains('Sunscreen') ||
        name.contains('Sun Serum')) {
      return 'A lightweight daily sunscreen that helps protect your skin while leaving it feeling soft, hydrated, and comfortable.';
    }

    if (name.contains('Foam') ||
        name.contains('Cleanser') ||
        name.contains('Cleansing')) {
      return 'A gentle cleanser that removes daily impurities while helping your skin feel clean, refreshed, and comfortable.';
    }

    if (name.contains('Serum') || name.contains('Ampoule')) {
      return 'A nourishing skincare treatment designed to hydrate, improve the appearance of the skin, and support a healthy-looking complexion.';
    }

    if (name.contains('Cream') ||
        name.contains('Moisturizer') ||
        name.contains('Mask')) {
      return 'A moisturizing skincare product designed to nourish the skin, improve hydration, and support a soft and healthy-looking complexion.';
    }

    if (name.contains('Toner') || name.contains('Water')) {
      return 'A refreshing skincare product that helps hydrate and prepare the skin for the next steps in your skincare routine.';
    }

    return 'A carefully selected Korean skincare product designed to support a healthy, hydrated, and balanced-looking complexion.';
  }

  // ===============================
  // ADD PRODUCT TO CART
  // ===============================

  Future<void> buyProduct() async {
    if (isSoldOut) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sorry, this product is sold out.')),
      );
      return;
    }

    final quantity = int.tryParse(quantityController.text) ?? 1;

    if (quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid quantity.')),
      );
      return;
    }

    // Check Product ID
    final productId = widget.product['id'] ?? '';

    if (productId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Product ID is missing.')));
      return;
    }

    if (isAddingToCart) return;

    setState(() {
      isAddingToCart = true;
    });

    try {
      await CartScope.of(context).add(widget.product, quantity);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$quantity item(s) added to your cart.')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product to cart: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isAddingToCart = false;
        });
      }
    }
  }

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 800;

    final productName = widget.product['name'] ?? '';
    final productBrand = widget.product['brand'] ?? '';
    final productPrice = widget.product['price'] ?? '';
    final productRating = widget.product['rating'] ?? '';

    final productDetails = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ===============================
        // BRAND
        // ===============================

        Text(
          productBrand,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1C6A50),
            letterSpacing: 1.2,
          ),
        ),

        const SizedBox(height: 10),

        // ===============================
        // PRODUCT NAME
        // ===============================
        Text(
          productName,
          style: const TextStyle(
            fontSize: 31,
            fontWeight: FontWeight.w900,
            height: 1.18,
          ),
        ),

        const SizedBox(height: 14),

        // ===============================
        // RATING
        // ===============================
        Row(
          children: [
            Text(
              productRating,
              style: const TextStyle(
                color: Color(0xFFFFC107),
                fontSize: 23,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Customer Rating',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        // ===============================
        // PRICE
        // ===============================
        Text(
          productPrice,
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w800,
            color: isSoldOut ? Colors.red : const Color(0xFFE53935),
          ),
        ),

        const SizedBox(height: 25),

        const Divider(thickness: 1, color: Color(0xFFE5E5E5)),

        const SizedBox(height: 25),

        // ===============================
        // DESCRIPTION TITLE
        // ===============================
        const Text(
          'PRODUCT DESCRIPTION',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),

        const SizedBox(height: 12),

        // ===============================
        // DESCRIPTION
        // ===============================
        Text(
          description,
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFF424242),
            height: 1.55,
          ),
        ),

        const SizedBox(height: 25),

        // ===============================
        // PRODUCT INFORMATION
        // ===============================
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8F6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            children: [
              Icon(Icons.verified_outlined, color: Color(0xFF1C6A50)),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Suitable for all skin types / Made in Korea',
                  style: TextStyle(fontSize: 16, color: Color(0xFF4B4B4B)),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // ===============================
        // QUANTITY + BUY
        // ===============================
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 16,
          runSpacing: 12,
          children: [
            const Text(
              'Quantity:',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
            ),

            SizedBox(
              width: 100,
              height: 52,
              child: TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                enabled: !isAddingToCart,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ),

            SizedBox(
              height: 54,
              child: FilledButton(
                onPressed: isSoldOut || isAddingToCart ? null : buyProduct,
                style: FilledButton.styleFrom(
                  backgroundColor: isSoldOut ? Colors.grey : Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                ),
                child: isAddingToCart
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        isSoldOut ? 'SOLD OUT' : 'BUY',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ],
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F5),

      body: SafeArea(
        child: Column(
          children: [
            // ===============================
            // HEADER
            // ===============================

            Container(
              height: 82,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 38),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    label: const Text(
                      'BACK',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const Spacer(),

                  const Text(
                    'K-BEAUTY BD',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),

                  const Spacer(),

                  const SizedBox(width: 90),
                ],
              ),
            ),

            // ===============================
            // CONTENT
            // ===============================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(28),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1360),
                    child: Container(
                      padding: EdgeInsets.all(isDesktop ? 60 : 28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x26000000),
                            blurRadius: 14,
                            offset: Offset(0, 7),
                          ),
                        ],
                      ),
                      child: isDesktop
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // PRODUCT IMAGE

                                Expanded(
                                  child: SizedBox(
                                    height: 480,
                                    child: Image.asset(
                                      widget.product['image'] ?? '',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 70),

                                // PRODUCT INFORMATION
                                Expanded(flex: 2, child: productDetails),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // PRODUCT IMAGE

                                SizedBox(
                                  height: 360,
                                  width: double.infinity,
                                  child: Image.asset(
                                    widget.product['image'] ?? '',
                                    fit: BoxFit.contain,
                                  ),
                                ),

                                const SizedBox(height: 30),

                                // PRODUCT INFORMATION
                                productDetails,
                              ],
                            ),
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
}
