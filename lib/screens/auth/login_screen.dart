import 'package:flutter/material.dart';
import 'package:rabcalc/main.dart';
import 'package:rabcalc/screens/main_screen.dart' as main_screen;

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Center(child: Image.asset("assets/images/login_illustration.png", height: 180)),
            const SizedBox(height: 24),
            const Text("Welcome Back,", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
            Text("Sign in to continue!", style: TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 32),
            _buildTextField(hint: "Email atau Username", icon: Icons.person_outline),
            const SizedBox(height: 16),
            _buildTextField(hint: "Password", icon: Icons.lock_outline, obscureText: true),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Navigasi ke MainScreen dan hapus semua rute sebelumnya
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const main_screen.MainScreen()),
                  (route) => false,
                );
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
                _buildSocialButton('assets/images/logo_google.png'),
                const SizedBox(width: 20),
                _buildSocialButton('assets/images/logo_facebook.png'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String hint, required IconData icon, bool obscureText = false}) {
    return TextField(
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

  Widget _buildSocialButton(String imagePath) => OutlinedButton(
    onPressed: () {},
    style: OutlinedButton.styleFrom(
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(16),
      side: BorderSide(color: Colors.grey.shade300),
    ),
    child: Image.asset(imagePath, height: 28),
  );
}
