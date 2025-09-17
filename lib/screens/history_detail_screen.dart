// lib/screens/history_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rabcalc/main.dart'; // Untuk AppColors
import 'package:rabcalc/utils/string_extensions.dart';

class HistoryDetailScreen extends StatelessWidget {
  final Map<String, dynamic> calculationData;

  const HistoryDetailScreen({super.key, required this.calculationData});

  @override
  Widget build(BuildContext context) {
    // Membongkar data yang dikirim dari halaman riwayat
    final rabResult = calculationData['hasil_rab'];
    final projectInfo = calculationData['project_info'];
    final materialSelections = calculationData['material_selections'];

    final totalBiaya = rabResult['total_biaya_konstruksi_rp'];
    final rincian = rabResult['rincian_biaya'];
    
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: Text(projectInfo['project_name'] ?? 'Detail Proyek'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // KARTU HASIL UTAMA
          Card(
            color: AppColors.primaryDark,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Text('Total Biaya Konstruksi', style: TextStyle(fontSize: 18, color: Colors.white70)),
                  const SizedBox(height: 8),
                  Text(
                    currencyFormatter.format(totalBiaya),
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // --- Ringkasan Spesifikasi Material ---
          _buildSectionTitle('Ringkasan Spesifikasi Material'),
          Card(
            child: Column(
              children: (materialSelections as Map<String, dynamic>).entries.map((entry) {
                return _buildInfoRow(entry.key.replaceAll('_', ' ').capitalize(), entry.value ?? '-');
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // RINCIAN BIAYA
          _buildSectionTitle('Rincian Biaya per Pekerjaan'),
          Card(
            child: Column(
              children: (rincian as Map<String, dynamic>).entries.map((entry) {
                String uraian = entry.key.replaceAll('_', ' ').replaceAll('pekerjaan ', '').capitalize();
                return ListTile(
                  title: Text(uraian),
                  trailing: Text(currencyFormatter.format(entry.value['jumlah_harga_rp']), style: const TextStyle(fontWeight: FontWeight.w500)),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget untuk Judul Section
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Helper Widget untuk Baris Info
  Widget _buildInfoRow(String title, String value) {
    return ListTile(
      dense: true,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: Text(
        value,
        style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
        textAlign: TextAlign.right,
      ),
    );
  }
}