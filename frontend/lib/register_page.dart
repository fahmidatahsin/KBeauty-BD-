import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

 Future<void> register() async {
  final name = nameController.text.trim();
  final email = emailController.text.trim();
  final password = passwordController.text;
  final confirmPassword = confirmPasswordController.text;

  if (name.isEmpty ||
      email.isEmpty ||
      password.isEmpty ||
      confirmPassword.isEmpty) {
    _showMessage('Please fill in all fields.');
    return;
  }

  if (!email.contains('@')) {
    _showMessage('Please enter a valid email address.');
    return;
  }

  if (password.length < 6) {
    _showMessage('Password must be at least 6 characters.');
    return;
  }

  if (password != confirmPassword) {
    _showMessage('Passwords do not match.');
    return;
  }

  try {
    final response = await http.post(
      Uri.parse('http://localhost:5000/api/auth/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'fullName': name,
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (!mounted) return;

    if (response.statusCode == 201) {
      _showMessage(
        data['message'] ?? 'Registration successful!',
      );

      Navigator.pop(context);
    } else {
      _showMessage(
        data['message'] ?? 'Registration failed.',
      );
    }
  } catch (e) {
    if (!mounted) return;

    _showMessage(
      'Unable to connect to the server. '
      'Make sure the backend is running on port 5000.',
    );
  }
}

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration fieldDecoration({
    required String hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.85),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(
          color: Colors.black26,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(
          color: Colors.black26,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(
          color: Color(0xFF1976D2),
          width: 1.5,
        ),
      ),
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 600;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // BACKGROUND IMAGE
          Image.asset(
            'assets/images/hero-banner-2.jpg',
            fit: BoxFit.cover,
          ),

          // WHITE TRANSPARENT OVERLAY
          Container(
            color: Colors.white.withValues(alpha: 0.18),
          ),

          // REGISTRATION BOX
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 30,
                vertical: 30,
              ),
              child: Container(
                width: isMobile ? double.infinity : 390,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 22 : 20,
                  vertical: 22,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.78),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x40000000),
                      blurRadius: 12,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // TITLE
                    const Text(
                      'Create Account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // NAME
                    const Text(
                      'Name:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 6),

                    TextField(
                      controller: nameController,
                      decoration: fieldDecoration(
                        hint: 'Enter your name',
                      ),
                    ),

                    const SizedBox(height: 18),

                    // EMAIL
                    const Text(
                      'Email:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 6),

                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: fieldDecoration(
                        hint: 'Enter your email',
                      ),
                    ),

                    const SizedBox(height: 18),

                    // PASSWORD
                    const Text(
                      'Password:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 6),

                    TextField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      decoration: fieldDecoration(
                        hint: 'Enter your password',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // CONFIRM PASSWORD
                    const Text(
                      'Confirm Password:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 6),

                    TextField(
                      controller: confirmPasswordController,
                      obscureText: obscureConfirmPassword,
                      decoration: fieldDecoration(
                        hint: 'Confirm your password',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscureConfirmPassword =
                                  !obscureConfirmPassword;
                            });
                          },
                          icon: Icon(
                            obscureConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // REGISTER BUTTON
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF087EF5),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // BACK TO LOGIN
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                        ),
                      ),
                      child: const Text(
                        'Already have an account? Login',
                        style: TextStyle(
                          color: Color(0xFF087EF5),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}