import 'package:flutter/material.dart';
import 'package:rabcalc/main.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0,
        // Tombol Kembali Custom
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(99),
            child: CircleAvatar(
              backgroundColor: AppColors.primaryAccent,
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
            // Ilustrasi Ditambahkan Kembali
            Center(child: Image.asset("assets/images/register_illustration.png", height: 180)),
            const SizedBox(height: 24),
            const Text("Create Account", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
            Text("Let's get started with a free account", style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
            const SizedBox(height: 32),
            _buildTextField(hint: "Nama Lengkap", icon: Icons.person_outline),
            const SizedBox(height: 16),
            _buildTextField(hint: "Email", icon: Icons.email_outlined),
            const SizedBox(height: 16),
            _buildTextField(hint: "Password", icon: Icons.lock_outline, obscureText: true),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () { /* Logika registrasi nanti */ },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Sign Up"),
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
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.lightGray)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primaryDark, width: 1.5)),
      ),
    );
  }
}