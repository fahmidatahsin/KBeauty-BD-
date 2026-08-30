import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'auth_service.dart';
import 'main.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
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
    if (!mounted) return;

    setState(() {
      isLoadingStats = true;
      errorMessage = null;
    });

    try {
      final headers = await AuthService.getAuthHeaders();

      final response = await http.get(
        Uri.parse('${AuthService.baseUrl}/admin/dashboard'),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (!mounted) return;

        setState(() {
          totalProducts = data['totalProducts'] ?? 0;
          totalUsers = data['totalUsers'] ?? 0;

          final sales = data['totalSales'];

          if (sales is num) {
            totalSales = sales.toDouble();
          } else {
            totalSales = double.tryParse(sales?.toString() ?? '0') ?? 0;
          }

          isLoadingStats = false;
        });
      } else {
        throw Exception(
          data['message'] ?? 'Failed to load dashboard statistics',
        );
      }
    } catch (e) {
      if (!mounted) return;

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
    if (!mounted) return;

    setState(() {
      isLoadingTable = true;
      errorMessage = null;
    });

    try {
      final headers = await AuthService.getAuthHeaders();

      final response = await http.get(
        Uri.parse('${AuthService.baseUrl}/admin/users'),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (!mounted) return;

        setState(() {
          users = data['users'] ?? [];
          isLoadingTable = false;
        });
      } else {
        throw Exception(data['message'] ?? 'Failed to load users');
      }
    } catch (e) {
      if (!mounted) return;

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
    if (!mounted) return;

    setState(() {
      isLoadingTable = true;
      errorMessage = null;
    });

    try {
      final headers = await AuthService.getAuthHeaders();

      final response = await http.get(
        Uri.parse('${AuthService.baseUrl}/admin/products'),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (!mounted) return;

        setState(() {
          products = data['products'] ?? [];
          isLoadingTable = false;
        });
      } else {
        throw Exception(data['message'] ?? 'Failed to load products');
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingTable = false;
        errorMessage = e.toString();
      });
    }
  }

  // ============================================================
  // ENTITY NAME
  // ============================================================

  String _entityName(dynamic value) {
    if (value is Map) {
      return value['name']?.toString() ?? value['title']?.toString() ?? 'N/A';
    }

    final text = value?.toString().trim();

    if (text != null && text.isNotEmpty) {
      return text;
    }

    return 'N/A';
  }

  // ============================================================
  // REFERENCE ID
  // ============================================================

  String? _referenceId(dynamic value) {
    if (value is Map) {
      return value['_id']?.toString() ?? value['id']?.toString();
    }

    final id = value?.toString().trim();

    if (id == null || id.isEmpty) {
      return null;
    }

    return id;
  }

  // ============================================================
  // LOAD PRODUCT OPTIONS
  // ============================================================

  Future<List<dynamic>> _loadProductOptions(String endpoint) async {
    final headers = await AuthService.getAuthHeaders();

    final response = await http.get(
      Uri.parse('${AuthService.baseUrl}/$endpoint'),
      headers: headers,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'Failed to load $endpoint');
    }

    if (data is List) {
      return data;
    }

    if (data is Map) {
      final result = data[endpoint];

      if (result is List) {
        return result;
      }

      if (endpoint == 'brands' && data['brands'] is List) {
        return data['brands'];
      }

      if (endpoint == 'categories' && data['categories'] is List) {
        return data['categories'];
      }
    }

    return [];
  }

  // ============================================================
  // UPDATE PRODUCT
  // ============================================================

  Future<bool> _updateProduct(
    String id,
    Map<String, dynamic> changes, {
    String successMessage = 'Product updated successfully',
  }) async {
    try {
      final headers = await AuthService.getAuthHeaders();

      final response = await http.put(
        Uri.parse('${AuthService.baseUrl}/admin/products/$id'),
        headers: headers,
        body: jsonEncode(changes),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw Exception(data['message'] ?? 'Failed to update product');
      }

      await _loadProducts();
      await _loadDashboardStats();

      if (!mounted) return true;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(successMessage)));

      return true;
    } catch (e) {
      if (!mounted) return false;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );

      return false;
    }
  }

  // ============================================================
  // ADD PRODUCT
  // ============================================================

  Future<void> _showAddProductDialog() async {
    try {
      final brands = await _loadProductOptions('brands');

      final categories = await _loadProductOptions('categories');

      if (!mounted) return;

      final nameController = TextEditingController();

      final priceController = TextEditingController();

      final descriptionController = TextEditingController();

      final imageController = TextEditingController();

      final stockController = TextEditingController(text: '0');

      String? selectedBrand;
      String? selectedCategory;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          bool isSaving = false;

          return StatefulBuilder(
            builder: (dialogBuildContext, setDialogState) {
              Future<void> saveProduct() async {
                if (nameController.text.trim().isEmpty ||
                    selectedBrand == null ||
                    selectedCategory == null ||
                    priceController.text.trim().isEmpty ||
                    descriptionController.text.trim().isEmpty ||
                    imageController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(dialogBuildContext).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all required fields.'),
                    ),
                  );

                  return;
                }

                final price = double.tryParse(priceController.text.trim());

                final stock = int.tryParse(stockController.text.trim());

                if (price == null || price < 0) {
                  ScaffoldMessenger.of(dialogBuildContext).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid price.'),
                    ),
                  );

                  return;
                }

                if (stock == null || stock < 0) {
                  ScaffoldMessenger.of(dialogBuildContext).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Stock must be a non-negative whole number.',
                      ),
                    ),
                  );

                  return;
                }

                setDialogState(() {
                  isSaving = true;
                });

                try {
                  final headers = await AuthService.getAuthHeaders();

                  final response = await http.post(
                    Uri.parse('${AuthService.baseUrl}/products'),
                    headers: headers,
                    body: jsonEncode({
                      'name': nameController.text.trim(),
                      'brand': selectedBrand,
                      'category': selectedCategory,
                      'price': price,
                      'description': descriptionController.text.trim(),
                      'image': imageController.text.trim(),
                      'stock': stock,
                    }),
                  );

                  final data = jsonDecode(response.body);

                  if (response.statusCode != 201) {
                    throw Exception(data['message'] ?? 'Failed to add product');
                  }

                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }

                  await _loadProducts();
                  await _loadDashboardStats();

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Product added successfully')),
                  );
                } catch (e) {
                  if (!dialogBuildContext.mounted) {
                    return;
                  }

                  setDialogState(() {
                    isSaving = false;
                  });

                  ScaffoldMessenger.of(dialogBuildContext).showSnackBar(
                    SnackBar(
                      content: Text(
                        e.toString().replaceFirst('Exception: ', ''),
                      ),
                    ),
                  );
                }
              }

              return AlertDialog(
                title: const Text(
                  'Add Product',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: SizedBox(
                  width: 500,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Product Name',
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 15),

                        DropdownButtonFormField<String>(
                          initialValue: selectedBrand,
                          decoration: const InputDecoration(
                            labelText: 'Brand',
                            border: OutlineInputBorder(),
                          ),
                          items: brands
                              .map((brand) {
                                final id = _referenceId(brand);

                                if (id == null) {
                                  return null;
                                }

                                return DropdownMenuItem<String>(
                                  value: id,
                                  child: Text(_entityName(brand)),
                                );
                              })
                              .whereType<DropdownMenuItem<String>>()
                              .toList(),
                          onChanged: isSaving
                              ? null
                              : (value) {
                                  setDialogState(() {
                                    selectedBrand = value;
                                  });
                                },
                        ),

                        const SizedBox(height: 15),

                        DropdownButtonFormField<String>(
                          initialValue: selectedCategory,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(),
                          ),
                          items: categories
                              .map((category) {
                                final id = _referenceId(category);

                                if (id == null) {
                                  return null;
                                }

                                return DropdownMenuItem<String>(
                                  value: id,
                                  child: Text(_entityName(category)),
                                );
                              })
                              .whereType<DropdownMenuItem<String>>()
                              .toList(),
                          onChanged: isSaving
                              ? null
                              : (value) {
                                  setDialogState(() {
                                    selectedCategory = value;
                                  });
                                },
                        ),

                        const SizedBox(height: 15),

                        TextField(
                          controller: priceController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Price',
                            prefixText: '৳ ',
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 15),

                        TextField(
                          controller: stockController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Stock',
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 15),

                        TextField(
                          controller: descriptionController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 15),

                        TextField(
                          controller: imageController,
                          decoration: const InputDecoration(
                            labelText: 'Image URL',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: isSaving
                        ? null
                        : () {
                            Navigator.pop(dialogContext);
                          },
                    child: const Text('Cancel'),
                  ),

                  ElevatedButton(
                    onPressed: isSaving ? null : saveProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0969E8),
                      foregroundColor: Colors.white,
                    ),
                    child: isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Add Product'),
                  ),
                ],
              );
            },
          );
        },
      );

      nameController.dispose();
      priceController.dispose();
      descriptionController.dispose();
      imageController.dispose();
      stockController.dispose();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  // ============================================================
  // EDIT PRODUCT
  // ============================================================

  Future<void> _showEditProductDialog(Map<String, dynamic> product) async {
    try {
      final brands = await _loadProductOptions('brands');

      final categories = await _loadProductOptions('categories');

      if (!mounted) return;

      final productId = product['_id']?.toString();

      if (productId == null || productId.isEmpty) {
        throw Exception('Product ID not found');
      }

      final nameController = TextEditingController(
        text: product['name']?.toString() ?? '',
      );

      final priceController = TextEditingController(
        text: product['price']?.toString() ?? '',
      );

      final descriptionController = TextEditingController(
        text: product['description']?.toString() ?? '',
      );

      final imageController = TextEditingController(
        text: product['image']?.toString() ?? '',
      );

      final stockController = TextEditingController(
        text: product['stock']?.toString() ?? '0',
      );

      String? selectedBrand = _referenceId(product['brand']);

      String? selectedCategory = _referenceId(product['category']);

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          bool isSaving = false;

          return StatefulBuilder(
            builder: (dialogBuildContext, setDialogState) {
              Future<void> saveChanges() async {
                final price = double.tryParse(priceController.text.trim());

                final stock = int.tryParse(stockController.text.trim());

                if (nameController.text.trim().isEmpty ||
                    selectedBrand == null ||
                    selectedCategory == null ||
                    price == null ||
                    price < 0 ||
                    descriptionController.text.trim().isEmpty ||
                    imageController.text.trim().isEmpty ||
                    stock == null ||
                    stock < 0) {
                  ScaffoldMessenger.of(dialogBuildContext).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter valid product information.'),
                    ),
                  );

                  return;
                }

                setDialogState(() {
                  isSaving = true;
                });

                final success = await _updateProduct(productId, {
                  'name': nameController.text.trim(),
                  'brand': selectedBrand,
                  'category': selectedCategory,
                  'price': price,
                  'description': descriptionController.text.trim(),
                  'image': imageController.text.trim(),
                  'stock': stock,
                });

                if (!success) {
                  if (!dialogBuildContext.mounted) {
                    return;
                  }

                  setDialogState(() {
                    isSaving = false;
                  });

                  return;
                }

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              }

              return AlertDialog(
                title: const Text(
                  'Edit Product',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: SizedBox(
                  width: 500,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Product Name',
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 15),

                        DropdownButtonFormField<String>(
                          initialValue:
                              brands.any(
                                (brand) => _referenceId(brand) == selectedBrand,
                              )
                              ? selectedBrand
                              : null,
                          decoration: const InputDecoration(
                            labelText: 'Brand',
                            border: OutlineInputBorder(),
                          ),
                          items: brands
                              .map((brand) {
                                final id = _referenceId(brand);

                                if (id == null) {
                                  return null;
                                }

                                return DropdownMenuItem<String>(
                                  value: id,
                                  child: Text(_entityName(brand)),
                                );
                              })
                              .whereType<DropdownMenuItem<String>>()
                              .toList(),
                          onChanged: isSaving
                              ? null
                              : (value) {
                                  setDialogState(() {
                                    selectedBrand = value;
                                  });
                                },
                        ),

                        const SizedBox(height: 15),

                        DropdownButtonFormField<String>(
                          initialValue:
                              categories.any(
                                (category) =>
                                    _referenceId(category) == selectedCategory,
                              )
                              ? selectedCategory
                              : null,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(),
                          ),
                          items: categories
                              .map((category) {
                                final id = _referenceId(category);

                                if (id == null) {
                                  return null;
                                }

                                return DropdownMenuItem<String>(
                                  value: id,
                                  child: Text(_entityName(category)),
                                );
                              })
                              .whereType<DropdownMenuItem<String>>()
                              .toList(),
                          onChanged: isSaving
                              ? null
                              : (value) {
                                  setDialogState(() {
                                    selectedCategory = value;
                                  });
                                },
                        ),

                        const SizedBox(height: 15),

                        TextField(
                          controller: priceController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Price',
                            prefixText: '৳ ',
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 15),

                        TextField(
                          controller: stockController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Stock',
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 15),

                        TextField(
                          controller: descriptionController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 15),

                        TextField(
                          controller: imageController,
                          decoration: const InputDecoration(
                            labelText: 'Image URL',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: isSaving
                        ? null
                        : () {
                            Navigator.pop(dialogContext);
                          },
                    child: const Text('Cancel'),
                  ),

                  ElevatedButton(
                    onPressed: isSaving ? null : saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0969E8),
                      foregroundColor: Colors.white,
                    ),
                    child: isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Save Changes'),
                  ),
                ],
              );
            },
          );
        },
      );

      nameController.dispose();
      priceController.dispose();
      descriptionController.dispose();
      imageController.dispose();
      stockController.dispose();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  // ============================================================
  // LOAD ORDERS
  // ============================================================

  Future<void> _loadOrders() async {
    if (!mounted) return;

    setState(() {
      isLoadingTable = true;
      errorMessage = null;
    });

    try {
      final headers = await AuthService.getAuthHeaders();

      final response = await http.get(
        Uri.parse('${AuthService.baseUrl}/admin/orders'),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (!mounted) return;

        List<dynamic> loadedOrders = [];

        if (data is Map && data['orders'] is List) {
          loadedOrders = List<dynamic>.from(data['orders']);
        } else if (data is List) {
          loadedOrders = List<dynamic>.from(data);
        }

        setState(() {
          orders = loadedOrders;
          isLoadingTable = false;
        });
      } else {
        String message = 'Failed to load orders';

        if (data is Map && data['message'] != null) {
          message = data['message'].toString();
        }

        throw Exception(message);
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingTable = false;
        errorMessage = e.toString().replaceFirst('Exception: ', '');
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
      final headers = await AuthService.getAuthHeaders();

      final response = await http.delete(
        Uri.parse('${AuthService.baseUrl}/admin/users/$id'),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await _loadUsers();
        await _loadDashboardStats();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User deleted successfully')),
        );
      } else {
        throw Exception(data['message'] ?? 'Failed to delete user');
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  // ============================================================
  // DELETE PRODUCT
  // ============================================================

  Future<void> _deleteProduct(String id) async {
    try {
      final headers = await AuthService.getAuthHeaders();

      final response = await http.delete(
        Uri.parse('${AuthService.baseUrl}/admin/products/$id'),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await _loadProducts();
        await _loadDashboardStats();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product deleted successfully')),
        );
      } else {
        throw Exception(data['message'] ?? 'Failed to delete product');
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  // ============================================================
  // UPDATE ORDER STATUS
  // ============================================================

  Future<void> _updateOrderStatus(String id, String status) async {
    try {
      final headers = await AuthService.getAuthHeaders();

      final response = await http.put(
        Uri.parse('${AuthService.baseUrl}/admin/orders/$id'),
        headers: headers,
        body: jsonEncode({'status': status}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await _loadOrders();
        await _loadDashboardStats();

        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Order status updated')));
      } else {
        throw Exception(data['message'] ?? 'Failed to update order');
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Row(
        children: [
          // ======================================================
          // SIDEBAR
          // ======================================================

          Container(
            width: 250,
            height: double.infinity,
            decoration: const BoxDecoration(color: Color(0xFF0969E8)),
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
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'K-BEAUTY BD',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // DASHBOARD
                _sidebarItem(
                  icon: Icons.dashboard_outlined,
                  title: 'Dashboard',
                  selected: _currentPage == 'Dashboard',
                  onTap: () {
                    _changePage('Dashboard');
                  },
                ),

                // PRODUCTS
                _sidebarItem(
                  icon: Icons.inventory_2_outlined,
                  title: 'Products',
                  selected: _currentPage == 'Products',
                  onTap: () {
                    _changePage('Products');
                  },
                ),

                // ORDERS
                _sidebarItem(
                  icon: Icons.shopping_bag_outlined,
                  title: 'Orders',
                  selected: _currentPage == 'Orders',
                  onTap: () {
                    _changePage('Orders');
                  },
                ),

                // USERS
                _sidebarItem(
                  icon: Icons.people_outline,
                  title: 'Users',
                  selected: _currentPage == 'Users',
                  onTap: () {
                    _changePage('Users');
                  },
                ),

                const Spacer(),

                // LOGOUT
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 30,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () async {
                      await AuthService.logout();

                      if (!context.mounted) {
                        return;
                      }

                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const HomePage()),
                        (route) => false,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 13,
                        horizontal: 15,
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.logout, color: Colors.white, size: 21),
                          SizedBox(width: 15),
                          Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // FOOTER
                const Padding(
                  padding: EdgeInsets.only(left: 30, bottom: 25),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'K-BEAUTY BD',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'All rights reserved',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ======================================================
          // RIGHT SIDE
          // ======================================================
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(35),
              child: _buildCurrentPage(),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CURRENT PAGE
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Welcome Admin 👋',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Color(0xFF303030),
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Dashboard Overview',
          style: TextStyle(fontSize: 17, color: Colors.black54),
        ),

        const SizedBox(height: 30),

        if (errorMessage != null) _errorBox(),

        // ========================================================
        // STATISTICS
        // ========================================================
        LayoutBuilder(
          builder: (context, constraints) {
            final isSmall = constraints.maxWidth < 800;

            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),

              crossAxisCount: isSmall ? 1 : 3,

              crossAxisSpacing: 20,
              mainAxisSpacing: 20,

              // FIXED
              childAspectRatio: isSmall ? 4.5 : 1.8,

              children: [
                _statCard(
                  icon: Icons.inventory_2_outlined,
                  title: 'Total Products',
                  value: isLoadingStats ? '...' : totalProducts.toString(),
                ),

                _statCard(
                  icon: Icons.people_outline,
                  title: 'Total Users',
                  value: isLoadingStats ? '...' : totalUsers.toString(),
                ),

                _statCard(
                  icon: Icons.payments_outlined,
                  title: 'Total Sales',
                  value: isLoadingStats
                      ? '...'
                      : '৳${totalSales.toStringAsFixed(2)}',
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 35),

        // ========================================================
        // QUICK ACCESS
        // ========================================================
        const Text(
          'Quick Access',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF303030),
          ),
        ),

        const SizedBox(height: 15),

        LayoutBuilder(
          builder: (context, constraints) {
            final isSmall = constraints.maxWidth < 700;

            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),

              crossAxisCount: isSmall ? 1 : 3,

              crossAxisSpacing: 20,
              mainAxisSpacing: 20,

              // ==================================================
              // IMPORTANT OVERFLOW FIX
              // ==================================================
              //
              // OLD:
              // childAspectRatio: 2.5
              //
              // NEW:
              // 2.0 gives the cards more vertical space.
              //
              childAspectRatio: isSmall ? 3.5 : 2.0,

              children: [
                _dashboardCard(
                  icon: Icons.inventory_2_outlined,
                  title: 'Products',
                  subtitle: 'Manage products',
                  onTap: () {
                    _changePage('Products');
                  },
                ),

                _dashboardCard(
                  icon: Icons.shopping_bag_outlined,
                  title: 'Orders',
                  subtitle: 'View and manage orders',
                  onTap: () {
                    _changePage('Orders');
                  },
                ),

                _dashboardCard(
                  icon: Icons.people_outline,
                  title: 'Users',
                  subtitle: 'View registered users',
                  onTap: () {
                    _changePage('Users');
                  },
                ),
              ],
            );
          },
        ),

        // Extra space at bottom
        const SizedBox(height: 30),
      ],
    );
  }

  // ============================================================
  // PRODUCTS PAGE
  // ============================================================

  Widget _buildProductsPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _pageHeader('Products', 'All products in your database'),

        const SizedBox(height: 15),

        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton.icon(
            onPressed: _showAddProductDialog,
            icon: const Icon(Icons.add),
            label: const Text('Add Product'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0969E8),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        const SizedBox(height: 25),

        if (isLoadingTable)
          const Center(child: CircularProgressIndicator())
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Product')),
            DataColumn(label: Text('Brand')),
            DataColumn(label: Text('Category')),
            DataColumn(label: Text('Price')),
            DataColumn(label: Text('Stock')),
            DataColumn(label: Text('Edit')),
            DataColumn(label: Text('Delete')),
          ],
          rows: products.map((product) {
            final productId = product['_id']?.toString();

            final brand = product['brand'];

            final category = product['category'];

            final brandName = _entityName(brand);

            final categoryName = _entityName(category);

            return DataRow(
              cells: [
                DataCell(
                  SizedBox(
                    width: 220,
                    child: Text(
                      product['name']?.toString() ?? 'N/A',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

                DataCell(Text(brandName)),

                DataCell(Text(categoryName)),

                DataCell(Text('৳${product['price'] ?? 0}')),

                DataCell(Text('${product['stock'] ?? 0}')),

                DataCell(
                  IconButton(
                    tooltip: 'Edit Product',
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: Color(0xFF0969E8),
                    ),
                    onPressed: productId == null
                        ? null
                        : () {
                            _showEditProductDialog(product);
                          },
                  ),
                ),

                DataCell(
                  IconButton(
                    tooltip: 'Delete Product',
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: productId == null
                        ? null
                        : () {
                            _confirmDelete(
                              context,
                              'Delete Product',
                              'Are you sure you want to delete this product?',
                              () => _deleteProduct(productId),
                            );
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _pageHeader('Users', 'All registered users'),

        const SizedBox(height: 25),

        if (isLoadingTable)
          const Center(child: CircularProgressIndicator())
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Phone')),
            DataColumn(label: Text('Role')),
            DataColumn(label: Text('Action')),
          ],
          rows: users.map((user) {
            return DataRow(
              cells: [
                DataCell(Text(user['fullName']?.toString() ?? 'N/A')),

                DataCell(Text(user['email']?.toString() ?? 'N/A')),

                DataCell(Text(user['phone']?.toString() ?? 'N/A')),

                DataCell(Text(user['role']?.toString() ?? 'User')),

                DataCell(
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      final id = user['_id']?.toString();

                      if (id != null) {
                        _confirmDelete(
                          context,
                          'Delete User',
                          'Are you sure you want to delete this user?',
                          () => _deleteUser(id),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _pageHeader('Orders', 'All orders from your database'),

        const SizedBox(height: 25),

        if (isLoadingTable)
          const Center(child: CircularProgressIndicator())
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Order ID')),
            DataColumn(label: Text('Customer')),
            DataColumn(label: Text('Total')),
            DataColumn(label: Text('Payment')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Date')),
          ],
          rows: orders.map((order) {
            final user = order['user'];

            final orderId = order['_id']?.toString();

            String shortOrderId = 'N/A';

            if (orderId != null && orderId.length >= 8) {
              shortOrderId = orderId.substring(0, 8);
            }

            String currentStatus = order['status']?.toString() ?? 'Pending';

            const statuses = [
              'Pending',
              'Processing',
              'Shipped',
              'Delivered',
              'Cancelled',
            ];

            if (!statuses.contains(currentStatus)) {
              currentStatus = 'Pending';
            }

            return DataRow(
              cells: [
                DataCell(Text(shortOrderId)),

                DataCell(
                  Text(
                    user is Map
                        ? user['fullName']?.toString() ??
                              user['email']?.toString() ??
                              'N/A'
                        : 'N/A',
                  ),
                ),

                DataCell(Text('৳${order['totalAmount'] ?? 0}')),

                DataCell(Text(order['paymentStatus']?.toString() ?? 'Pending')),

                DataCell(
                  DropdownButton<String>(
                    value: currentStatus,
                    underline: const SizedBox(),
                    items: statuses.map((status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (newStatus) {
                      if (newStatus == null || orderId == null) {
                        return;
                      }

                      _updateOrderStatus(orderId, newStatus);
                    },
                  ),
                ),

                DataCell(Text(_formatDate(order['createdAt']))),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: selected ? const Color(0xFF0969E8) : Colors.white,
              ),

              const SizedBox(width: 18),

              Text(
                title,
                style: TextStyle(
                  color: selected ? const Color(0xFF0969E8) : Colors.white,
                  fontSize: 15,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
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
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F1FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 30, color: const Color(0xFF0969E8)),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF303030),
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
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          // Reduced vertical padding so
          // the content fits safely.
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ICON
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 30, color: const Color(0xFF0969E8)),
              ),

              const SizedBox(width: 15),

              // TEXT
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.2,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // ARROW
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.black45,
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

  Widget _pageHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Color(0xFF303030),
          ),
        ),

        const SizedBox(height: 8),

        Text(
          subtitle,
          style: const TextStyle(fontSize: 17, color: Colors.black54),
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
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
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
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              errorMessage ?? 'Something went wrong.',
              style: const TextStyle(color: Colors.red),
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
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                onConfirm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
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
      final date = DateTime.parse(value.toString());

      return '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year}';
    } catch (_) {
      return 'N/A';
    }
  }
}
