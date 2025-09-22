import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rabcalc/main.dart'; 
import 'package:rabcalc/screens/upgrade_pro_screen.dart';
import 'package:rabcalc/screens/edit_profile_screen.dart';
import 'package:rabcalc/services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil data user yang sedang login
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil & Pengaturan'),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        children: [
          // --- BAGIAN PROFIL PENGGUNA (DIBUAT DINAMIS) ---
          Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primaryDark,
                backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                child: user?.photoURL == null
                    ? Text(
                      (user?.displayName ?? '').isNotEmpty
                        ? user!.displayName!.substring(0, 1).toUpperCase()
                        : 'U', // Jika kosong (null atau ""), tampilkan 'U'
                      style: const TextStyle(fontSize: 40, color: Colors.white),
                    )
                  : null,
              ),
              const SizedBox(height: 12),
              Text(
                user?.displayName ?? user?.email ?? 'Pengguna Baru',
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark)),
              const Text(
                'Kontraktor / Pemilik Rumah',
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
            // --- FUNGSI onTap DI-UPDATE ---
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfileScreen()),
              );
            }),
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

  // --- FUNGSI-FUNGSI HELPER DI BAWAH INI TETAP SAMA ---

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
}