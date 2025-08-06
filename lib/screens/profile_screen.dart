// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:rabcalc/main.dart'; // Untuk AppColors
import 'package:rabcalc/screens/upgrade_pro_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // --- FUNGSI BARU UNTUK MENAMPILKAN DIALOG TENTANG ---
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
        content: const Text('RabCalc v1.0.0\nAplikasi kalkulator RAB cerdas untuk membantu perencanaan konstruksi Anda menjadi lebih mudah, cepat, dan akurat.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  // --- FUNGSI BARU UNTUK MENAMPILKAN DIALOG KELUAR ---
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () {
              // TODO: Tambahkan logika logout di sini
              Navigator.pop(context);
            },
            child: const Text('Ya, Keluar'),
          ),
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
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        children: [
          // --- Bagian Info Pengguna ---
          const Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primaryDark,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              SizedBox(height: 12),
              Text('Nama Pengguna', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text('Kontraktor / Pemilik Rumah', style: TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 30),

          // --- Bagian Upgrade ke Pro ---
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
                      onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const UpgradeProScreen()));
                      },
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

          // --- Bagian Menu Pengaturan (TOMBOL DIPERBARUI) ---
          _buildSettingsTile(icon: Icons.edit_outlined, title: 'Ubah Data Diri', onTap: () {}),
          _buildSettingsTile(icon: Icons.dark_mode_outlined, title: 'Mode Tampilan', onTap: () {}),
          _buildSettingsTile(icon: Icons.info_outline, title: 'Tentang Aplikasi', onTap: () => _showAboutDialog(context)),
          const Divider(indent: 20, endIndent: 20),
          _buildSettingsTile(icon: Icons.logout, title: 'Keluar', color: Colors.red.shade700, onTap: () => _showLogoutDialog(context)),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({required IconData icon, required String title, Color? color, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.grey.shade700),
      title: Text(title, style: TextStyle(color: color ?? Colors.black87, fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }
}