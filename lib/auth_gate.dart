// lib/auth_gate.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rabcalc/screens/auth/welcome_screen.dart';
import 'package:rabcalc/main.dart'; // Import file yang berisi widget MainScreen

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Tampilkan loading jika sedang memeriksa status
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // Jika user SUDAH login (snapshot punya data user)
        if (snapshot.hasData) {
          // Arahkan ke widget yang punya Bottom Nav Bar
          return const MainScreen(); 
        }

        // Jika user BELUM login
        return const WelcomeScreen(); // Arahkan ke pintu gerbang
      },
    );
  }
}