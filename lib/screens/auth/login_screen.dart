// lib/screens/auth/login_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rabcalc/main.dart';
import 'package:rabcalc/services/auth_service.dart';
import 'package:rabcalc/screens/auth/register_screen.dart';
import 'package:rabcalc/utils/show_custom_flushbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      showErrorFlushbar(context, "Email dan Password tidak boleh kosong.");
      return;
    }
    
    setState(() => _isLoading = true);
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = await authService.signInWithEmail(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    
    if (mounted) {
      setState(() => _isLoading = false);
    }
    
    if (user == null && mounted) {
      showErrorFlushbar(context, "Login Gagal. Periksa kembali email dan password Anda.");
    }
  }

  Future<void> _handleGoogleLogin() async {
      setState(() => _isLoading = true);
      final authService = Provider.of<AuthService>(context, listen: false);
      final user = await authService.signInWithGoogle();
      if (mounted) {
        setState(() => _isLoading = false);
      }
      if (user == null && mounted) {
        showErrorFlushbar(context, "Login dengan Google gagal.");
      }
  }
  
  Future<void> _handleFacebookLogin() async {
      setState(() => _isLoading = true);
      final authService = Provider.of<AuthService>(context, listen: false);
      final user = await authService.signInWithFacebook();
       if (mounted) {
        setState(() => _isLoading = false);
      }
      if (user == null && mounted) {
        showErrorFlushbar(context, "Login dengan Facebook dibatalkan atau gagal.");
      }
  }

  // --- FUNGSI BARU UNTUK GUEST LOGIN ---
  Future<void> _handleGuestLogin() async {
    setState(() => _isLoading = true);
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = await authService.signInAnonymously();
    if (mounted) {
      setState(() => _isLoading = false);
    }
    if (user == null && mounted) {
      showErrorFlushbar(context, "Gagal masuk sebagai tamu.");
    }
    // Jika berhasil, AuthGate akan otomatis bernavigasi
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
                const Text("Selamat Datang,", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                Text("Sign in to continue!", style: TextStyle(fontSize: 18, color: Colors.grey)),
                const SizedBox(height: 32),
                _buildTextField(hint: "Email", icon: Icons.person_outline, controller: _emailController),
                const SizedBox(height: 16),
                _buildTextField(hint: "Password", icon: Icons.lock_outline, obscureText: true, controller: _passwordController),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 3,)
                    : const Text("Sign In"),
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
                    _buildSocialButton('assets/images/logo_google.png', onPressed: _isLoading ? (){} : _handleGoogleLogin),
                    const SizedBox(width: 20),
                    _buildSocialButton('assets/images/logo_facebook.png', onPressed: _isLoading ? (){} : _handleFacebookLogin),
                  ],
                ),
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
                // --- TOMBOL BARU DITAMBAHKAN DI SINI ---
                Center(
                  child: TextButton(
                    onPressed: _isLoading ? null : _handleGuestLogin,
                    child: const Text(
                      "Masuk sebagai Tamu",
                       style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
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