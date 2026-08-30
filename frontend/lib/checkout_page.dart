import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'cart_model.dart';
import 'auth_service.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  bool _placingOrder = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    final cart = CartScope.of(context);

    // Validate customer information
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check empty cart
    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Your cart is empty.")));
      return;
    }

    // Prevent double click
    if (_placingOrder) {
      return;
    }

    setState(() {
      _placingOrder = true;
    });

    try {
      // ============================================================
      // GET AUTH HEADERS
      // ============================================================

      final headers = await AuthService.getAuthHeaders();

      // ============================================================
      // PLACE ORDER
      // ============================================================

      final response = await http.post(
        Uri.parse('${AuthService.baseUrl}/orders'),
        headers: headers,
        body: jsonEncode({
          'customerName': nameController.text.trim(),
          'address': addressController.text.trim(),
          'contactNo': phoneController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      // ============================================================
      // CHECK RESPONSE
      // ============================================================

      if (response.statusCode != 201) {
        throw Exception(data['message'] ?? 'Failed to place order');
      }

      // ============================================================
      // ORDER SUCCESS
      // ============================================================

      // Backend has already created the order.
      // Now clear the local/backend cart.
      await cart.clearCart();

      if (!mounted) return;

      // ============================================================
      // SHOW CONFIRMATION
      // ============================================================

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text(
              "Order Confirmed 🎉",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(
              "Thank you ${nameController.text}!\n\n"
              "Your order has been placed successfully.\n\n"
              "Payment Method:\n"
              "Cash on Delivery",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to place order: ${e.toString().replaceFirst('Exception: ', '')}",
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _placingOrder = false;
        });
      }
    }
  }

  Widget _productImage(String image) {
    if (image.isEmpty) {
      return const Icon(
        Icons.image_not_supported_outlined,
        size: 55,
        color: Colors.black26,
      );
    }

    if (image.startsWith('http://') || image.startsWith('https://')) {
      return Image.network(
        image,
        width: 65,
        height: 65,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.image_not_supported_outlined,
            size: 55,
            color: Colors.black26,
          );
        },
      );
    }

    return Image.asset(
      image,
      width: 65,
      height: 65,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(
          Icons.image_not_supported_outlined,
          size: 55,
          color: Colors.black26,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              "assets/images/hero-banner-1.jpg",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: const Color(0xFFF5F5F5));
              },
            ),
          ),

          // Dark overlay
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.45)),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 700),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.94),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(blurRadius: 20, color: Colors.black26),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // =========================
                        // CHECKOUT TITLE
                        // =========================

                        const Center(
                          child: Text(
                            "Checkout",
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1C6A50),
                            ),
                          ),
                        ),

                        const SizedBox(height: 35),

                        // =========================
                        // CUSTOMER INFORMATION
                        // =========================
                        const Text(
                          "Customer Information",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Full Name
                        TextFormField(
                          controller: nameController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: "Full Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Enter your name";
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 18),

                        // Phone
                        TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: "Phone Number",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.phone),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Enter phone number";
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 18),

                        // Email
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: "Email (Optional)",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.email),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Shipping Address
                        TextFormField(
                          controller: addressController,
                          maxLines: 3,
                          textInputAction: TextInputAction.newline,
                          decoration: InputDecoration(
                            labelText: "Shipping Address",
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.location_on),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Enter address";
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 35),

                        // =========================
                        // PAYMENT METHOD
                        // =========================
                        const Text(
                          "Payment Method",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        /*
                         * ONLY CASH ON DELIVERY
                         *
                         * bKash, Nagad and Card have been removed.
                         */
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F8F6),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF1C6A50),
                              width: 1.2,
                            ),
                          ),
                          child: const RadioListTile<String>(
                            value: "Cash on Delivery",
                            groupValue: "Cash on Delivery",
                            title: Text(
                              "Cash on Delivery",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            secondary: Icon(
                              Icons.payments_outlined,
                              color: Color(0xFF1C6A50),
                            ),
                            onChanged: null,
                          ),
                        ),

                        const SizedBox(height: 35),

                        // =========================
                        // ORDER SUMMARY
                        // =========================
                        const Text(
                          "Order Summary",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 18),

                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              // Empty cart
                              if (cart.items.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Text(
                                    "Your cart is empty.",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),

                              // Cart items
                              ...cart.items.map((item) {
                                final product = item.product;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: SizedBox(
                                          width: 65,
                                          height: 65,
                                          child: _productImage(
                                            product['image'] ?? '',
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 15),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product['name'] ?? '',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),

                                            const SizedBox(height: 5),

                                            Text("Quantity: ${item.quantity}"),

                                            const SizedBox(height: 3),

                                            Text(
                                              "৳${item.totalPrice.toStringAsFixed(2)}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),

                              const Divider(height: 35),

                              // Subtotal
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Subtotal",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  Text(
                                    "৳${cart.totalPrice.toStringAsFixed(2)}",
                                    style: const TextStyle(fontSize: 17),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Delivery
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Delivery",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  Text("৳80", style: TextStyle(fontSize: 17)),
                                ],
                              ),

                              const Divider(height: 35),

                              // Total
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "TOTAL",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                  Text(
                                    "৳${(cart.totalPrice + 80).toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Color(0xFF1C6A50),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 35),

                        // =========================
                        // PLACE ORDER BUTTON
                        // =========================
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1C6A50),
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: const Color(0xFF9FBDB2),
                              disabledForegroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _placingOrder ? null : _placeOrder,
                            child: _placingOrder
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    "PLACE ORDER",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
