import 'package:flutter/material.dart';

// Clipper baru untuk membuat kurva di bagian ATAS dari sebuah container
class AuthBackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // Mulai dari kiri bawah container
    path.lineTo(0, size.height); 
    // Garis ke kanan bawah
    path.lineTo(size.width, size.height);
    // Garis ke kanan atas
    path.lineTo(size.width, size.height * 0.2);
    // Membuat kurva melengkung ke atas
    path.quadraticBezierTo(
      size.width / 2,
      0, // Titik kontrol di atas untuk membuat lengkungan ke bawah
      0,
      size.height * 0.2,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}