// lib/screens/results_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rabcalc/providers/rab_provider.dart';
import 'package:intl/intl.dart';
import 'package:rabcalc/main.dart';
import 'package:rabcalc/utils/pdf_generator.dart';
import 'package:rabcalc/utils/excel_generator.dart';
import 'package:rabcalc/utils/show_custom_flushbar.dart';
import 'package:rabcalc/utils/string_extensions.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  bool _isGeneratingPdf = false;
  bool _isGeneratingExcel = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hasil Estimasi RAB')),
      body: Consumer<RabProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.calculationResult == null || provider.calculationResult!.containsKey('error')) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  provider.calculationResult?['error'] ?? 'Terjadi kesalahan.',
                  textAlign: TextAlign.center, style: const TextStyle(color: Colors.red),
                ),
              )
            );
          }
          return _buildResults(context, provider);
        },
      ),
    );
  }

  Widget _buildResults(BuildContext context, RabProvider provider) {
    final rabData = provider.rabData;
    final rabResult = provider.calculationResult!['hasil_rab'];
    final totalBiaya = rabResult['total_biaya_konstruksi_rp'];
    final rincian = rabResult['rincian_biaya'];
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
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
        
        _buildSectionTitle('Ringkasan Proyek'),
        Card(
          child: Column(
            children: [
              _buildInfoRow('Nama Proyek', rabData.projectName ?? '-'),
              _buildInfoRow('Lokasi', rabData.location ?? '-'),
              _buildInfoRow('Jumlah Lantai', rabData.floorCount?.toString() ?? '-'),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // KARTU RINGKASAN SPESIFIKASI MATERIAL DIHAPUS SESUAI KODE BARU

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
        const SizedBox(height: 40),

        ElevatedButton.icon(
          icon: _isGeneratingPdf 
              ? Container(width: 24, height: 24, padding: const EdgeInsets.all(2.0), child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 3)) 
              : const Icon(Icons.picture_as_pdf, color: Colors.white),
          label: Text(_isGeneratingPdf ? 'MEMBUAT PDF...' : 'Download Laporan PDF'),
          onPressed: _isGeneratingPdf ? null : () async {
            setState(() => _isGeneratingPdf = true);
            try {
              await PdfGenerator.generateAndShowPdf(provider);
            } catch (e) {
              if (mounted) showErrorFlushbar(context, 'Gagal membuat PDF: ${e.toString()}');
            } finally {
              if (mounted) setState(() => _isGeneratingPdf = false);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          icon: _isGeneratingExcel 
              ? Container(width: 24, height: 24, padding: const EdgeInsets.all(2.0), child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
              : const Icon(Icons.table_chart, color: Colors.white),
          label: Text(_isGeneratingExcel ? 'MEMBUAT EXCEL...' : 'Download Laporan Excel'),
          onPressed: _isGeneratingExcel ? null : () async {
            setState(() => _isGeneratingExcel = true);
            try {
              await ExcelGenerator.generateAndSaveExcel(provider);
            } catch (e) {
              if (mounted) showErrorFlushbar(context, 'Gagal membuat Excel: ${e.toString()}');
            } finally {
              if (mounted) setState(() => _isGeneratingExcel = false);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1D6F42),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

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