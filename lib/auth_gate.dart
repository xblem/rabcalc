// lib/auth_gate.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rabcalc/screens/auth/login_screen.dart';
import 'package:rabcalc/screens/main_screen.dart';
import 'package:rabcalc/services/auth_service.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().user, // Mendengarkan perubahan status auth
      builder: (context, snapshot) {
        // Jika sedang loading, tampilkan loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        // Jika user sudah login (data tidak null)
        if (snapshot.hasData) {
          return const MainScreen();
        }
        
        // Jika user belum login
        return const LoginScreen();
      },
    );
  }
}