// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rabcalc/main.dart'; // Untuk AppColors
import 'package:rabcalc/screens/upgrade_pro_screen.dart';
import 'package:rabcalc/services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Image.asset('assets/images/logo_polos.png', height: 40),
            const SizedBox(width: 12),
            const Text('Tentang RabCalc'),
          ],
        ),
        content: const Text(
            'RabCalc v1.0.0\nAplikasi kalkulator RAB cerdas untuk perencanaan konstruksi yang lebih mudah, cepat, dan akurat.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup')),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context); // Tutup dialog
              await authService.signOut();
            },
            child: const Text('Ya, Keluar')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil & Pengaturan'),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true, // DIPERBARUI
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        children: [
          const Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primaryDark,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              SizedBox(height: 12),
              Text('Nama Pengguna',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark)), // DIPERBARUI
              Text('Kontraktor / Pemilik Rumah',
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 30),
          Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Card(
        color: AppColors.primaryDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Upgrade ke RabCalc Pro', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              const Text('Dapatkan fitur tak terbatas, simpan riwayat, dan ekspor laporan tanpa batas.', style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UpgradeProScreen())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryAccent,
                  foregroundColor: AppColors.primaryDark
                ),
                child: const Text('Lihat Benefit'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildSettingsTile(
              icon: Icons.edit_outlined,
              title: 'Ubah Data Diri',
              onTap: () {}),
          _buildSettingsTile(
              icon: Icons.dark_mode_outlined,
              title: 'Mode Tampilan',
              onTap: () {}),
          _buildSettingsTile(
              icon: Icons.info_outline,
              title: 'Tentang Aplikasi',
              onTap: () => _showAboutDialog(context)),
          const Divider(indent: 20, endIndent: 20),
          _buildSettingsTile(
              icon: Icons.logout,
              title: 'Keluar',
              color: Colors.red.shade700,
              onTap: () => _showLogoutDialog(context)),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    Color? color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.grey.shade700),
      title: Text(title,
          style: TextStyle(
              color: color ?? Colors.black87, fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }
}