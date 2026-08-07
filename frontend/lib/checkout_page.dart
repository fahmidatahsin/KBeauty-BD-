import 'package:flutter/material.dart';
import 'cart_model.dart';

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

  String paymentMethod = "Cash on Delivery";

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);

    return Scaffold(
      body: Stack(
        children: [

          Positioned.fill(
            child: Image.asset(
              "assets/images/hero-banner-1.jpg",
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.45),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25),

                child: Container(
                  constraints: const BoxConstraints(maxWidth: 700),

                  padding: const EdgeInsets.all(30),

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.94),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 20,
                        color: Colors.black26,
                      )
                    ],
                  ),

                  child: Form(
                    key: _formKey,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

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

const Text(
  "Customer Information",
  style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 20),

TextFormField(
  controller: nameController,
  decoration: InputDecoration(
    labelText: "Full Name",
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    prefixIcon: const Icon(Icons.person),
  ),
  validator: (value) =>
      value!.isEmpty ? "Enter your name" : null,
),

const SizedBox(height: 18),

TextFormField(
  controller: phoneController,
  keyboardType: TextInputType.phone,
  decoration: InputDecoration(
    labelText: "Phone Number",
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    prefixIcon: const Icon(Icons.phone),
  ),
  validator: (value) =>
      value!.isEmpty ? "Enter phone number" : null,
),

const SizedBox(height: 18),

TextFormField(
  controller: emailController,
  decoration: InputDecoration(
    labelText: "Email (Optional)",
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    prefixIcon: const Icon(Icons.email),
  ),
),

const SizedBox(height: 18),

TextFormField(
  controller: addressController,
  maxLines: 3,
  decoration: InputDecoration(
    labelText: "Shipping Address",
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    prefixIcon: const Icon(Icons.location_on),
  ),
  validator: (value) =>
      value!.isEmpty ? "Enter address" : null,
),

const SizedBox(height: 35),

const Text(
  "Payment Method",
  style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 15),

RadioListTile(
  value: "Cash on Delivery",
  groupValue: paymentMethod,
  title: const Text("Cash on Delivery"),
  onChanged: (value) {
    setState(() {
      paymentMethod = value!;
    });
  },
),

RadioListTile(
  value: "bKash",
  groupValue: paymentMethod,
  title: const Text("bKash"),
  onChanged: (value) {
    setState(() {
      paymentMethod = value!;
    });
  },
),

RadioListTile(
  value: "Nagad",
  groupValue: paymentMethod,
  title: const Text("Nagad"),
  onChanged: (value) {
    setState(() {
      paymentMethod = value!;
    });
  },
),

RadioListTile(
  value: "Credit / Debit Card",
  groupValue: paymentMethod,
  title: const Text("Credit / Debit Card"),
  onChanged: (value) {
    setState(() {
      paymentMethod = value!;
    });
  },
),

const SizedBox(height: 35),const Text(
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

      if (cart.items.isEmpty)
        const Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            "Your cart is empty.",
            style: TextStyle(fontSize: 16),
          ),
        ),

      ...cart.items.map(
        (item) => Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  item.product['image'] ?? '',
                  width: 65,
                  height: 65,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 15),

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

                    const SizedBox(height: 5),

                    Text(
                      "Quantity: ${item.quantity}",
                    ),

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
        ),
      ),

      const Divider(height: 35),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

      const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Delivery",
            style: TextStyle(fontSize: 17),
          ),
          Text(
            "৳80",
            style: TextStyle(fontSize: 17),
          ),
        ],
      ),

      const Divider(height: 35),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

SizedBox(
  width: double.infinity,

  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF1C6A50),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    onPressed: () {

      if (!_formKey.currentState!.validate()) {
        return;
      }

      if (cart.items.isEmpty) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Your cart is empty."),
          ),
        );

        return;
      }

      showDialog(
        context: context,

        builder: (_) => AlertDialog(

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),

          title: const Text("Order Confirmed 🎉"),

          content: Text(
            "Thank you ${nameController.text}!\n\n"
            "Your order has been placed successfully.\n\n"
            "Payment Method:\n$paymentMethod",
          ),

          actions: [

            TextButton(
              onPressed: () {

                cart.clear();

Navigator.pop(context); // Close dialog
Navigator.pop(context); // Return to previous page

              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    },

    child: const Text(
      "PLACE ORDER",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),                      ],
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