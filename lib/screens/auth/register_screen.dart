// lib/screens/auth/register_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rabcalc/main.dart';
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
  
  bool _isLoading = false;
  bool _isPasswordVisible = false;

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
    final authService = Provider.of<AuthService>(context, listen: false);

    // Validasi input
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
      _showErrorSnackbar("Semua kolom wajib diisi.");
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorSnackbar("Password dan Konfirmasi Password tidak cocok.");
      return;
    }
    RegExp passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    if (!passwordRegExp.hasMatch(_passwordController.text)) {
      _showErrorSnackbar("Password harus minimal 8 karakter, mengandung huruf dan angka.");
      return;
    }

    setState(() => _isLoading = true);
    
    final user = await authService.createUserWithEmail(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (user == null) {
      // Jika user null (gagal), hentikan loading dan tampilkan error
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorSnackbar("Gagal membuat akun. Email mungkin sudah terdaftar.");
      }
    }
    
    // Jika user berhasil dibuat, tutup halaman register ini.
    // AuthGate akan menangani navigasi ke halaman utama.
    if (mounted && user != null) {
      Navigator.pop(context);
    }
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
                const Text("Buat Akun,", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                Text("Mari kita mulai!", style: TextStyle(fontSize: 18, color: Colors.grey)),
                const SizedBox(height: 32),
                
                _buildTextField(hint: "Email", icon: Icons.email_outlined, controller: _emailController, keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 16),
                _buildTextField(hint: "Password", icon: Icons.lock_outline, controller: _passwordController, isPassword: true),
                const SizedBox(height: 16),
                _buildTextField(hint: "Konfirmasi Password", icon: Icons.lock_outline, controller: _confirmPasswordController, isPassword: true),
                const SizedBox(height: 32),
                
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Daftar Akun"),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Sudah punya akun?"),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Masuk", style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !_isPasswordVisible,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey.shade500),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,
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
