// lib/screens/edit_profile_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rabcalc/widgets/custom_dialog.dart'; // <-- IMPORT DIGANTI

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _user = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = _user?.displayName ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // --- FUNGSI INI DI-UPGRADE TOTAL ---
  Future<void> _saveProfile() async {
    if (_nameController.text.trim().isEmpty) {
      showCustomStatusDialog(
        context: context,
        isSuccess: false,
        title: 'ERROR!',
        message: 'Nama tidak boleh kosong. Silakan coba lagi.',
        buttonText: 'Mengerti',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _user?.updateDisplayName(_nameController.text.trim());
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .update({'displayName': _nameController.text.trim()});
          
      if (mounted) {
        showCustomStatusDialog(
          context: context,
          isSuccess: true,
          title: 'BERHASIL!',
          message: 'Data profil Anda telah berhasil diperbarui.',
          buttonText: 'Selesai',
          onButtonPressed: () {
            Navigator.of(context).pop(); // Tutup dialog
            Navigator.of(context).pop(); // Kembali ke halaman profil
          },
        );
      }
    } catch (e) {
      if (mounted) {
        showCustomStatusDialog(
          context: context,
          isSuccess: false,
          title: 'ERROR!',
          message: 'Terjadi kesalahan saat menyimpan data. Silakan coba lagi.',
          buttonText: 'Mengerti',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubah Data Diri'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Nama Lengkap',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Simpan Perubahan'),
          ),
        ],
      ),
    );
  }
}