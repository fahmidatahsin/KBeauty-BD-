
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<dynamic> orders = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  // ============================================================
  // LOAD ORDERS
  // ============================================================

  Future<void> _loadOrders() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final headers = await AuthService.getAuthHeaders();

      final response = await http.get(
        Uri.parse('${AuthService.baseUrl}/orders'),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (!mounted) return;

        setState(() {
          orders = List<dynamic>.from(data);
          isLoading = false;
        });
      } else {
        throw Exception(
          data['message'] ?? 'Failed to load orders',
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage =
            e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F3F1),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'MY ORDERS',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1C6A50),
              ),
            )
          : errorMessage != null
              ? _buildError()
              : orders.isEmpty
                  ? _buildEmpty()
                  : RefreshIndicator(
                      onRefresh: _loadOrders,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          return _buildOrderCard(
                            orders[index],
                          );
                        },
                      ),
                    ),
    );
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.shopping_bag_outlined,
              size: 70,
              color: Colors.black26,
            ),

            const SizedBox(height: 18),

            const Text(
              'No orders yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Your completed orders will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 55,
              color: Colors.redAccent,
            ),

            const SizedBox(height: 15),

            Text(
              errorMessage ?? 'Failed to load orders.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            FilledButton(
              onPressed: _loadOrders,
              child: const Text('TRY AGAIN'),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ORDER CARD
  // ============================================================

  Widget _buildOrderCard(
    Map<String, dynamic> order,
  ) {
    final orderId =
        order['_id']?.toString() ?? 'Unknown';

    final totalAmount =
        order['totalAmount']?.toString() ?? '0';

    final items =
        order['items'] is List
            ? List<dynamic>.from(order['items'])
            : <dynamic>[];

    final createdAt =
        order['createdAt']?.toString();

    String dateText = 'Date unavailable';

    if (createdAt != null) {
      try {
        final date = DateTime.parse(createdAt);

        dateText =
            '${date.day.toString().padLeft(2, '0')}/'
            '${date.month.toString().padLeft(2, '0')}/'
            '${date.year}';
      } catch (_) {}
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shopping_bag_outlined,
                color: Color(0xFF1C6A50),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  'Order #${orderId.length > 8 ? orderId.substring(orderId.length - 8) : orderId}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            'Date: $dateText',
            style: const TextStyle(
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 15),

          const Divider(),

          const SizedBox(height: 10),

          Text(
            'Items: ${items.length}',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          ...items.map(
            (item) => _buildOrderItem(item),
          ),

          const SizedBox(height: 12),

          const Divider(),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),

              Text(
                '৳$totalAmount',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: Color(0xFF1C6A50),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ORDER ITEM
  // ============================================================

  Widget _buildOrderItem(
    dynamic item,
  ) {
    if (item is! Map<String, dynamic>) {
      return const SizedBox.shrink();
    }

    final quantity =
        item['quantity']?.toString() ?? '0';

    final price =
        item['price']?.toString() ?? '0';

    final product = item['product'];

    String productName = 'Product';

    if (product is Map<String, dynamic>) {
      productName =
          product['name']?.toString() ??
          product['title']?.toString() ??
          'Product';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              productName,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),

          Text(
            'x$quantity',
            style: const TextStyle(
              color: Colors.black54,
            ),
          ),

          const SizedBox(width: 20),

          Text(
            '৳$price',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
