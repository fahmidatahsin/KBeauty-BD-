import 'package:flutter/material.dart';
import 'catalog_page.dart';

void main() {
  runApp(const KBeautyApp());
}

class KBeautyApp extends StatelessWidget {
  const KBeautyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  int cartCount = 0;
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

    setState(() => cartCount++);
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
      padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 14),
      child: Row(
        children: [
          PopupMenuButton<String>(
            onSelected: (value) => showMessage('$value category selected'),
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'Cleanser', child: Text('Cleanser')),
              PopupMenuItem(value: 'Moisturizer', child: Text('Moisturizer')),
              PopupMenuItem(value: 'Serum', child: Text('Serum')),
              PopupMenuItem(value: 'Sunscreen', child: Text('Sunscreen')),
            ],
            child: const Row(
              children: [
                Text(
                  'Shop By Categories',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.keyboard_arrow_down),
              ],
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
          SizedBox(
            width: 210,
            child: TextField(
              onChanged: (value) => setState(() => searchText = value),
              decoration: InputDecoration(
                hintText: 'Search...',
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _cartButton(),
          TextButton(
            onPressed: () => showMessage('Login page will be created later.'),
            child: const Text(
              'LOGIN',
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
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
                onPressed: () => showMessage('Category menu coming later.'),
                icon: const Icon(Icons.menu),
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
          onPressed: () => showMessage('Your cart has $cartCount item(s).'),
          icon: const Icon(Icons.shopping_bag_outlined),
        ),
        if (cartCount > 0)
          Positioned(
            top: 4,
            right: 4,
            child: CircleAvatar(
              radius: 8,
              backgroundColor: Colors.deepOrange,
              child: Text(
                '$cartCount',
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
      ],
    );
  }

  Widget _hero(bool isDesktop) {
    return SizedBox(
      width: double.infinity,
      height: isDesktop ? 520 : 240,
      child: Image.asset(
        'assets/images/hero-banner-1.jpg',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _intro() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(32, 36, 32, 42),
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
      'BY WISHTREND',
      'BEAUTY OF JOSEON',
      'AXIS-Y',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 12,
        runSpacing: 8,
        children: brands
            .map(
              (brand) => TextButton(
                onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const CatalogPage()),
  );
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
              ),
            )
            .toList(),
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
    return InkWell(
      onTap: () => showMessage('${product.name} details page comes next.'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(
                    product.image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                if (product.vegan)
                  const Positioned(
                    top: 10,
                    left: 10,
                    child: Badge(text: 'Vegan', color: Color(0xFF167C59)),
                  ),
                if (product.newArrival)
                  const Positioned(
                    top: 66,
                    left: 10,
                    child: Badge(text: 'New', color: Color(0xFF5635A8)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            product.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
            onPressed: () => addToCart(product),
            child: Text(product.soldOut ? 'SOLD OUT' : 'ADD TO CART'),
          ),
        ],
      ),
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