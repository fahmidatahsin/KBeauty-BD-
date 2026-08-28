import 'package:flutter/material.dart';

import 'cart_model.dart';
import 'cart_page.dart';
import 'product_detail_page.dart';

class BrandPage extends StatefulWidget {
  final String brand;
  final List<Map<String, String>> products;

  const BrandPage({
    super.key,
    required this.brand,
    required this.products,
  });

  @override
  State<BrandPage> createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  String searchText = '';
  String selectedCategory = 'All';
  String selectedSort = 'Default';

 List<Map<String, String>> get brandProducts {
  final result = widget.products.where((product) {
    final brandMatches =
    product['brand']?.toLowerCase() == widget.brand.toLowerCase();

    final categoryMatches =
        selectedCategory == 'All' ||
        product['category'] == selectedCategory;

    final searchMatches = product['name']!
        .toLowerCase()
        .contains(searchText.toLowerCase());

    return brandMatches && categoryMatches && searchMatches;
  }).toList();

  // Sort products by price
  if (selectedSort == 'Price: Low to High') {
    result.sort((a, b) {
      final priceA = double.tryParse(
            a['price']!
                .replaceAll('৳', '')
                .replaceAll(',', ''),
          ) ??
          double.infinity;

      final priceB = double.tryParse(
            b['price']!
                .replaceAll('৳', '')
                .replaceAll(',', ''),
          ) ??
          double.infinity;

      return priceA.compareTo(priceB);
    });
  }

  if (selectedSort == 'Price: High to Low') {
    result.sort((a, b) {
      final priceA = double.tryParse(
            a['price']!
                .replaceAll('৳', '')
                .replaceAll(',', ''),
          ) ??
          double.infinity;

      final priceB = double.tryParse(
            b['price']!
                .replaceAll('৳', '')
                .replaceAll(',', ''),
          ) ??
          double.infinity;

      return priceB.compareTo(priceA);
    });
  }

  return result;
}

  List<String> get categories {
    final categorySet = <String>{'All'};

    for (final product in widget.products) {
      if (product['brand'] == widget.brand &&
          product['category'] != null) {
        categorySet.add(product['category']!);
      }
    }

    return categorySet.toList();
  }

  void addToCart(Map<String, String> product) {
    if (product['price'] == 'SOLD OUT') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sorry, this product is sold out.'),
        ),
      );
      return;
    }

    CartScope.of(context).add(product, 1);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to cart.'),
      ),
    );
  }

  void openDetails(Map<String, String> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailPage(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 800;
    final columns = width >= 1150
        ? 4
        : width >= 750
            ? 3
            : 2;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F7),
      body: SafeArea(
        child: Column(
          children: [
            _header(isDesktop),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 44 : 20,
                  vertical: 30,
                ),
                children: [
                  Text(
                    widget.brand,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '${brandProducts.length} products available',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 28),

                  _searchAndFilters(isDesktop),

                  const SizedBox(height: 34),

                  if (brandProducts.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(50),
                      child: Center(
                        child: Text(
                          'No products found.',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: brandProducts.length,
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 28,
                        childAspectRatio:
                            width < 600 ? 0.52 : 0.60,
                      ),
                      itemBuilder: (context, index) {
                        final product = brandProducts[index];

                        return BrandProductCard(
                          product: product,
                          onDetails: () => openDetails(product),
                          onAddToCart: () => addToCart(product),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(bool isDesktop) {
    final cart = CartScope.of(context);

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 40 : 12,
        vertical: 16,
      ),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              size: 18,
            ),
            label: const Text(
              'BACK',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ),

          const Spacer(),

          Text(
            'K-BEAUTY BD',
            style: TextStyle(
              fontSize: isDesktop ? 34 : 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),

          const Spacer(),

          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CartPage(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                ),
              ),

              if (cart.totalItems > 0)
                Positioned(
                  right: 5,
                  top: 5,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.deepOrange,
                    child: Text(
                      '${cart.totalItems}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _searchAndFilters(bool isDesktop) {
    final searchBox = Container(
      width: isDesktop ? 360 : double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            searchText = value;
          });
        },
        decoration: const InputDecoration(
          hintText: 'Search this brand...',
          prefixIcon: Icon(
            Icons.search,
            color: Color(0xFF1C6A50),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: 17,
          ),
        ),
      ),
    );
    final sortDropdown = Container(
  width: isDesktop ? 360 : double.infinity,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    boxShadow: const [
      BoxShadow(
        color: Color(0x14000000),
        blurRadius: 12,
        offset: Offset(0, 4),
      ),
    ],
  ),
 child: DropdownButtonFormField<String>(
  value: selectedSort,
  decoration: const InputDecoration(
    prefixIcon: Icon(
      Icons.sort,
      color: Color(0xFF1C6A50),
    ),
    border: InputBorder.none,
    contentPadding: EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 4,
    ),
  ),
  selectedItemBuilder: (context) {
    return const [
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Sort By: Default',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Sort By: Price: Low to High',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Sort By: Price: High to Low',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    ];
  },
  items: const [
    DropdownMenuItem(
      value: 'Default',
      child: Text('Default'),
    ),
    DropdownMenuItem(
      value: 'Price: Low to High',
      child: Text('Price: Low to High'),
    ),
    DropdownMenuItem(
      value: 'Price: High to Low',
      child: Text('Price: High to Low'),
    ),
  ],
  onChanged: (value) {
    if (value == null) return;

    setState(() {
      selectedSort = value;
    });
  },
),
);

    final filters = Wrap(
      spacing: 10,
      runSpacing: 10,
      children: categories.map((category) {
        final selected = selectedCategory == category;

        return ChoiceChip(
          showCheckmark: false,
          selected: selected,
          selectedColor: const Color(0xFF1C6A50),
          backgroundColor: Colors.white,
          elevation: selected ? 3 : 0,
          pressElevation: 5,
          side: BorderSide(
            color: selected
                ? const Color(0xFF1C6A50)
                : const Color(0xFFE0E0E0),
          ),
          label: Text(
            category,
            style: TextStyle(
              color: selected
                  ? Colors.white
                  : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          onSelected: (_) {
            setState(() {
              selectedCategory = category;
            });
          },
        );
      }).toList(),
    );

 if (!isDesktop) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      searchBox,
      const SizedBox(height: 18),
      sortDropdown,
      const SizedBox(height: 18),
      filters,
    ],
  );
}

return Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    // LEFT SIDE: Search + Sort
    SizedBox(
      width: 450,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          searchBox,
          const SizedBox(height: 14),
          sortDropdown,
        ],
      ),
    ),

    const SizedBox(width: 34),

    // RIGHT SIDE: Category filters
    Expanded(
      child: filters,
    ),
  ],
);

 
  }
}

class BrandProductCard extends StatefulWidget {
  final Map<String, String> product;
  final VoidCallback onDetails;
  final VoidCallback onAddToCart;

  const BrandProductCard({
    super.key,
    required this.product,
    required this.onDetails,
    required this.onAddToCart,
  });

  @override
  State<BrandProductCard> createState() =>
      _BrandProductCardState();
}

class _BrandProductCardState
    extends State<BrandProductCard> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    final soldOut =
        widget.product['price'] == 'SOLD OUT';

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          hovering = true;
        });
      },
      onExit: (_) {
        setState(() {
          hovering = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 180,
        ),
        transform: Matrix4.translationValues(
          0,
          hovering ? -9 : 0,
          0,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: hovering ? 0.18 : 0.06,
              ),
              blurRadius: hovering ? 18 : 8,
              offset: Offset(
                0,
                hovering ? 10 : 4,
              ),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.asset(
                widget.product['image']!,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 14),

            Text(
              widget.product['name']!,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                height: 1.18,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              widget.product['rating']!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFFFC107),
                fontSize: 21,
                letterSpacing: 1,
              ),
            ),

            Text(
              widget.product['price']!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: soldOut
                    ? Colors.red
                    : Colors.black54,
              ),
            ),

            const SizedBox(height: 8),

            OutlinedButton(
              onPressed: widget.onDetails,
              child: const Text(
                'VIEW DETAILS',
              ),
            ),

            if (!soldOut)
              TextButton(
                onPressed: widget.onAddToCart,
                child: const Text(
                  'ADD TO CART',
                ),
              ),
          ],
        ),
      ),
    );
  }
}