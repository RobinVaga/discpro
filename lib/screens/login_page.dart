import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  // Custom Colors from your Tailwind Config
  static const Color primaryColor = Color(0xFF94F906);
  static const Color backgroundDark = Color(0xFF1B230F);
  static const Color charcoal = Color(0xFF121212);

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
                          border: Border.all(color: primaryColor.withOpacity(0.2), width: 2),
                        ),
                        child: const Icon(Icons.album, color: primaryColor, size: 60),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Discpro',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'MASTER YOUR FLIGHT',
                        style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 2),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                // Headline
                const Text(
                  'Welcome Back',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sign in to track your scores and stats.',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),

                const SizedBox(height: 32),

                // Email Field
                _buildLabel('Email Address'),
                _buildTextField(hint: 'name@example.com', icon: Icons.mail_outline),

                const SizedBox(height: 20),

                // Password Field
                _buildLabel('Password'),
                _buildTextField(
                  hint: 'Enter your password',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  suffixIcon: Icons.visibility_off_outlined,
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Forgot Password?', style: TextStyle(color: primaryColor, decoration: TextDecoration.underline)),
                  ),
                ),

                const SizedBox(height: 24),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: backgroundDark,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                      elevation: 8,
                      shadowColor: primaryColor.withOpacity(0.4),
                    ),
                    child: const Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),

                const SizedBox(height: 32),

                // Divider
                const Row(
                  children: [
                    Expanded(child: Divider(color: Colors.white10)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('OR CONTINUE WITH', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    Expanded(child: Divider(color: Colors.white10)),
                  ],
                ),

                const SizedBox(height: 24),

                // Guest Sign In Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white24, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                    ),
                    icon: const Icon(Icons.person_outline, color: Colors.white70),
                    label: const Text(
                      'Continue as Guest',
                      style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account?', style: TextStyle(color: Colors.grey)),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text('Register', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
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
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
    IconData? suffixIcon,
  }) {
    return TextField(
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade600),
        prefixIcon: Icon(icon, color: primaryColor),
        suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Colors.grey) : null,
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
    );
  }
}