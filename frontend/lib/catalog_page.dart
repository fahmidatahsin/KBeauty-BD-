import 'package:flutter/material.dart';
import 'product_detail_page.dart';
import 'cart_model.dart';
import 'cart_page.dart';

const List<Map<String, String>> allProducts = [ 
  {
  'name':
      'SKIN1004 Madagascar Centella Tone Brightening Cleansing Gel Foam 125ml',
  'price': '৳1,450.00',
  'category': 'Cleanser',
  'brand': 'SKIN1004',
  'image':
      'assets/images/SKIN1004 Madagascar Centella Tone Brightening Cleansing Gel Foam 125ml.jpeg',
  'rating': '★★★★★',
},
  {
    'name': 'Bonajour Ginger Aqua Relief Pad 60 Pads',
    'price': '৳1,700.00',
    'category': 'Pads',
    'brand': 'BONAJOUR',
    'image': 'assets/images/GinerReliefPad.jpg',
    'rating': '★★★★★',
  },
  {
  'name':
      'AXIS-Y Heartleaf My Type Calming Cream 60ml',
  'price': '৳1,650.00',
  'category': 'Moisturizer',
  'brand': 'AXIS-Y',
  'image':
      'assets/images/AXIS-Y Heartleaf My Type Calming Cream 60ml.jpeg',
  'rating': '★★★★★',
},
{
  'name':
      'SKIN1004 Madagascar Centella Soothing Cream 75ml',
  'price': '৳1,850.00',
  'category': 'Moisturizer',
  'brand': 'SKIN1004',
  'image':
      'assets/images/SKIN1004-Centella Soothing Cream 75ml.jpeg',
  'rating': '★★★★★',
},
{
  'name':
      'SKIN1004 Madagascar Centella Probio-Cica Enrich Cream 50ml',
  'price': '৳2,250.00',
  'category': 'Moisturizer',
  'brand': 'SKIN1004',
  'image':
      'assets/images/SKIN1004-Probio-Cica Enrich Cream 50ml.jpeg',
  'rating': '★★★★★',
},

  {
    'name': 'Bonajour Jeju Milk Soft Foaming Cleanser 160ml',
    'price': '৳1,700.00',
    'category': 'Cleanser',
    'brand': 'BONAJOUR',
    'image': 'assets/images/boanjourFoamingCleanser.webp',
    'rating': '★★★★★',
  },
  {
  'name':
      'Dear, KLAIRS Gentle Black Fresh Cleansing Oil 150ml',
  'price': '৳2,100.00',
  'category': 'Cleanser',
  'brand': 'KLAIRS',
  'image':
      'assets/images/KLAIRS Cleansing Oil 150ml.jpeg',
  'rating': '★★★★★',
},
  {
    'name': 'Bonajour Ginger Aqua Relief Sun Cream 40ml',
    'price': '৳1,700.00',
    'category': 'Sun Care',
    'brand': 'BONAJOUR',
    'image': 'assets/images/bonajourGingercream.png',
    'rating': '★★★★★',
  },
  {
  'name':
      'AXIS-Y Cera-Heart My Type Duo Cream 60ml',
  'price': '৳2,200.00',
  'category': 'Moisturizer',
  'brand': 'AXIS-Y',
  'image':
      'assets/images/AXIS-Y Duo Cream 60ml.jpeg',
  'rating': '★★★★★',
},
  {
    'name': 'Bonajour Ginger Aqua Relief Foam Cleanser',
    'price': 'SOLD OUT',
    'category': 'Cleanser',
    'brand': 'BONAJOUR',
    'image':
        'assets/images/Bonajour Ginger Aqua Relief Foam Cleanser.jpg',
    'rating': '★★★★☆',
  },
  {
  'name':
      'SKIN1004 Madagascar Centella Hyalu-Cica Moisture Cream 75ml',
  'price': '৳2,200.00',
  'category': 'Moisturizer',
  'brand': 'SKIN1004',
  'image':
      'assets/images/SKIN1004 Hyalu-Cica Moisture Cream.jpeg',
  'rating': '★★★★★',
},

  {
  'name':
      'SKIN1004 Madagascar Centella Hyalu-Cica Water-Fit Sun Serum 50ml',
  'price': '৳1,850.00',
  'category': 'Sun Care',
  'brand': 'SKIN1004',
  'image':
      'assets/images/SKIN1004 Water-Fit Sun Serum.jpeg',
  'rating': '★★★★★',
},
  {
  'name':
      'AXIS-Y Daily Purifying Treatment Toner 200ml',
  'price': '৳1,650.00',
  'category': 'Toner',
  'brand': 'AXIS-Y',
  'image':
      'assets/images/AXIS-Y Daily Purifying Toner.jpeg',
  'rating': '★★★★★',
},

{
  'name':
      'Dear KLAIRS Gentle Black Facial Cleanser 20mL',
  'price': '৳600.00',
  'category': 'Cleanser',
  'brand': 'KLAIRS',
  'image':
      'assets/images/KLAIRSGentleBlackFacialCleanser20mL.webp',
  'rating': '★★★★★',
},
{
  'name':
      'AXIS-Y Dark Spot Correcting Glow Toner 120ml',
  'price': '৳1,850.00',
  'category': 'Toner',
  'brand': 'AXIS-Y',
  'image':
      'assets/images/AXIS-Y Correcting Glow Toner.jpeg',
  'rating': '★★★★★',
},

{
  'name':
      'Dear, KLAIRS Fundamental Water Gel Cream 50ml',
  'price': '৳2,200.00',
  'category': 'Moisturizer',
  'brand': 'KLAIRS',
  'image':
      'assets/images/KLAIRS Water Gel Cream.jpeg',
  'rating': '★★★★★',
},
{
  'name':
      'SKIN1004 Madagascar Centella Probio-Cica Intensive Ampoule 50ml',
  'price': '৳2,250.00',
  'category': 'Serum',
  'brand': 'SKIN1004',
  'image':
      'assets/images/SKIN1004 Probio-Cica Intensive Ampoule.jpeg',
  'rating': '★★★★★',
},
{
  'name':
      'Dear, KLAIRS All-day Airy Sunscreen SPF50+ PA++++ 50ml',
  'price': '৳2,000.00',
  'category': 'Sun Care',
  'brand': 'KLAIRS',
  'image':
      'assets/images/KLAIRS Sunscreen.jpeg',
  'rating': '★★★★★',
},
{
  'name':
      'Beauty of Joseon Calming Serum Green Tea + Panthenol 30ml',
  'price': '৳1,650.00',
  'category': 'Serum',
  'brand': 'BEAUTY OF JOSEON',
  'image':
      'assets/images/Beauty of Joseon Calming Serum Green Tea + Panthenol.jpeg',
  'rating': '★★★★★',
},
{
  'name':
      'Beauty of Joseon Light On Serum Centella + Vita C 30ml',
  'price': '৳1,650.00',
  'category': 'Serum',
  'brand': 'BEAUTY OF JOSEON',
  'image':
      'assets/images/Beauty of Joseon Serum Centella + Vita C.jpeg',
  'rating': '★★★★★',
},
{
  'name':
      'Dear, KLAIRS Rich Moist Soothing Serum 80ml',
  'price': '৳2,100.00',
  'category': 'Serum',
  'brand': 'KLAIRS',
  'image':
      'assets/images/KLAIRS Serum.jpeg',
  'rating': '★★★★★',
},
{
  'name':
      'Dear, KLAIRS Midnight Blue Youth Activating Drop 20ml',
  'price': '৳2,500.00',
  'category': 'Serum',
  'brand': 'KLAIRS',
  'image':
      'assets/images/KLAIRS Serum Drop.jpeg',
  'rating': '★★★★★',
},
{
  'name':
      'SKIN1004 Madagascar Centella Hyalu-Cica Blue Serum 50ml',
  'price': '৳1,950.00',
  'category': 'Serum',
  'brand': 'SKIN1004',
  'image':
      'assets/images/SKIN1004 Blue Serum.jpeg',
  'rating': '★★★★★',
},
  {
    'name':
        'Beauty of Joseon Glow Serum: Propolis + Niacinamide 30ml',
    'price': '৳1,850.00',
    'category': 'Serum',
    'brand': 'BEAUTY OF JOSEON',
    'image':
        'assets/images/Beauty of Joseon Glow Serum_Propolis_Niacinamide 30ml.png',
    'rating': '★★★★★',
  },
  {
  'name':
      'SKIN1004 Madagascar Centella Watergel Sheet Ampoule Mask 25ml',
  'price': '৳450.00',
  'category': 'Mask',
  'brand': 'SKIN1004',
  'image':
      'assets/images/SKIN1004 Watergel Sheet Ampoule Mask.jpeg',
  'rating': '★★★★★',
},
{
  'name':
      'SKIN1004 Madagascar Centella Hyalu-Cica Hydrating Mask 23ml',
  'price': '৳450.00',
  'category': 'Mask',
  'brand': 'SKIN1004',
  'image':
      'assets/images/SKIN1004 Hydrating Mask.jpeg',
  'rating': '★★★★★',
},
{
  'name':
      'Dear, KLAIRS Rich Moist Soothing Tencel Sheet Mask 25ml',
  'price': '৳450.00',
  'category': 'Mask',
  'brand': 'KLAIRS',
  'image':
      'assets/images/KLAIRS Tencel Sheet Mask.jpeg',
  'rating': '★★★★★',
},
{
  'name':
      'Beauty of Joseon Relief Sun Rice + Probiotics SPF50+ PA++++ 50ml',
  'price': '৳1,650.00',
  'category': 'Sun Care',
  'brand': 'BEAUTY OF JOSEON',
  'image':
      'assets/images/Beauty of Joseon Relief Sun Rice + Probiotics SPF50+ PA++++ 50ml.jpeg',
  'rating': '★★★★★',
},
{
  'name':
      'Beauty of Joseon Relief Sun Aqua-Fresh Rice + B5 SPF50+ PA++++ 50ml',
  'price': '৳1,650.00',
  'category': 'Sun Care',
  'brand': 'BEAUTY OF JOSEON',
  'image':
      'assets/images/Beauty of Joseon Relief Sun Aqua-Fresh.jpeg',
  'rating': '★★★★★',
},
{
  'name':
      'Beauty of Joseon Ginseng Moist Sun Serum SPF50+ PA++++ 50ml',
  'price': '৳1,750.00',
  'category': 'Sun Care',
  'brand': 'BEAUTY OF JOSEON',
  'image':
      'assets/images/Beauty of Joseon Ginseng Moist Sun Serum.jpeg',
  'rating': '★★★★★',
},
{
  'name':
      'Beauty of Joseon Dynasty Cream 50ml',
  'price': '৳1,850.00',
  'category': 'Moisturizer',
  'brand': 'BEAUTY OF JOSEON',
  'image':
      'assets/images/Beauty of Joseon Dynasty Cream.jpeg',
  'rating': '★★★★★',
},
{
  'name':
      'Beauty of Joseon Red Bean Cream 50ml',
  'price': '৳1,750.00',
  'category': 'Moisturizer',
  'brand': 'BEAUTY OF JOSEON',
  'image':
      'assets/images/Beauty of Joseon Red Bean Cream.jpeg',
  'rating': '★★★★★',
},
{
  'name':
      'SKIN1004 Madagascar Centella Hyalu-Cica Brightening Toner 210ml',
  'price': '৳1,750.00',
  'category': 'Toner',
  'brand': 'SKIN1004',
  'image':
      'assets/images/SKIN1004 Hyalu-Cica Brightening Toner.jpeg',
  'rating': '★★★★★',
},
{
  'name':
      'SKIN1004 Madagascar Centella Tone Brightening Boosting Toner 210ml',
  'price': '৳1,950.00',
  'category': 'Toner',
  'brand': 'SKIN1004',
  'image':
      'assets/images/SKIN1004 Boosting Toner.jpeg',
  'rating': '★★★★★',
},
  {
  'name':
      'AXIS-Y Mugwort Pore Clarifying Wash Off Pack 100ml',
  'price': '৳1,800.00',
  'category': 'Mask',
  'brand': 'AXIS-Y',
  'image':
      'assets/images/AXIS-Y Mugwort Pore Clarifying Wash Off Pack 100ml.jpeg',
  'rating': '★★★★★',
},
{
  'name':
      'Beauty of Joseon Red Bean Refreshing Pore Mask 140ml',
  'price': '৳1,650.00',
  'category': 'Mask',
  'brand': 'BEAUTY OF JOSEON',
  'image':
      'assets/images/Beauty of Joseon Red Bean Refreshing Pore Mask.jpeg',
  'rating': '★★★★★',
},
{
  'name':
      'Beauty of Joseon Ground Rice and Honey Glow Mask 150ml',
  'price': '৳1,650.00',
  'category': 'Mask',
  'brand': 'BEAUTY OF JOSEON',
  'image':
      'assets/images/Beauty of Joseon Ground Rice and Honey Glow Mask 150ml.jpeg',
  'rating': '★★★★★',
},
{
  'name':
      'AXIS-Y New Skin Resolution Gel Mask 100ml',
  'price': '৳1,850.00',
  'category': 'Mask',
  'brand': 'AXIS-Y',
  'image':
      'assets/images/AXIS-Y New Skin Resolution Gel Mask 100ml.jpeg',
  'rating': '★★★★★',
},
  {
    'name': 'KLAIRS Midnight Blue Calming Cream 30ml',
    'price': '৳1,750.00',
    'category': 'Moisturizer',
    'brand': 'KLAIRS',
    'image': 'assets/images/KLAIRSmidnightcream.jpg',
    'rating': '★★★★★',
  },
  {
  'name':
      'SKIN1004 Madagascar Centella Quick Calming Pad 70 Pads',
  'price': '৳2,100.00',
  'category': 'Pads',
  'brand': 'SKIN1004',
  'image':
      'assets/images/SKIN1004 Quick Calming Pad.jpeg',
  'rating': '★★★★★',
},
  {
    'name': 'KLAIRS Freshly Juiced Vitamin Drop 35ml',
    'price': '৳2,000.00',
    'category': 'Serum',
    'brand': 'KLAIRS',
    'image':
        'assets/images/KLAIRS Freshly Juiced Vitamin Drop 35ml.jpg',
    'rating': '★★★★★',
  },
 
  {
    'name': 'KLAIRS Rich Moist Soothing Cream 80ml',
    'price': '৳2,100.00',
    'category': 'Moisturizer',
    'brand': 'KLAIRS',
    'image':
        'assets/images/KLAIRS_Rich-Moist-Soothing-Cream-4.jpg',
    'rating': '★★★★★',
  },
 
  {
    'name': 'KLAIRS Freshly Juiced Vitamin E Mask 15ml',
    'price': '৳950.00',
    'category': 'Mask',
    'brand': 'KLAIRS',
    'image':
        'assets/images/KLAIRS Freshly Juiced Vitamin E Mask 15ml.jpg',
    'rating': '★★★★★',
  },
  {
    'name': 'AXIS-Y Quinoa One-Step Balanced Gel Cleanser 180ml',
    'price': '৳1,650.00',
    'category': 'Cleanser',
    'brand': 'AXIS-Y',
    'image':
        'assets/images/AXIS-Y Quinoa One-Step Balanced Gel Cleanser 180ml.webp',
    'rating': '★★★★★',
  },
  
  {
    'name': 'SKIN1004 Madagascar Centella Ampoule 100ml',
    'price': '৳2,150.00',
    'category': 'Serum',
    'brand': 'SKIN1004',
    'image':
        'assets/images/SKIN1004 Madagascar Centella Ampoule 100m.jpg',
    'rating': '★★★★★',
  },
  {
    'name': 'SKIN1004 Madagascar Centella Toning Toner 210ml',
    'price': '৳2,100.00',
    'category': 'Toner',
    'brand': 'SKIN1004',
    'image':
        'assets/images/SKIN1004-Madagascar-Centella-Toning-Toner-210-ml.jpg',
    'rating': '★★★★★',
  },
  {
    'name': 'AXIS-Y Dark Spot Correcting Glow Serum 50ml',
    'price': '৳1,850.00',
    'category': 'Serum',
    'brand': 'AXIS-Y',
    'image':
        'assets/images/AXIS-Y Dark Spot Correcting Glow Serum 50ml.jpg',
    'rating': '★★★★★',
  },
  {
    'name': 'SKIN1004 Madagascar Centella Light Cleansing Oil 30ml',
    'price': '700.00',
    'category': 'Cleanser',
    'brand': 'SKIN1004',
    'image':
        'assets/images/SKIN1004 Madagascar Centella Light Cleansing Oil 30ml(mini).png',
    'rating': '★★★★★',
  },

  {
    'name':
        'AXIS-Y Artichoke Intensive Skin Barrier Ampoule 30ml',
    'price': '৳1,950.00',
    'category': 'Serum',
    'brand': 'AXIS-Y',
    'image':
        'assets/images/AXIS-Y Artichoke Intensive Skin Barrier Ampoule 30ml.jpg',
    'rating': '★★★★★',
  },
  {
    'name':
        'AXIS-Y Sunday Morning Refreshing Cleansing Foam 120ml',
    'price': '৳1,450.00',
    'category': 'Cleanser',
    'brand': 'AXIS-Y',
    'image':
        'assets/images/AXIS-Y Sunday Morning Refreshing Cleansing Foam 120ml.jpeg',
    'rating': '★★★★★',
  },
  {
    'name':  'Skin1004 Madagascar Centella Ampoule Foam 20ml (Mini) ',
    'price': '৳1,450.00',
    'category': 'Cleanser',
    'brand': 'SKIN1004',
    'image':
        'assets/images/Skin1004-Madagascar-Centella-Ampoule-Foam-20ml(mini).webp',
    'rating': '★★★★★',
  },
  {
    'name':
        'AXIS-Y Complete No-Stress Physical Sunscreen SPF50+ PA++++ 50ml',
    'price': '৳1,850.00',
    'category': 'Sun Care',
    'brand': 'AXIS-Y',
    'image':
        'assets/images/AXIS-Y Complete No-Stress Physical Sunscreen 50ml.webp',
    'rating': '★★★★★',
  },
  {
    'name':
        'SKIN1004 Hyalu-Cica Water-Fit Sun Serum SPF50+ PA++++',
    'price': '৳2,050.00',
    'category': 'Sun Care',
    'brand': 'SKIN1004',
    'image':
        'assets/images/SKIN1004-Madagascar-Centella-Hyalu-Cica-Water-Fit-Sun-Serum-50ml.webp',
    'rating': '★★★★★',
  },
  {
    'name':
        'SKIN1004 Madagascar Centella Light Cleansing Oil 200ml',
    'price': '৳2,250.00',
    'category': 'Cleanser',
    'brand': 'SKIN1004',
    'image':
        'assets/images/SKIN1004 Madagascar Centella Light Cleansing Oil 200ml.jpeg',
    'rating': '★★★★★',
  },
  
];

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  String selectedCategory = 'All';
String searchText = '';
String selectedSort = 'Default';

List<Map<String, String>> get products => allProducts;

List<Map<String, String>> get filteredProducts {
  final result = products
      .where((product) {
        final categoryMatches =
            selectedCategory == 'All' ||
            product['category'] == selectedCategory;

        final searchMatches = product['name']!
            .toLowerCase()
            .contains(searchText.toLowerCase());

        return categoryMatches && searchMatches;
      })
      .map((product) => Map<String, String>.from(product))
      .toList();

  double getPrice(Map<String, String> product) {
    final price = product['price'] ?? '';

    if (price == 'SOLD OUT') {
      return double.infinity;
    }

    return double.tryParse(
          price.replaceAll(RegExp(r'[^0-9.]'), ''),
        ) ??
        double.infinity;
  }

  if (selectedSort == 'Price: Low to High') {
    result.sort(
      (a, b) => getPrice(a).compareTo(getPrice(b)),
    );
  } else if (selectedSort == 'Price: High to Low') {
    result.sort(
      (a, b) => getPrice(b).compareTo(getPrice(a)),
    );
  }

  return result;
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
        content: Text(
          '${product['name']} added to cart.',
        ),
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
                  const Text(
                    'EXPLORE CATALOG',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Find products for your personal skin-care routine.',
                     style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 26),
                  _searchAndFilters(isDesktop),
                  const SizedBox(height: 34),
                  if (filteredProducts.isEmpty)
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
                      physics:
                          const NeverScrollableScrollPhysics(),
                      itemCount: filteredProducts.length,
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 28,
                        childAspectRatio:
                            width < 600 ? 0.52 : 0.60,
                      ),
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];

                        return HoverProductCard(
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
              'HOME',
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
  const categories = [
    'All',
    'Cleanser',
    'Moisturizer',
    'Sun Care',
    'Serum',
    'Toner',
    'Mask',
    'Pads',
  ];

  IconData categoryIcon(String category) {
    switch (category) {
      case 'Cleanser':
        return Icons.water_drop_outlined;
      case 'Moisturizer':
        return Icons.spa_outlined;
      case 'Sun Care':
        return Icons.wb_sunny_outlined;
      case 'Serum':
        return Icons.opacity_outlined;
      case 'Toner':
        return Icons.local_drink_outlined;
      case 'Mask':
        return Icons.face_retouching_natural;
      case 'Pads':
        return Icons.spa_outlined;
      default:
        return Icons.grid_view_rounded;
    }
  }

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
        setState(() => searchText = value);
      },
      decoration: const InputDecoration(
        hintText: 'Search your skincare...',
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
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: selectedSort,
        isExpanded: true,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Color(0xFF1C6A50),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        borderRadius: BorderRadius.circular(14),
        items: const [
          DropdownMenuItem(
            value: 'Default',
            child: Row(
              children: [
                Icon(
                  Icons.sort,
                  color: Color(0xFF1C6A50),
                ),
                SizedBox(width: 10),
                Text(
                  'Sort By: Default',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          DropdownMenuItem(
            value: 'Price: Low to High',
            child: Row(
              children: [
                Icon(
                  Icons.arrow_upward,
                  color: Color(0xFF1C6A50),
                ),
                SizedBox(width: 10),
                Text(
                  'Price: Low to High',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          DropdownMenuItem(
            value: 'Price: High to Low',
            child: Row(
              children: [
                Icon(
                  Icons.arrow_downward,
                  color: Color(0xFF1C6A50),
                ),
                SizedBox(width: 10),
                Text(
                  'Price: High to Low',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
        onChanged: (value) {
          if (value == null) return;

          setState(() {
            selectedSort = value;
          });
        },
      ),
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
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              categoryIcon(category),
              size: 18,
              color: selected
                  ? Colors.white
                  : const Color(0xFF1C6A50),
            ),
            const SizedBox(width: 7),
            Text(
              category,
              style: TextStyle(
                color: selected
                    ? Colors.white
                    : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
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
        const SizedBox(height: 12),
        sortDropdown,
        const SizedBox(height: 18),
        filters,
      ],
    );
  }

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          searchBox,
          const SizedBox(height: 12),
          sortDropdown,
        ],
      ),
      const SizedBox(width: 28),
      Expanded(
        child: filters,
      ),
    ],
  );
}
}

class HoverProductCard extends StatefulWidget {
  final Map<String, String> product;
  final VoidCallback onDetails;
  final VoidCallback onAddToCart;

  const HoverProductCard({
    super.key,
    required this.product,
    required this.onDetails,
    required this.onAddToCart,
  });

  @override
  State<HoverProductCard> createState() =>
      _HoverProductCardState();
}

class _HoverProductCardState extends State<HoverProductCard> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    final soldOut = widget.product['price'] == 'SOLD OUT';

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
                color:
                    soldOut ? Colors.red : Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: widget.onDetails,
              child: const Text('VIEW DETAILS'),
            ),
            if (!soldOut)
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