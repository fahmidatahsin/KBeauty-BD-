import 'package:flutter/material.dart';
import 'cart_model.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: cart.items.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 70,
                    color: Colors.black38,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Your cart is empty.',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                ...cart.items.map(
                  (item) => Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 85,
                            height: 85,
                            child: Image.asset(
                              item.product['image'] ?? '',
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product['name'] ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text('৳${item.totalPrice.toStringAsFixed(2)}'),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => cart.decrease(item),
                                      icon: const Icon(Icons.remove_circle_outline),
                                    ),
                                    Text(
                                      '${item.quantity}',
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => cart.increase(item),
                                      icon: const Icon(Icons.add_circle_outline),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => cart.remove(item),
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Total: ৳${cart.totalPrice.toStringAsFixed(2)}',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton(
   onPressed: () {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Checkout page coming soon!'),
    ),
  );
},
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text('PROCEED TO CHECKOUT'),
                  ),
                ),
              ],
            ),
    );
  }
}