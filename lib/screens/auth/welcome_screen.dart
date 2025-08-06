import 'package:flutter/material.dart';
import 'package:rabcalc/screens/auth/login_screen.dart';
import 'package:rabcalc/screens/auth/register_screen.dart';
import 'package:rabcalc/widgets/auth_background_clipper.dart';
import 'package:rabcalc/main.dart'; 

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // Kita tidak pakai Stack lagi, tapi Column
      body: Column(
        children: <Widget>[
          // BAGIAN ATAS YANG FLEKSIBEL
          Expanded(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    Image.asset(
                      "assets/images/welcome_illustration.png",
                      height: size.height * 0.3,
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      "Selamat Datang di Aplikasi RabCalc",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Estimasi biaya konstruksi dalam genggaman. Akurat, cepat, dan profesional.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            height: 1.5),
                      ),
                    ),
                     const Spacer(flex: 3),
                  ],
                ),
              ),
            ),
          ),

          // BAGIAN BAWAH DENGAN UKURAN TETAP
          ClipPath(
            clipper: AuthBackgroundClipper(),
            child: Container(
              height: size.height * 0.35, // Ukuran tetap untuk area bawah
              width: double.infinity,
              color: AppColors.primaryDark,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const LoginScreen())),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryAccent,
                        foregroundColor: AppColors.primaryDark,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text("Sign In"),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen())),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        side: const BorderSide(color: AppColors.lightGray),
                      ),
                      child: const Text("Sign Up",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16)),
                    ),
                    // Memberi ruang agar tidak terlalu mepet ke bawah
                    SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
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