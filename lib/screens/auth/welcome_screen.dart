// lib/screens/auth/welcome_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      backgroundColor: const Color(0xFFF7FAFF), // Warna background dari kode baru
      body: Stack( // Dibungkus Stack untuk menampung dekorasi latar belakang
        children: [
          // --- Dekorasi Latar Belakang (SVG) dari Kode Baru ---
          Positioned(
            top: -50,
            right: -80,
            child: SvgPicture.asset('assets/vectors/bg_shape_2.svg', width: 250),
          ),
          Positioned(
            bottom: -20,
            left: -100,
            child: SvgPicture.asset('assets/vectors/bg_shape_1.svg', width: 300),
          ),
          Positioned(
            bottom: 180,
            right: 40,
            child: SvgPicture.asset('assets/vectors/icon_group_9.svg', width: 54),
          ),
          Positioned(
            top: 150,
            left: 20,
            child: SvgPicture.asset('assets/vectors/icon_group_10.svg', width: 65),
          ),

          // --- Struktur Konten Utama dari Kode Lama ---
          Column(
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
                          height: size.height * 0.35, // Ukuran dari kode baru
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          "Selamat Datang di RabCalc",
                          textAlign: TextAlign.center,
                          // Style teks dari kode baru
                          style: TextStyle(
                            color: Color(0xFF030047),
                            fontSize: 30,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Estimasi biaya konstruksi dalam genggaman. Akurat, cepat, dan profesional.',
                            textAlign: TextAlign.center,
                            // Style teks dari kode baru
                            style: TextStyle(
                              color: const Color(0xFF030047).withValues(alpha: 0.7),
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
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
                  height: size.height * 0.35,
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
                          // Style tombol dari kode baru
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFCC3E),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(54),
                            ),
                          ),
                          child: const Text(
                            'SIGN IN',
                            style: TextStyle(
                              color: Color(0xFF030047),
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: () => Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const RegisterScreen())),
                          // Style tombol dari kode baru
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            side: const BorderSide(
                              width: 1.50,
                              color: Color(0xFFE1E5F4),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(54),
                            ),
                          ),
                          child: const Text(
                            'SIGN UP',
                            style: TextStyle(
                              color: Colors.white, // Disesuaikan agar terbaca
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
