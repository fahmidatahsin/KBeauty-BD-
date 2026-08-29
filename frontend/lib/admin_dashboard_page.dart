import 'package:flutter/material.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F3F1),

      // =========================================================
      // ADMIN APP BAR
      // =========================================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'K-BEAUTY BD',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
            color: Colors.black,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.black87,
            ),
            label: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),

      // =========================================================
      // DASHBOARD
      // =========================================================
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;

          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 20 : 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Admin Dashboard',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF303030),
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Manage your K-Beauty BD store.',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 30),

                // =================================================
                // DASHBOARD CARDS
                // =================================================
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: isMobile ? 1 : 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: isMobile ? 3.2 : 2.5,
                  children: [
                    _dashboardCard(
                      icon: Icons.inventory_2_outlined,
                      title: 'Products',
                      subtitle: 'Manage products',
                      onTap: () {
                        _showComingSoon(context, 'Product Management');
                      },
                    ),

                    _dashboardCard(
                      icon: Icons.shopping_bag_outlined,
                      title: 'Orders',
                      subtitle: 'View and manage orders',
                      onTap: () {
                        _showComingSoon(context, 'Order Management');
                      },
                    ),

                    _dashboardCard(
                      icon: Icons.people_outline,
                      title: 'Customers',
                      subtitle: 'View registered customers',
                      onTap: () {
                        _showComingSoon(context, 'Customer Management');
                      },
                    ),

                    _dashboardCard(
                      icon: Icons.category_outlined,
                      title: 'Categories',
                      subtitle: 'Manage product categories',
                      onTap: () {
                        _showComingSoon(context, 'Category Management');
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _dashboardCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          child: Row(
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F3EE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: const Color(0xFF1C6A50),
                ),
              ),

              const SizedBox(width: 18),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.black45,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon.'),
      ),
    );
  }
}
