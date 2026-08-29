import 'package:flutter/material.dart';

import 'auth_service.dart';
import 'brand_page.dart';
import 'brand_service.dart';
import 'cart_model.dart';
import 'cart_page.dart';
import 'catalog_page.dart';
import 'login_page.dart';
import 'profile_page.dart';
import 'product_detail_page.dart';
import 'services/product_service.dart';
import 'admin_login_page.dart';

final CartModel appCart = CartModel();

void main() {
  runApp(const KBeautyApp());
}

// ============================================================
// APP
// ============================================================

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
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1C6A50)),
        ),
        home: const HomePage(),
      ),
    );
  }
}

// ============================================================
// PRODUCT MODEL
// ============================================================

class Product {
  final String id;
  final String name;
  final String brand;
  final String category;
  final String price;
  final String image;
  final String rating;
  final bool soldOut;
  final bool vegan;
  final bool newArrival;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.price,
    required this.image,
    required this.rating,
    this.soldOut = false,
    this.vegan = false,
    this.newArrival = false,
  });

 factory Product.fromMap(Map<String, dynamic> product) {
  final dynamic rawPrice = product['price'];
  final String priceText = rawPrice?.toString() ?? '';

  return Product(
    id: product['_id']?.toString() ?? product['id']?.toString() ?? '',
    name: product['name']?.toString() ?? '',
    brand: _getBrandName(product['brand']),
    category: _getCategoryName(product['category']),
    price: _formatPrice(priceText),
    image: product['image']?.toString() ??
        product['imageUrl']?.toString() ??
        '',
    rating: _getRating(product['rating']),
    soldOut:
        product['soldOut'] == true ||
        product['stock'] == 0 ||
        priceText.toUpperCase() == 'SOLD OUT',
    vegan: product['vegan'] == true,
    newArrival:
        product['newArrival'] == true ||
        product['isNew'] == true,
  );
}

static String _getBrandName(dynamic brand) {
    if (brand is Map) {
      return brand['name']?.toString() ?? '';
    }

    return brand?.toString() ?? '';
  }
static String _getCategoryName(dynamic category) {
  if (category is Map) {
    return category['name']?.toString() ?? '';
  }

  return category?.toString() ?? '';
}
  static String _formatPrice(String price) {
    if (price.isEmpty) {
      return '';
    }

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
    if (rating == null) {
      return '★★★★★';
    }

    if (rating is num) {
      final rounded = rating.round().clamp(0, 5);

      return '${'★' * rounded}${'☆' * (5 - rounded)}';
    }

    final text = rating.toString();

    if (text.contains('★') || text.contains('☆')) {
      return text;
    }

    final number = double.tryParse(text);

    if (number != null) {
      final rounded = number.round().clamp(0, 5);

      return '${'★' * rounded}${'☆' * (5 - rounded)}';
    }

    return '★★★★★';
  }
}

// ============================================================
// HOME PAGE
// ============================================================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchText = '';

  bool isLoggedIn = false;

  // ============================================================
  // BRANDS
  // ============================================================

  List<String> brands = [];
  bool isLoadingBrands = true;

  // ============================================================
  // PRODUCTS
  // ============================================================

  List<Product> products = [];

bool isLoadingProducts = true;

  String? productError;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _checkLoginStatus();
    _loadBrands();
    _loadProducts();
  }


  // ============================================================
  // CHECK LOGIN
  // ============================================================

  Future<void> _checkLoginStatus() async {
    final loggedIn = await AuthService.isLoggedIn();

    if (!mounted) {
      return;
    }

    setState(() {
      isLoggedIn = loggedIn;
    });
  }

  // ============================================================
  // LOAD BRANDS
  // ============================================================

  Future<void> _loadBrands() async {
    try {
      final loadedBrands = await BrandService.getBrands();

      if (!mounted) {
        return;
      }

      setState(() {
        brands = loadedBrands;
        isLoadingBrands = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        isLoadingBrands = false;
      });
    }
  }

  // ============================================================
  // LOAD PRODUCTS
  // ============================================================

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

  // ============================================================
  // OPEN LOGIN
  // ============================================================

  Future<bool> openLoginPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );

    if (result == true && mounted) {
      setState(() {
        isLoggedIn = true;
      });

      // After login, load user's cart
      await appCart.loadCart();

      return true;
    }

    return false;
  }

  // ============================================================
  // SEARCH PRODUCTS
  // ============================================================

List<Product> get visibleProducts {
  final query = searchText.trim().toLowerCase();

  if (query.isEmpty) {
    return products;
  }

  return products.where((product) {
    return product.name.toLowerCase().contains(query) ||
        product.brand.toLowerCase().contains(query);
  }).toList();
}

  // ===============================
  // SHOW MESSAGE
  // ============================================================

  void showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // ============================================================
  // ADD TO CART
  // ============================================================

  Future<void> addToCart(Product product) async {
  // Sold out check
  if (product.soldOut) {
    showMessage('Sorry, this product is sold out.');
    return;
  }

  // Product ID check
  if (product.id.isEmpty) {
    showMessage('Product ID missing. Please check product data.');
    return;
  }

  // Login check
  final loggedIn = await AuthService.isLoggedIn();

  if (!loggedIn) {
    final loginSuccess = await openLoginPage();

    if (!loginSuccess) {
      return;
    }
  }

  try {
    // Add product to cart
    appCart.add(
      {
        'id': product.id,
        'name': product.name,
        'brand': product.brand,
        'price': product.price,
        'image': product.image,
        'rating': product.rating,
      },
      1,
    );

    if (!mounted) {
      return;
    }

    showMessage('${product.name} added to cart.');
  } catch (error) {
    if (!mounted) {
      return;
    }

    showMessage('Failed to add product to cart.');
    debugPrint('Add to cart error: $error');
  }
}
  

  // ============================================================
  // BUILD
  // ============================================================

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
                  _productSection(constraints.maxWidth),
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

  // ============================================================
  // DESKTOP HEADER
  // ============================================================

  Widget _desktopHeader() {
  return Container(
    color: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
    child: Row(
      children: [
        // =========================================================
        // LEFT SIDE: CUSTOMER LOGIN / PROFILE + ADMIN
        // =========================================================
        SizedBox(
          width: 280,
          child: Row(
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

              const SizedBox(width: 8),

              // =====================================================
              // ADMIN BUTTON
              // =====================================================
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminLoginPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF087EF5),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text(
                  'Admin',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        // =========================================================
        // LOGO
        // =========================================================
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

        // =========================================================
        // SEARCH + CART
        // =========================================================
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
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
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

  // ============================================================
  // MOBILE HEADER
  // ============================================================

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
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
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

  // ============================================================
  // CART BUTTON
  // ============================================================

  Widget _cartButton() {
    return ListenableBuilder(
      listenable: appCart,
      builder: (context, _) {
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
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  // ============================================================
  // HERO
  // ============================================================

  Widget _hero(bool isDesktop) {
    return SizedBox(
      width: double.infinity,
      height: isDesktop ? 380 : 240,
      child: Image.asset('assets/images/hero-banner-1.jpg', fit: BoxFit.cover),
    );
  }

  // ============================================================
  // INTRO
  // ============================================================

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

  // ============================================================
  // BRAND FILTERS
  // ============================================================

  Widget _brandFilters() {
    if (isLoadingBrands) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: CircularProgressIndicator()),
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
                  MaterialPageRoute(builder: (_) => const CatalogPage()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BrandPage(
                      brand: brand,
                      products: products.map((product) {
                        return {
                          'id': product.id,
                          'name': product.name,
                          'brand': product.brand,
                           'category': product.category,
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

  // ============================================================
  // PRODUCT SECTION
  // ============================================================

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
        child: Center(child: CircularProgressIndicator()),
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
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
      return const Padding(
        padding: EdgeInsets.all(50),
        child: Center(
          child: Text('No products found.', style: TextStyle(fontSize: 18)),
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
          childAspectRatio: isMobile ? 0.48 : 0.65,
        ),
        itemBuilder: (context, index) {
          return _productCard(visibleProducts[index]);
        },
      ),
    );
  }

  // ============================================================
  // PRODUCT CARD
  // ============================================================

  Widget _productCard(Product product) {
    return _HomeProductCard(
      product: product,
      onTap: () {
        final productData = <String, String>{
          'id': product.id,
          'name': product.name,
          'brand': product.brand,
          'category': product.category,
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

// ============================================================
// BADGE
// ============================================================

class Badge extends StatelessWidget {
  final String text;
  final Color color;

  const Badge({super.key, required this.text, required this.color});

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
          fontSize: 10,
        ),
      ),
    );
  }
}

// ============================================================
// HOME PRODUCT CARD
// ============================================================

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

  // ============================================================
  // IMAGE
  // ============================================================

 Widget _image(String imageUrl) {
  if (imageUrl.isEmpty) {
    return const Center(
      child: Icon(
        Icons.image_not_supported_outlined,
        size: 60,
        color: Colors.grey,
      ),
    );
  }

  if (imageUrl.startsWith('http://') ||
      imageUrl.startsWith('https://')) {
    return Image.network(
      imageUrl,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return const Center(
          child: Icon(
            Icons.broken_image_outlined,
            size: 60,
            color: Colors.grey,
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  return Image.asset(
    imageUrl,
    fit: BoxFit.contain,
    errorBuilder: (context, error, stackTrace) {
      return const Center(
        child: Icon(
          Icons.broken_image_outlined,
          size: 60,
          color: Colors.grey,
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

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
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, hovering ? -9 : 0, 0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: hovering ? 0.18 : 0.06),
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
                    child: _image(product.image),
                  ),

                  // VEGAN BADGE
                  if (product.vegan)
                    const Positioned(
                      top: 10,
                      left: 10,
                      child: Badge(text: 'Vegan', color: Color(0xFF167C59)),
                    ),

                  // NEW BADGE
                  if (product.newArrival)
                    const Positioned(
                      top: 66,
                      left: 10,
                      child: Badge(text: 'New', color: Color(0xFF5635A8)),
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
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
                color: product.soldOut ? Colors.red.shade700 : Colors.black54,
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
