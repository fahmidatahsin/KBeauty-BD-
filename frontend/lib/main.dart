import 'package:flutter/material.dart';
import 'catalog_page.dart';
import 'cart_model.dart';
import 'cart_page.dart';
import 'brand_page.dart';
import 'product_detail_page.dart';
import 'login_page.dart';
import 'admin_login_page.dart';
import 'profile_page.dart';
import 'auth_service.dart';
import 'brand_service.dart';
import 'services/product_service.dart';


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
      ),
    );
  }
}

class Product {
  final String name;
  final String brand;
  final String price;
  final String image;
  final String rating;
  final bool soldOut;
  final bool vegan;
  final bool newArrival;

  const Product({
    required this.name,
    required this.brand,
    required this.price,
    required this.image,
    required this.rating,
    this.soldOut = false,
    this.vegan = false,
    this.newArrival = false,
  });

  factory Product.fromMap(Map<String, dynamic> product) {
    final dynamic rawPrice = product['price'];
    final priceText = rawPrice?.toString() ?? '';

    return Product(
      name: product['name']?.toString() ?? '',
      brand: _getBrandName(product['brand']),
      price: _formatPrice(priceText),
      image: product['image']?.toString() ??
          product['imageUrl']?.toString() ??
          '',
      rating: _getRating(product['rating']),
      soldOut: product['soldOut'] == true ||
          product['stock'] == 0 ||
          priceText.toUpperCase() == 'SOLD OUT',
      vegan: product['vegan'] == true,
      newArrival: product['newArrival'] == true ||
          product['isNew'] == true,
    );
  }

  static String _getBrandName(dynamic brand) {
    if (brand is Map) {
      return brand['name']?.toString() ?? '';
    }
    return brand?.toString() ?? '';
  }

  static String _formatPrice(String price) {
    if (price.isEmpty) return '';

    if (price.toUpperCase() == 'SOLD OUT') {
      return 'SOLD OUT';
    }

    if (price.contains('৳')) {
      return price;
    }

    final number = double.tryParse(price);
    if (number != null) {
      return '৳${number.toStringAsFixed(2)}';
    }

    return price;
  }

  static String _getRating(dynamic rating) {
    if (rating == null) return '★★★★★';

    if (rating is num) {
      final rounded = rating.round().clamp(0, 5);
      return '${'★' * rounded}${'☆' * (5 - rounded)}';
    }

    final text = rating.toString();
    if (text.contains('★') || text.contains('☆')) return text;

    final number = double.tryParse(text);
    if (number != null) {
      final rounded = number.round().clamp(0, 5);
      return '${'★' * rounded}${'☆' * (5 - rounded)}';
    }

    return '★★★★★';
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchText = '';
  bool isLoggedIn = false;

  List<String> brands = [];
  List<Product> products = [];

  bool isLoadingBrands = true;
  bool isLoadingProducts = true;
  String? productError;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _loadBrands();
    _loadProducts();
  }

  Future<void> _checkLoginStatus() async {
    final loggedIn = await AuthService.isLoggedIn();

    if (!mounted) return;

    setState(() {
      isLoggedIn = loggedIn;
    });
  }

  Future<void> _loadBrands() async {
    try {
      final loadedBrands = await BrandService.getBrands();

      if (!mounted) return;

      setState(() {
        brands = loadedBrands;
        isLoadingBrands = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isLoadingBrands = false;
      });
    }
  }

  Future<void> _loadProducts() async {
    setState(() {
      isLoadingProducts = true;
      productError = null;
    });

    try {
      final loadedProducts = await ProductService.getProducts();

      if (!mounted) return;

      setState(() {
        products = loadedProducts
            .map<Product>((product) => Product.fromMap(product))
            .toList();
        isLoadingProducts = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        productError = error.toString();
        isLoadingProducts = false;
      });
    }
  }

  Future<bool> openLoginPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );

    if (result == true && mounted) {
      setState(() {
        isLoggedIn = true;
      });
      return true;
    }

    return false;
  }

 List<Product> get visibleProducts {
  if (searchText.trim().isEmpty) {
    return [];
  }

  final query = searchText.trim().toLowerCase();

  return products.where((product) {
    return product.name.toLowerCase().contains(query) ||
        product.brand.toLowerCase().contains(query);
  }).toList();
}

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> addToCart(Product product) async {
    if (product.soldOut) {
      showMessage('Sorry, this product is sold out.');
      return;
    }

    final loggedIn = await AuthService.isLoggedIn();

    if (!loggedIn) {
      final loginSuccess = await openLoginPage();

      if (!loginSuccess) return;
    }

    appCart.add({
      'name': product.name,
      'brand': product.brand,
      'price': product.price,
      'image': product.image,
      'rating': product.rating,
    }, 1);

    if (!mounted) return;

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

                if (searchText.trim().isEmpty) ...[
                  _hero(isDesktop),
                  _intro(),
                  _brandFilters(),
                ],

                if (searchText.trim().isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.fromLTRB(32, 30, 32, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'SEARCH RESULTS',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),

                if (searchText.trim().isNotEmpty)
  _productSection(constraints.maxWidth),
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
          SizedBox(
  width: 180,
  child: Align(
    alignment: Alignment.centerLeft,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        isLoggedIn
            ? IconButton(
                tooltip: 'My Profile',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfilePage(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.account_circle_outlined,
                  size: 30,
                ),
              )
            : TextButton(
                onPressed: openLoginPage,
                child: const Text(
                  'LOGIN',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),

        const SizedBox(width: 5),

        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AdminLoginPage(),
              ),
            );
          },
          child: const Text(
            'ADMIN',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ],
    ),
  ),
),

          const Expanded(
            child: Center(
              child: Text(
                'K-BEAUTY BD',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),

          SizedBox(
            width: 400,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 260,
                  height: 42,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: const Color(0xFFF1F1F1),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
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
              isLoggedIn
                  ? IconButton(
                      tooltip: 'My Profile',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProfilePage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.account_circle_outlined),
                    )
                  : TextButton(
                      onPressed: openLoginPage,
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
            onChanged: (value) {
              setState(() {
                searchText = value;
              });
            },
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
              MaterialPageRoute(builder: (_) => const CartPage()),
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
                '${appCart.totalItems}',
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
            style: TextStyle(
              fontSize: 19,
              color: Color(0xFF3F3F3F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _brandFilters() {
    if (isLoadingBrands) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final allBrands = ['ALL', ...brands];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 12,
        runSpacing: 8,
        children: allBrands.map((brand) {
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
          products: products.map((product) {
            return {
              'name': product.name,
              'brand': product.brand,
              'price': product.price,
              'image': product.image,
              'rating': product.rating,
            };
          }).toList(),
        ),
      ),
    );
  }
},
            child: Text(
              brand.toUpperCase(),
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
    final columns = width >= 1200
        ? 4
        : width >= 750
            ? 3
            : 2;

    if (isLoadingProducts) {
      return const Padding(
        padding: EdgeInsets.all(60),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (productError != null) {
      return Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 60),
            const SizedBox(height: 16),
            const Text(
              'Failed to load products.',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              productError!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadProducts,
              child: const Text('RETRY'),
            ),
          ],
        ),
      );
    }

    if (visibleProducts.isEmpty) {
  // Keep the home page empty when there is no search.
  if (searchText.trim().isEmpty) {
    return const SizedBox.shrink();
  }

  return const Padding(
    padding: EdgeInsets.all(50),
    child: Text(
      'No products found.',
      style: TextStyle(fontSize: 18),
    ),
  );
}

    return Container(
      constraints: const BoxConstraints(maxWidth: 1500),
      padding: const EdgeInsets.all(28),
      child: GridView.builder(
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
      onTap: () {
        final productData = <String, String>{
          'name': product.name,
          'brand': product.brand,
          'price': product.price,
          'image': product.image,
          'rating': product.rating,
        };

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailPage(product: productData),
          ),
        );
      },
      onAddToCart: () => addToCart(product),
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
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, hovering ? -9 : 0, 0),
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
              offset: Offset(0, hovering ? 10 : 4),
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
                    child: product.image.isNotEmpty
                        ? Image.network(
                            product.image,
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) =>
                                const Icon(Icons.image_not_supported_outlined),
                          )
                        : const Icon(
                            Icons.image_not_supported_outlined,
                            size: 50,
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

            const SizedBox(height: 5),

            Text(
              product.brand,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1C6A50),
                letterSpacing: 0.8,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              product.rating,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFFFC107),
                fontSize: 19,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 4),

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
