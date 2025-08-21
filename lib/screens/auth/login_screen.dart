// lib/screens/auth/login_screen.dart

import 'package:flutter/material.dart';
import 'package:rabcalc/main.dart';
import 'package:rabcalc/services/auth_service.dart';
import 'package:rabcalc/screens/auth/register_screen.dart'; // <-- IMPORT BARU

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
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
                Center(child: Image.asset("assets/images/login_illustration.png", height: 180)),
                const SizedBox(height: 24),
                const Text("Welcome Back,", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                Text("Sign in to continue!", style: TextStyle(fontSize: 18, color: Colors.grey)),
                const SizedBox(height: 32),
                _buildTextField(hint: "Email", icon: Icons.person_outline, controller: _emailController),
                const SizedBox(height: 16),
                _buildTextField(hint: "Password", icon: Icons.lock_outline, obscureText: true, controller: _passwordController),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                      _showErrorSnackbar("Email dan Password tidak boleh kosong.");
                      return;
                    }
                    setState(() => _isLoading = true);
                    final user = await _authService.signInWithEmail(_emailController.text, _passwordController.text);
                    if (!mounted) return;
                    setState(() => _isLoading = false);
                    if (user == null) {
                      _showErrorSnackbar("Login gagal. Periksa kembali email dan password Anda.");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("Sign In"),
                ),
                const SizedBox(height: 24),
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("OR", style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton('assets/images/logo_google.png', onPressed: () async {
                      setState(() => _isLoading = true);
                      await _authService.signInWithGoogle();
                      if (!mounted) return;
                      setState(() => _isLoading = false);
                    }),
                    const SizedBox(width: 20),
                    _buildSocialButton('assets/images/logo_facebook.png', onPressed: () async {
                        setState(() => _isLoading = true);
                        await _authService.signInWithFacebook();
                        if (!mounted) return;
                        setState(() => _isLoading = false);
                    }),
                  ],
                ),
                // --- KODE BARU DITAMBAHKAN DI SINI ---
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24), // Untuk padding bawah
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
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

  Widget _buildSocialButton(String imagePath, {required VoidCallback onPressed}) => OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(16),
      side: BorderSide(color: Colors.grey.shade300),
    ),
    child: Image.asset(imagePath, height: 28),
  );
}