import 'package:flutter/material.dart';
import 'catalog_page.dart';
import 'cart_model.dart';
import 'cart_page.dart';
import 'brand_page.dart';

final CartModel appCart = CartModel();
void main() {
  runApp(const KBeautyApp());
}

class KBeautyApp extends StatelessWidget {
  const KBeautyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CartScope(
  cart: appCart,
  child: MaterialApp(
      title: 'K-BEAUTY BD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F3F1),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1C6A50),
        ),
      ),
      home: const HomePage(),
  )
    );
  }
}

class Product {
  final String name;
  final String price;
  final String image;
  final bool soldOut;
  final bool vegan;
  final bool newArrival;

  const Product({
    required this.name,
    required this.price,
    required this.image,
    this.soldOut = false,
    this.vegan = false,
    this.newArrival = false,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  String searchText = '';

  final products = const [
    Product(
      name: 'Bonajour Ginger Aqua Relief Pad 60 Pads',
      price: '৳1,700.00',
      image: 'assets/images/GinerReliefPad.jpg',
      vegan: true,
      newArrival: true,
    ),
    Product(
      name: 'Bonajour Jeju Milk Soft Foaming Cleanser 160ml',
      price: '৳1,700.00',
      image: 'assets/images/boanjourFoamingCleanser.webp',
    ),
    Product(
      name: 'Bonajour Ginger Aqua Relief Sun Cream 40ml',
      price: '৳1,700.00',
      image: 'assets/images/bonajourGingercream.png',
    ),
    Product(
      name: 'Bonajour Ginger Aqua Relief Foam Cleanser',
      price: 'SOLD OUT',
      image: 'assets/images/Bonajour Ginger Aqua Relief Foam Cleanser.jpg',
      soldOut: true,
      newArrival: true,
    ),
  ];

  List<Product> get visibleProducts {
    return products
        .where(
          (product) =>
              product.name.toLowerCase().contains(searchText.toLowerCase()),
        )
        .toList();
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

void addToCart(Product product) {
  if (product.soldOut) {
    showMessage('Sorry, this product is sold out.');
    return;
  }

  appCart.add(
    {
      'name': product.name,
      'price': product.price,
      'image': product.image,
    },
    1,
  );

  setState(() {});

  showMessage('${product.name} added to cart.');
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 850;

          return SingleChildScrollView(
            child: Column(
              children: [
                if (isDesktop) _desktopHeader() else _mobileHeader(),
                _hero(isDesktop),
                _intro(),
                _brandFilters(),
                _productSection(constraints.maxWidth),
                _footer(isDesktop),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _desktopHeader() {
  return Container(
    color: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
    child: Row(
  children: [

    // Left section
    SizedBox(
      width: 300,
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextButton(
          onPressed: () {},
          child: const Text(
            "LOGIN",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    ),

    // Center logo
    const Expanded(
      child: Center(
        child: Text(
          "K-BEAUTY BD",
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
      ),
    ),

    // Right section
    SizedBox(
      width: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 230,
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          _cartButton(),
        ],
      ),
    ),
  ],
),
  );
}

  Widget _mobileHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 8),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
 onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const CatalogPage(),
    ),
  );
},
  icon: const Icon(Icons.shopping_bag_outlined),
),
              const Expanded(
                child: Text(
                  'K-BEAUTY BD',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _cartButton(),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            onChanged: (value) => setState(() => searchText = value),
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFFF1F1F1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget _cartButton() {
  return Stack(
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
        icon: const Icon(Icons.shopping_bag_outlined),
      ),
      if (appCart.totalItems > 0)
        Positioned(
          top: 4,
          right: 4,
          child: CircleAvatar(
            radius: 8,
            backgroundColor: Colors.deepOrange,
            child: Text(
              '$appCart.totalItems',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
          ),
        ),
    ],
  );
}

  Widget _hero(bool isDesktop) {
    return SizedBox(
      width: double.infinity,
      height: isDesktop ? 380 : 240,
      child: Image.asset(
        'assets/images/hero-banner-1.jpg',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _intro() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(32, 1, 32, 42),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'START YOUR SKIN CARE JOURNEY',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Color(0xFF303030),
            ),
          ),
          SizedBox(height: 18),
          Text(
            "Skin care is a personal journey and we're here to guide you along the way.",
            style: TextStyle(fontSize: 19, color: Color(0xFF3F3F3F)),
          ),
        ],
      ),
    );
  }

 Widget _brandFilters() {
  const brands = [
    'ALL',
    'DEAR KLAIRS',
    'SKIN1004',
    'AXIS-Y',
    'BEAUTY OF JOSEON',
    'BY WISHTREND',
    'BONAJOUR',
  ];

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
    child: Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 8,
      children: brands.map((brand) {
        return TextButton(
 onPressed: () {
  if (brand == 'ALL') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CatalogPage(),
      ),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BrandPage(
          brand: brand,
          products: allProducts,
        ),
      ),
    );
  }
},
          child: Text(
            brand,
            style: TextStyle(
              color: Colors.blue.shade800,
              decoration: TextDecoration.underline,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        );
      }).toList(),
    ),
  );
}

  Widget _productSection(double width) {
    final isMobile = width < 650;
    final columns = width >= 1200 ? 4 : width >= 750 ? 3 : 2;

    return Container(
      constraints: const BoxConstraints(maxWidth: 1500),
      padding: const EdgeInsets.all(28),
      child: visibleProducts.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(50),
              child: Text(
                'No products found.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: visibleProducts.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 22,
                mainAxisSpacing: 30,
                childAspectRatio: isMobile ? 0.54 : 0.65,
              ),
              itemBuilder: (context, index) {
                return _productCard(visibleProducts[index]);
              },
            ),
    );
  }
Widget _productCard(Product product) {
  return _HomeProductCard(
    product: product,
    onTap: () =>
        showMessage('${product.name} details page comes next.'),
    onAddToCart: () => addToCart(product),
  );
}

  Widget _footer(bool isDesktop) {
    const footerSections = {
      'CUSTOMER SERVICE': [
        'Help & Contact Us',
        'Terms & Conditions',
        'Refund & Return Policy',
        'Showroom Address',
      ],
      'COMPANY': ['Wholesale Inquiries', 'Our Services', 'Privacy Policy'],
      'SOCIAL MEDIA': ['Facebook', 'Instagram', 'Twitter'],
      'PROFILE': ['My Account', 'Checkout', 'Wishlist', 'Cart'],
    };

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 40),
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        runSpacing: 30,
        children: footerSections.entries.map((section) {
          return SizedBox(
            width: isDesktop ? 220 : 160,
            child: Column(
              children: [
                Text(
                  section.key,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 15),
                ...section.value.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      item,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class Badge extends StatelessWidget {
  final String text;
  final Color color;

  const Badge({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 27,
      backgroundColor: color,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
class _HomeProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  const _HomeProductCard({
    required this.product,
    required this.onTap,
    required this.onAddToCart,
  });

  @override
  State<_HomeProductCard> createState() => _HomeProductCardState();
}

class _HomeProductCardState extends State<_HomeProductCard> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => hovering = true);
      },
      onExit: (_) {
        setState(() => hovering = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(
          0,
          hovering ? -9 : 0,
          0,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      product.image,
                      fit: BoxFit.contain,
                    ),
                  ),

                  if (product.vegan)
                    const Positioned(
                      top: 10,
                      left: 10,
                      child: Badge(
                        text: 'Vegan',
                        color: Color(0xFF167C59),
                      ),
                    ),

                  if (product.newArrival)
                    const Positioned(
                      top: 66,
                      left: 10,
                      child: Badge(
                        text: 'New',
                        color: Color(0xFF5635A8),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Text(
              product.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              product.price,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: product.soldOut
                    ? Colors.red.shade700
                    : Colors.black54,
              ),
            ),

            const SizedBox(height: 8),

            OutlinedButton(
              onPressed: widget.onTap,
              child: const Text('VIEW DETAILS'),
            ),

            if (!product.soldOut)
              TextButton(
                onPressed: widget.onAddToCart,
                child: const Text('ADD TO CART'),
              ),
          ],
        ),
      ),
    );
  }
}