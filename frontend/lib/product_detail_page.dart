import 'package:flutter/material.dart';
import 'cart_model.dart';

class ProductDetailPage extends StatefulWidget {
  final Map<String, String> product;

  const ProductDetailPage({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final TextEditingController quantityController =
      TextEditingController(text: '1');

  bool get isSoldOut => widget.product['price'] == 'SOLD OUT';

  String get description {
    final name = widget.product['name'] ?? '';

    if (name.contains('Pad')) {
      return 'Hydrating toner pads that gently refresh the skin and help prepare it for the next steps in your skincare routine.';
    }

    if (name.contains('Sun Cream')) {
      return 'A lightweight daily sunscreen that helps protect your skin while leaving it feeling soft, hydrated, and comfortable.';
    }

    if (name.contains('Foam')) {
      return 'A gentle foaming cleanser that removes daily impurities while helping your skin feel clean and refreshed.';
    }

    return 'A gentle skincare product designed to cleanse, hydrate, and support healthy-looking skin every day.';
  }

 void buyProduct() {
  if (isSoldOut) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sorry, this product is sold out.'),
      ),
    );
    return;
  }

  final quantity = int.tryParse(quantityController.text) ?? 1;

  if (quantity <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter a valid quantity.'),
      ),
    );
    return;
  }

  CartScope.of(context).add(widget.product, quantity);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('$quantity item(s) added to your cart.'),
    ),
  );
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
    final productPrice = widget.product['price'] ?? '';

    final productDetails = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          productName,
          style: const TextStyle(
            fontSize: 31,
            fontWeight: FontWeight.w900,
            height: 1.18,
          ),
        ),
        const SizedBox(height: 18),

        Text(
  widget.product['brand'] ?? '',
  style: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: Color(0xFF1C6A50),
    letterSpacing: 1,
  ),
),
const SizedBox(height: 8),

        Text(
          productPrice,
          style: TextStyle(
            fontSize: 26,
            color: isSoldOut ? Colors.red : const Color(0xFFE53935),
          ),
        ),
        const SizedBox(height: 25),
        Text(
          description,
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFF424242),
            height: 1.55,
          ),
        ),
        const SizedBox(height: 30),
        const Text(
          'Suitable for all skin types / Made in Korea',
          style: TextStyle(
            fontSize: 17,
            color: Color(0xFF4B4B4B),
          ),
        ),
        const SizedBox(height: 34),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 16,
          runSpacing: 12,
          children: [
            const Text(
              'Quantity:',
              style: TextStyle(fontSize: 19),
            ),
            SizedBox(
              width: 100,
              height: 52,
              child: TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 54,
              child: FilledButton(
                onPressed: buyProduct,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                ),
                child: Text(
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
            Container(
              height: 82,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 38),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Home',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
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
                  const SizedBox(width: 70),
                ],
              ),
            ),
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
                                Expanded(flex: 2, child: productDetails),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 360,
                                  width: double.infinity,
                                  child: Image.asset(
                                    widget.product['image'] ?? '',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(height: 30),
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