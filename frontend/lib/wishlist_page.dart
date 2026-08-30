import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<dynamic> products = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  // ============================================================
  // LOAD WISHLIST
  // ============================================================

  Future<void> _loadWishlist() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final headers = await AuthService.getAuthHeaders();

      final response = await http.get(
        Uri.parse('${AuthService.baseUrl}/wishlist'),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (!mounted) return;

        setState(() {
          products = data['products'] is List
              ? List<dynamic>.from(data['products'])
              : [];
          isLoading = false;
        });
      } else {
        throw Exception(
          data['message'] ?? 'Failed to load wishlist',
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
  // REMOVE PRODUCT
  // ============================================================

  Future<void> _removeFromWishlist(
    String productId,
  ) async {
    try {
      final headers = await AuthService.getAuthHeaders();

      final response = await http.delete(
        Uri.parse(
          '${AuthService.baseUrl}/wishlist/$productId',
        ),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (!mounted) return;

        setState(() {
          products.removeWhere(
            (product) =>
                product is Map<String, dynamic> &&
                product['_id']?.toString() == productId,
          );
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Removed from wishlist.',
            ),
          ),
        );
      } else {
        throw Exception(
          data['message'] ??
              'Failed to remove product',
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
              'Exception: ',
              '',
            ),
          ),
        ),
      );
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
          'WISHLIST',
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
              : products.isEmpty
                  ? _buildEmpty()
                  : RefreshIndicator(
                      onRefresh: _loadWishlist,
                      child: GridView.builder(
                        padding:
                            const EdgeInsets.all(20),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: products.length,
                        itemBuilder:
                            (context, index) {
                          return _buildProductCard(
                            products[index],
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
              Icons.favorite_border,
              size: 70,
              color: Colors.black26,
            ),

            const SizedBox(height: 18),

            const Text(
              'Your wishlist is empty',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Products you add to your wishlist '
              'will appear here.',
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
              errorMessage ??
                  'Failed to load wishlist.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            FilledButton(
              onPressed: _loadWishlist,
              child: const Text('TRY AGAIN'),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PRODUCT IMAGE
  // ============================================================

  Widget _buildProductImage(String image) {
    final value = image.trim();

    if (value.isEmpty) {
      return const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 50,
          color: Colors.black26,
        ),
      );
    }

    if (value.startsWith('http://') || value.startsWith('https://')) {
      return Image.network(
        value,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            size: 50,
            color: Colors.black26,
          ),
        ),
      );
    }

    // Backend returns paths such as: assets/images/Foo.jpg
    // These are Flutter assets, not network URLs.
    return Image.asset(
      value,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 50,
          color: Colors.black26,
        ),
      ),
    );
  }

  // ============================================================
  // PRODUCT CARD
  // ============================================================

  Widget _buildProductCard(
    dynamic product,
  ) {
    if (product is! Map<String, dynamic>) {
      return const SizedBox.shrink();
    }

    final productId =
        product['_id']?.toString() ?? '';

    final name =
        product['name']?.toString() ??
        product['title']?.toString() ??
        'Product';

    final price =
        product['price']?.toString() ?? '0';

    final image =
        product['image']?.toString() ?? '';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F6),
                    borderRadius:
                        const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                  ),
                  child: image.isNotEmpty
                      ? ClipRRect(
                          borderRadius:
                              const BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                          child: _buildProductImage(image),
                        )
                      : const Icon(
                          Icons.image_outlined,
                          size: 50,
                          color: Colors.black26,
                        ),
                ),

                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    child: IconButton(
                      tooltip: 'Remove',
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      onPressed: productId.isEmpty
                          ? null
                          : () {
                              _removeFromWishlist(
                                productId,
                              );
                            },
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  '৳$price',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: Color(0xFF1C6A50),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

