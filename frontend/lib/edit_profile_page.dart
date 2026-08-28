
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'models/user.dart';

class EditProfilePage extends StatefulWidget {
  final User user;

  const EditProfilePage({
    super.key,
    required this.user,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController fullNameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    fullNameController =
        TextEditingController(text: widget.user.fullName);

    emailController =
        TextEditingController(text: widget.user.email);

    phoneController =
        TextEditingController(text: widget.user.phone);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  // ============================================================
  // SAVE PROFILE
  // ============================================================

  Future<void> _saveProfile() async {
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();

    if (fullName.isEmpty) {
      _showMessage('Please enter your name.');
      return;
    }

    if (email.isEmpty) {
      _showMessage('Please enter your email.');
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final data = await AuthService.updateProfile(
        fullName: fullName,
        email: email,
        phone: phone,
      );

      if (!mounted) return;

      final updatedUser = User.fromJson(data);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
        ),
      );

      Navigator.pop(context, updatedUser);
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F3F1),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'EDIT PROFILE',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),
            child: Container(
              padding: const EdgeInsets.all(28),
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
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Edit Your Information',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Update your account information below.',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    'Full Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: fullNameController,
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(6),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Email',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: emailController,
                    keyboardType:
                        TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(6),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Phone',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.phone_outlined),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(6),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton(
                      onPressed:
                          isSaving ? null : _saveProfile,
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF1C6A50),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(6),
                        ),
                      ),
                      child: isSaving
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child:
                                  CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'SAVE CHANGES',
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

