// lib/screens/auth/register_screen.dart

import 'package:flutter/material.dart';
import 'package:rabcalc/main.dart'; // Untuk AppColors
import 'package:rabcalc/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _handleRegister() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorSnackbar("Email dan Password tidak boleh kosong.");
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorSnackbar("Password dan Konfirmasi Password tidak cocok.");
      return;
    }

    setState(() => _isLoading = true);
    final user = await _authService.createUserWithEmail(
      _emailController.text,
      _passwordController.text,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (user == null) {
      _showErrorSnackbar("Gagal membuat akun. Email mungkin sudah terdaftar atau password terlalu lemah.");
    }
    // Jika berhasil, AuthGate akan otomatis pindah ke MainScreen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(99),
            child: CircleAvatar(
              backgroundColor: AppColors.primaryAccent.withAlpha(50),
              child: const Icon(Icons.chevron_left, color: AppColors.primaryDark),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                Center(child: Image.asset("assets/images/register_illustration.png", height: 180)),
                const SizedBox(height: 24),
                const Text("Create Account,", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                Text("Let's get started!", style: TextStyle(fontSize: 18, color: Colors.grey)),
                const SizedBox(height: 32),
                _buildTextField(hint: "Email", icon: Icons.email_outlined, controller: _emailController),
                const SizedBox(height: 16),
                _buildTextField(hint: "Password", icon: Icons.lock_outline, obscureText: true, controller: _passwordController),
                const SizedBox(height: 16),
                _buildTextField(hint: "Confirm Password", icon: Icons.lock_outline, obscureText: true, controller: _confirmPasswordController),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("Sign Up"),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () => Navigator.pop(context), // Kembali ke halaman login
                      child: const Text("Sign In", style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({required String hint, required IconData icon, bool obscureText = false, required TextEditingController controller}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey.shade500),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.lightGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryDark, width: 1.5),
        ),
      ),
    );
  }
}