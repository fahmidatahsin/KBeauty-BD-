import 'package:flutter/material.dart';
import 'auth_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F3F1),

      // =========================================================
      // HEADER
      // =========================================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'K-BEAUTY BD',
          style: TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      // =========================================================
      // PROFILE CONTENT
      // =========================================================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              children: [
                // =================================================
                // PROFILE CARD
                // =================================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x18000000),
                        blurRadius: 12,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // PROFILE ICON
                      const CircleAvatar(
                        radius: 48,
                        backgroundColor: Color(0xFFE8F0ED),
                        child: Icon(
                          Icons.person_outline,
                          size: 55,
                          color: Color(0xFF1C6A50),
                        ),
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        'My Profile',
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Manage your account information',
                        style: TextStyle(fontSize: 15, color: Colors.black54),
                      ),

                      const SizedBox(height: 30),

                      // NAME
                      _profileInfo(
                        icon: Icons.person_outline,
                        label: 'Name',
                        value: 'User Name',
                      ),

                      const SizedBox(height: 18),

                      // EMAIL
                      _profileInfo(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: 'user@example.com',
                      ),

                      const SizedBox(height: 18),

                      // ACCOUNT TYPE
                      _profileInfo(
                        icon: Icons.verified_user_outlined,
                        label: 'Account Type',
                        value: 'Customer',
                      ),

                      const SizedBox(height: 30),

                      // EDIT PROFILE
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Edit profile coming soon.'),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF1C6A50),
                            side: const BorderSide(color: Color(0xFF1C6A50)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: const Text(
                            'EDIT PROFILE',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // =================================================
                // ACCOUNT OPTIONS
                // =================================================
                Container(
                  width: double.infinity,
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
                    children: [
                      _profileOption(
                        context,
                        icon: Icons.shopping_bag_outlined,
                        title: 'My Orders',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Orders page coming soon.'),
                            ),
                          );
                        },
                      ),

                      const Divider(height: 1),

                      _profileOption(
                        context,
                        icon: Icons.favorite_border,
                        title: 'Wishlist',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Wishlist coming soon.'),
                            ),
                          );
                        },
                      ),

                      const Divider(height: 1),

                      _profileOption(
                        context,
                        icon: Icons.location_on_outlined,
                        title: 'Delivery Address',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Address management coming soon.'),
                            ),
                          );
                        },
                      ),

                      const Divider(height: 1),

                      _profileOption(
                        context,
                        icon: Icons.logout,
                        title: 'Logout',
                        isLogout: true,
                        onTap: () {
                          _showLogoutDialog(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =============================================================
  // PROFILE INFORMATION
  // =============================================================

  static Widget _profileInfo({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const SizedBox(width: 2),

          Icon(icon, color: const Color(0xFF1C6A50), size: 25),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // PROFILE OPTION
  // =============================================================

  static Widget _profileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      leading: Icon(
        icon,
        color: isLogout ? Colors.red.shade700 : const Color(0xFF1C6A50),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isLogout ? Colors.red.shade700 : Colors.black87,
        ),
      ),
      trailing: isLogout
          ? null
          : const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black38,
            ),
      onTap: onTap,
    );
  }

  // =============================================================
  // LOGOUT DIALOG
  // =============================================================

  static void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Logout',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('CANCEL'),
            ),

            FilledButton(
              onPressed: () async {
                // Close confirmation dialog
                Navigator.pop(dialogContext);

                // Remove saved login token
                await AuthService.logout();

                if (!context.mounted) return;

                // Show logout message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logout successful!'),
                    duration: Duration(seconds: 2),
                  ),
                );

                // Go back and tell previous page that logout happened
                Navigator.pop(context, false);
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red.shade700,
              ),
              child: const Text('LOGOUT'),
            ),
          ],
        );
      },
    );
  }
}
