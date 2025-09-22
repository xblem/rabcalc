// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rabcalc/providers/rab_provider.dart';
import 'package:rabcalc/screens/project_data_screen.dart';
import 'package:rabcalc/main.dart'; // Untuk AppColors

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // PERBAIKAN: Menampilkan logo di samping teks
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo_polos.png', 
              height: 38,
              // Menambahkan error builder untuk memberi petunjuk jika file tidak ada
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error, color: Colors.red);
              },
            ),
            const SizedBox(width: 10),
             Flexible(
      child: const Text(
        'RabCalc',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.primaryDark,
        ),
      ),
    ),
  ],
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 1,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.05,
              child: Image.asset('assets/images/hero_bg.png', fit: BoxFit.cover),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                child: InkWell(
                  onTap: () {
                    Provider.of<RabProvider>(context, listen: false).startNewCalculation();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProjectDataScreen()));
                  },
                  borderRadius: BorderRadius.circular(16.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_home_work_outlined, size: 48.0, color: AppColors.primaryDark),
                        const SizedBox(height: 16.0),
                        const Text('Mulai Hitung RAB Rumah Baru', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8.0),
                        Text('Perkirakan biaya membangun rumah Anda dengan mudah.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}