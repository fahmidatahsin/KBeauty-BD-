import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'auth_service.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() =>
      _AdminDashboardPageState();
}

class _AdminDashboardPageState
    extends State<AdminDashboardPage> {
  // ============================================================
  // CURRENT PAGE
  // ============================================================

  String _currentPage = 'Dashboard';

  // ============================================================
  // DASHBOARD DATA
  // ============================================================

  int totalProducts = 0;
  int totalUsers = 0;
  double totalSales = 0;

  bool isLoadingStats = true;

  // ============================================================
  // TABLE DATA
  // ============================================================

  List<dynamic> users = [];
  List<dynamic> products = [];
  List<dynamic> orders = [];

  bool isLoadingTable = false;

  String? errorMessage;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();
    _loadDashboardStats();
  }

  // ============================================================
  // LOAD DASHBOARD STATS
  // ============================================================

  Future<void> _loadDashboardStats() async {
    setState(() {
      isLoadingStats = true;
      errorMessage = null;
    });

    try {
      final headers = await AuthService.getAuthHeaders();

      final response = await http.get(
        Uri.parse(
          '${AuthService.baseUrl}/admin/dashboard',
        ),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          totalProducts =
              data['totalProducts'] ?? 0;

          totalUsers =
              data['totalUsers'] ?? 0;

          totalSales =
              (data['totalSales'] ?? 0).toDouble();

          isLoadingStats = false;
        });
      } else {
        throw Exception(
          data['message'] ??
              'Failed to load dashboard statistics',
        );
      }
    } catch (e) {
      setState(() {
        isLoadingStats = false;
        errorMessage = e.toString();
      });
    }
  }

  // ============================================================
  // LOAD USERS
  // ============================================================

  Future<void> _loadUsers() async {
    setState(() {
      isLoadingTable = true;
      errorMessage = null;
    });

    try {
      final headers =
          await AuthService.getAuthHeaders();

      final response = await http.get(
        Uri.parse(
          '${AuthService.baseUrl}/admin/users',
        ),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          users = data['users'] ?? [];
          isLoadingTable = false;
        });
      } else {
        throw Exception(
          data['message'] ??
              'Failed to load users',
        );
      }
    } catch (e) {
      setState(() {
        isLoadingTable = false;
        errorMessage = e.toString();
      });
    }
  }

  // ============================================================
  // LOAD PRODUCTS
  // ============================================================

  Future<void> _loadProducts() async {
    setState(() {
      isLoadingTable = true;
      errorMessage = null;
    });

    try {
      final headers =
          await AuthService.getAuthHeaders();

      final response = await http.get(
        Uri.parse(
          '${AuthService.baseUrl}/admin/products',
        ),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          products = data['products'] ?? [];
          isLoadingTable = false;
        });
      } else {
        throw Exception(
          data['message'] ??
              'Failed to load products',
        );
      }
    } catch (e) {
      setState(() {
        isLoadingTable = false;
        errorMessage = e.toString();
      });
    }
  }

  // ============================================================
  // LOAD ORDERS
  // ============================================================

  Future<void> _loadOrders() async {
    setState(() {
      isLoadingTable = true;
      errorMessage = null;
    });

    try {
      final headers =
          await AuthService.getAuthHeaders();

      final response = await http.get(
        Uri.parse(
          '${AuthService.baseUrl}/admin/orders',
        ),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          orders = data['orders'] ?? [];
          isLoadingTable = false;
        });
      } else {
        throw Exception(
          data['message'] ??
              'Failed to load orders',
        );
      }
    } catch (e) {
      setState(() {
        isLoadingTable = false;
        errorMessage = e.toString();
      });
    }
  }

  // ============================================================
  // CHANGE PAGE
  // ============================================================

  void _changePage(String page) {
    setState(() {
      _currentPage = page;
      errorMessage = null;
    });

    if (page == 'Dashboard') {
      _loadDashboardStats();
    } else if (page == 'Users') {
      _loadUsers();
    } else if (page == 'Products') {
      _loadProducts();
    } else if (page == 'Orders') {
      _loadOrders();
    }
  }

  // ============================================================
  // DELETE USER
  // ============================================================

  Future<void> _deleteUser(String id) async {
    try {
      final headers =
          await AuthService.getAuthHeaders();

      final response = await http.delete(
        Uri.parse(
          '${AuthService.baseUrl}/admin/users/$id',
        ),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await _loadUsers();
        await _loadDashboardStats();

        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(
            const SnackBar(
              content:
                  Text('User deleted successfully'),
            ),
          );
        }
      } else {
        throw Exception(
          data['message'] ??
              'Failed to delete user',
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  // ============================================================
  // DELETE PRODUCT
  // ============================================================

  Future<void> _deleteProduct(String id) async {
    try {
      final headers =
          await AuthService.getAuthHeaders();

      final response = await http.delete(
        Uri.parse(
          '${AuthService.baseUrl}/admin/products/$id',
        ),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await _loadProducts();
        await _loadDashboardStats();

        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(
            const SnackBar(
              content:
                  Text('Product deleted successfully'),
            ),
          );
        }
      } else {
        throw Exception(
          data['message'] ??
              'Failed to delete product',
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  // ============================================================
  // UPDATE ORDER STATUS
  // ============================================================

  Future<void> _updateOrderStatus(
    String id,
    String status,
  ) async {
    try {
      final headers =
          await AuthService.getAuthHeaders();

      final response = await http.put(
        Uri.parse(
          '${AuthService.baseUrl}/admin/orders/$id',
        ),
        headers: headers,
        body: jsonEncode({
          'status': status,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await _loadOrders();
        await _loadDashboardStats();

        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(
            const SnackBar(
              content:
                  Text('Order status updated'),
            ),
          );
        }
      } else {
        throw Exception(
          data['message'] ??
              'Failed to update order',
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F7FA),

      body: Row(
        children: [

          // =====================================================
          // LEFT SIDEBAR
          // =====================================================

          Container(
            width: 250,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF0969E8),
            ),

            child: Column(
              children: [

                // LOGO
                const Padding(
                  padding: EdgeInsets.only(
                    top: 35,
                    left: 30,
                    right: 20,
                    bottom: 45,
                  ),
                  child: Align(
                    alignment:
                        Alignment.centerLeft,
                    child: Text(
                      'K-BEAUTY BD',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // DASHBOARD
                _sidebarItem(
                  icon:
                      Icons.dashboard_outlined,
                  title: 'Dashboard',
                  selected:
                      _currentPage ==
                          'Dashboard',
                  onTap: () {
                    _changePage(
                        'Dashboard');
                  },
                ),

                // PRODUCTS
                _sidebarItem(
                  icon:
                      Icons.inventory_2_outlined,
                  title: 'Products',
                  selected:
                      _currentPage ==
                          'Products',
                  onTap: () {
                    _changePage(
                        'Products');
                  },
                ),

                // ORDERS
                _sidebarItem(
                  icon:
                      Icons.shopping_bag_outlined,
                  title: 'Orders',
                  selected:
                      _currentPage ==
                          'Orders',
                  onTap: () {
                    _changePage(
                        'Orders');
                  },
                ),

                // USERS
                _sidebarItem(
                  icon:
                      Icons.people_outline,
                  title: 'Users',
                  selected:
                      _currentPage ==
                          'Users',
                  onTap: () {
                    _changePage(
                        'Users');
                  },
                ),

                const Spacer(),

                // LOGOUT
                Padding(
                  padding:
                      const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 30,
                  ),
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(8),
                    onTap: () async {
                      await AuthService.logout();

                      if (mounted) {
                        Navigator.pop(
                            context);
                      }
                    },
                    child: Container(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        vertical: 13,
                        horizontal: 15,
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.logout,
                            color:
                                Colors.white,
                            size: 21,
                          ),
                          SizedBox(
                              width: 15),
                          Text(
                            'Logout',
                            style: TextStyle(
                              color:
                                  Colors.white,
                              fontSize: 15,
                              fontWeight:
                                  FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // FOOTER
                const Padding(
                  padding:
                      EdgeInsets.only(
                    left: 30,
                    bottom: 25,
                  ),
                  child: Align(
                    alignment:
                        Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          'K-BEAUTY BD',
                          style: TextStyle(
                            color:
                                Colors.white,
                            fontSize: 14,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'All rights reserved',
                          style: TextStyle(
                            color:
                                Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // =====================================================
          // RIGHT SIDE
          // =====================================================

          Expanded(
            child:
                SingleChildScrollView(
              padding:
                  const EdgeInsets.all(35),
              child:
                  _buildCurrentPage(),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CURRENT PAGE CONTENT
  // ============================================================

  Widget _buildCurrentPage() {
    switch (_currentPage) {
      case 'Products':
        return _buildProductsPage();

      case 'Orders':
        return _buildOrdersPage();

      case 'Users':
        return _buildUsersPage();

      default:
        return _buildDashboardPage();
    }
  }

  // ============================================================
  // DASHBOARD PAGE
  // ============================================================

  Widget _buildDashboardPage() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [

        const Text(
          'Welcome Admin 👋',
          style: TextStyle(
            fontSize: 32,
            fontWeight:
                FontWeight.w900,
            color:
                Color(0xFF303030),
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Dashboard Overview',
          style: TextStyle(
            fontSize: 17,
            color: Colors.black54,
          ),
        ),

        const SizedBox(height: 30),

        if (errorMessage != null)
          _errorBox(),

        LayoutBuilder(
          builder:
              (context, constraints) {
            final isSmall =
                constraints.maxWidth <
                    800;

            return GridView.count(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              crossAxisCount:
                  isSmall ? 1 : 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio:
                  isSmall ? 4 : 1.8,
              children: [

                _statCard(
                  icon:
                      Icons.inventory_2_outlined,
                  title:
                      'Total Products',
                  value:
                      isLoadingStats
                          ? '...'
                          : totalProducts
                              .toString(),
                ),

                _statCard(
                  icon:
                      Icons.people_outline,
                  title:
                      'Total Users',
                  value:
                      isLoadingStats
                          ? '...'
                          : totalUsers
                              .toString(),
                ),

                _statCard(
                  icon:
                      Icons.payments_outlined,
                  title:
                      'Total Sales',
                  value:
                      isLoadingStats
                          ? '...'
                          : '৳${totalSales.toStringAsFixed(2)}',
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 30),

        // QUICK ACCESS
        const Text(
          'Quick Access',
          style: TextStyle(
            fontSize: 22,
            fontWeight:
                FontWeight.w800,
            color:
                Color(0xFF303030),
          ),
        ),

        const SizedBox(height: 15),

        LayoutBuilder(
          builder:
              (context, constraints) {
            final isSmall =
                constraints.maxWidth <
                    700;

            return GridView.count(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              crossAxisCount:
                  isSmall ? 1 : 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio:
                  isSmall ? 3.2 : 2.5,
              children: [

                _dashboardCard(
                  icon:
                      Icons.inventory_2_outlined,
                  title: 'Products',
                  subtitle:
                      'Manage products',
                  onTap: () {
                    _changePage(
                        'Products');
                  },
                ),

                _dashboardCard(
                  icon:
                      Icons.shopping_bag_outlined,
                  title: 'Orders',
                  subtitle:
                      'View and manage orders',
                  onTap: () {
                    _changePage(
                        'Orders');
                  },
                ),

                _dashboardCard(
                  icon:
                      Icons.people_outline,
                  title: 'Users',
                  subtitle:
                      'View registered users',
                  onTap: () {
                    _changePage(
                        'Users');
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  // ============================================================
  // PRODUCTS PAGE
  // ============================================================

  Widget _buildProductsPage() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [

        _pageHeader(
          'Products',
          'All products in your database',
        ),

        const SizedBox(height: 25),

        if (isLoadingTable)
          const Center(
            child:
                CircularProgressIndicator(),
          )
        else if (errorMessage != null)
          _errorBox()
        else if (products.isEmpty)
          _emptyBox('No products found.')
        else
          _buildProductsTable(),
      ],
    );
  }

  // ============================================================
  // PRODUCTS TABLE
  // ============================================================

  Widget _buildProductsTable() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        scrollDirection:
            Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(
              label: Text('Product'),
            ),
            DataColumn(
              label: Text('Brand'),
            ),
            DataColumn(
              label: Text('Category'),
            ),
            DataColumn(
              label: Text('Price'),
            ),
            DataColumn(
              label: Text('Stock'),
            ),
            DataColumn(
              label: Text('Action'),
            ),
          ],
          rows: products.map((product) {

            final brand =
                product['brand'];

            final category =
                product['category'];

            return DataRow(
              cells: [

                DataCell(
                  Text(
                    product['name']
                            ?.toString() ??
                        'N/A',
                  ),
                ),

                DataCell(
                  Text(
                    brand is Map
                        ? brand['name']
                                ?.toString() ??
                            'N/A'
                        : 'N/A',
                  ),
                ),

                DataCell(
                  Text(
                    category is Map
                        ? category['name']
                                ?.toString() ??
                            'N/A'
                        : 'N/A',
                  ),
                ),

                DataCell(
                  Text(
                    '৳${product['price'] ?? 0}',
                  ),
                ),

                DataCell(
                  Text(
                    '${product['stock'] ?? 0}',
                  ),
                ),

                DataCell(
                  IconButton(
                    icon:
                        const Icon(
                      Icons.delete_outline,
                      color:
                          Colors.red,
                    ),
                    onPressed: () {
                      final id =
                          product['_id']
                              ?.toString();

                      if (id != null) {
                        _confirmDelete(
                          context,
                          'Delete Product',
                          'Are you sure you want to delete this product?',
                          () =>
                              _deleteProduct(id),
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // ============================================================
  // USERS PAGE
  // ============================================================

  Widget _buildUsersPage() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [

        _pageHeader(
          'Users',
          'All registered users',
        ),

        const SizedBox(height: 25),

        if (isLoadingTable)
          const Center(
            child:
                CircularProgressIndicator(),
          )
        else if (errorMessage != null)
          _errorBox()
        else if (users.isEmpty)
          _emptyBox('No users found.')
        else
          _buildUsersTable(),
      ],
    );
  }

  // ============================================================
  // USERS TABLE
  // ============================================================

  Widget _buildUsersTable() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        scrollDirection:
            Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(
              label: Text('Name'),
            ),
            DataColumn(
              label: Text('Email'),
            ),
            DataColumn(
              label: Text('Phone'),
            ),
            DataColumn(
              label: Text('Role'),
            ),
            DataColumn(
              label: Text('Action'),
            ),
          ],
          rows: users.map((user) {

            return DataRow(
              cells: [

                DataCell(
                  Text(
                    user['fullName']
                            ?.toString() ??
                        'N/A',
                  ),
                ),

                DataCell(
                  Text(
                    user['email']
                            ?.toString() ??
                        'N/A',
                  ),
                ),

                DataCell(
                  Text(
                    user['phone']
                            ?.toString() ??
                        'N/A',
                  ),
                ),

                DataCell(
                  Text(
                    user['role']
                            ?.toString() ??
                        'User',
                  ),
                ),

                DataCell(
                  IconButton(
                    icon:
                        const Icon(
                      Icons.delete_outline,
                      color:
                          Colors.red,
                    ),
                    onPressed: () {

                      final id =
                          user['_id']
                              ?.toString();

                      if (id != null) {
                        _confirmDelete(
                          context,
                          'Delete User',
                          'Are you sure you want to delete this user?',
                          () =>
                              _deleteUser(id),
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // ============================================================
  // ORDERS PAGE
  // ============================================================

  Widget _buildOrdersPage() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [

        _pageHeader(
          'Orders',
          'All orders from your database',
        ),

        const SizedBox(height: 25),

        if (isLoadingTable)
          const Center(
            child:
                CircularProgressIndicator(),
          )
        else if (errorMessage != null)
          _errorBox()
        else if (orders.isEmpty)
          _emptyBox('No orders found.')
        else
          _buildOrdersTable(),
      ],
    );
  }

  // ============================================================
  // ORDERS TABLE
  // ============================================================

  Widget _buildOrdersTable() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        scrollDirection:
            Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(
              label: Text('Order ID'),
            ),
            DataColumn(
              label: Text('Customer'),
            ),
            DataColumn(
              label: Text('Total'),
            ),
            DataColumn(
              label: Text('Payment'),
            ),
            DataColumn(
              label: Text('Status'),
            ),
            DataColumn(
              label: Text('Date'),
            ),
          ],
          rows: orders.map((order) {

            final user =
                order['user'];

            return DataRow(
              cells: [

                DataCell(
                  Text(
                    order['_id']
                            ?.toString()
                            .substring(
                              0,
                              8,
                            ) ??
                        'N/A',
                  ),
                ),

                DataCell(
                  Text(
                    user is Map
                        ? user['fullName']
                                ?.toString() ??
                            user['email']
                                ?.toString() ??
                            'N/A'
                        : 'N/A',
                  ),
                ),

                DataCell(
                  Text(
                    '৳${order['totalAmount'] ?? 0}',
                  ),
                ),

                DataCell(
                  Text(
                    order['paymentStatus']
                            ?.toString() ??
                        'Pending',
                  ),
                ),

                DataCell(
                  DropdownButton<String>(
                    value:
                        order['status']
                                ?.toString() ??
                            'Pending',
                    underline:
                        const SizedBox(),
                    items: const [
                      'Pending',
                      'Processing',
                      'Shipped',
                      'Delivered',
                      'Cancelled',
                    ].map(
                      (status) {
                        return DropdownMenuItem<
                            String>(
                          value: status,
                          child:
                              Text(status),
                        );
                      },
                    ).toList(),
                    onChanged:
                        (newStatus) {

                      if (newStatus !=
                          null) {

                        _updateOrderStatus(
                          order['_id']
                              .toString(),
                          newStatus,
                        );
                      }
                    },
                  ),
                ),

                DataCell(
                  Text(
                    _formatDate(
                      order['createdAt'],
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // ============================================================
  // SIDEBAR ITEM
  // ============================================================

  Widget _sidebarItem({
    required IconData icon,
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 3,
      ),
      child: InkWell(
        borderRadius:
            BorderRadius.circular(0),
        onTap: onTap,
        child: Container(
          height: 52,
          padding:
              const EdgeInsets.symmetric(
            horizontal: 25,
          ),
          decoration:
              BoxDecoration(
            color: selected
                ? Colors.white
                : Colors.transparent,
          ),
          child: Row(
            children: [

              Icon(
                icon,
                size: 22,
                color: selected
                    ? const Color(
                        0xFF0969E8)
                    : Colors.white,
              ),

              const SizedBox(
                  width: 18),

              Text(
                title,
                style: TextStyle(
                  color: selected
                      ? const Color(
                          0xFF0969E8)
                      : Colors.white,
                  fontSize: 15,
                  fontWeight: selected
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // STAT CARD
  // ============================================================

  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: Padding(
        padding:
            const EdgeInsets.all(20),
        child: Row(
          children: [

            Container(
              width: 55,
              height: 55,
              decoration:
                  BoxDecoration(
                color:
                    const Color(
                        0xFFE8F1FF),
                borderRadius:
                    BorderRadius.circular(
                        10),
              ),
              child: Icon(
                icon,
                size: 30,
                color:
                    const Color(
                        0xFF0969E8),
              ),
            ),

            const SizedBox(
                width: 18),

            Expanded(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment
                        .center,
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [

                  Text(
                    title,
                    style:
                        const TextStyle(
                      fontSize: 14,
                      color:
                          Colors.black54,
                    ),
                  ),

                  const SizedBox(
                      height: 5),

                  Text(
                    value,
                    style:
                        const TextStyle(
                      fontSize: 24,
                      fontWeight:
                          FontWeight.w900,
                      color:
                          Color(0xFF303030),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DASHBOARD CARD
  // ============================================================

  Widget _dashboardCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius:
            BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          child: Row(
            children: [

              Container(
                width: 55,
                height: 55,
                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                          0xFFE8F1FF),
                  borderRadius:
                      BorderRadius.circular(
                          10),
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color:
                      const Color(
                          0xFF0969E8),
                ),
              ),

              const SizedBox(
                  width: 18),

              Expanded(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .center,
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [

                    Text(
                      title,
                      style:
                          const TextStyle(
                        fontSize: 19,
                        fontWeight:
                            FontWeight.w800,
                        color:
                            Colors.black87,
                      ),
                    ),

                    const SizedBox(
                        height: 5),

                    Text(
                      subtitle,
                      style:
                          const TextStyle(
                        fontSize: 14,
                        color:
                            Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons
                    .arrow_forward_ios,
                size: 18,
                color:
                    Colors.black45,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PAGE HEADER
  // ============================================================

  Widget _pageHeader(
    String title,
    String subtitle,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [

        Text(
          title,
          style:
              const TextStyle(
            fontSize: 32,
            fontWeight:
                FontWeight.w900,
            color:
                Color(0xFF303030),
          ),
        ),

        const SizedBox(height: 8),

        Text(
          subtitle,
          style:
              const TextStyle(
            fontSize: 17,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // EMPTY BOX
  // ============================================================

  Widget _emptyBox(String message) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(40),
      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          message,
          style:
              const TextStyle(
            fontSize: 16,
            color:
                Colors.black54,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ERROR BOX
  // ============================================================

  Widget _errorBox() {
    return Container(
      width: double.infinity,
      margin:
          const EdgeInsets.only(
        bottom: 20,
      ),
      padding:
          const EdgeInsets.all(15),
      decoration:
          BoxDecoration(
        color:
            Colors.red.shade50,
        borderRadius:
            BorderRadius.circular(8),
      ),
      child: Row(
        children: [

          const Icon(
            Icons.error_outline,
            color: Colors.red,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              errorMessage ??
                  'Something went wrong.',
              style:
                  const TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CONFIRM DELETE
  // ============================================================

  void _confirmDelete(
    BuildContext context,
    String title,
    String message,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red,
                foregroundColor:
                    Colors.white,
              ),
              child:
                  const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // FORMAT DATE
  // ============================================================

  String _formatDate(dynamic value) {
    if (value == null) {
      return 'N/A';
    }

    try {
      final date =
          DateTime.parse(
        value.toString(),
      );

      return '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year}';
    } catch (_) {
      return 'N/A';
    }
  }
}

