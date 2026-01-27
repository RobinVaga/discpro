import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Custom Colors
  static const Color primaryColor = Color(0xFF94F906);
  static const Color backgroundDark = Color(0xFF1B230F);
  static const Color charcoal = Color(0xFF121212);

  bool _isPasswordVisible = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [charcoal, backgroundDark],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                
                // Branding Logo
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: primaryColor.withOpacity(0.2),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.album,
                          color: primaryColor,
                          size: 60,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Discpro',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'MASTER YOUR FLIGHT',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                // Headline
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Join the community and track your progress.',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),

                const SizedBox(height: 32),

                // Full Name Field
                _buildLabel('Full Name'),
                _buildTextField(
                  controller: _nameController,
                  hint: 'Enter your name',
                  icon: Icons.person_outline,
                ),

                const SizedBox(height: 20),

                // Email Field
                _buildLabel('Email Address'),
                _buildTextField(
                  controller: _emailController,
                  hint: 'name@example.com',
                  icon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 20),

                // Password Field
                _buildLabel('Password'),
                _buildTextField(
                  controller: _passwordController,
                  hint: 'Create a password',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  suffixIcon: _isPasswordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  onSuffixIconTap: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),

                const SizedBox(height: 40),

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle registration logic here
                      // For now, navigate to home page
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: backgroundDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      elevation: 8,
                      shadowColor: primaryColor.withOpacity(0.4),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // Footer - Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFD1D5DB),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    IconData? suffixIcon,
    VoidCallback? onSuffixIconTap,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !_isPasswordVisible,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 15,
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.grey.shade500,
            size: 22,
          ),
          suffixIcon: suffixIcon != null
              ? IconButton(
                  icon: Icon(
                    suffixIcon,
                    color: Colors.grey.shade500,
                    size: 22,
                  ),
                  onPressed: onSuffixIconTap,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}