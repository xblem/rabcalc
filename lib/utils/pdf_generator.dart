// lib/utils/pdf_generator.dart

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:rabcalc/providers/rab_provider.dart';
import 'package:intl/intl.dart';
import 'package:rabcalc/models/rab_data.dart'; // <-- IMPORT BARU
import 'package:rabcalc/utils/string_extensions.dart'; // <-- IMPORT EXTENSION DARI FILE BARU

class PdfGenerator {
  static Future<void> generateAndShowPdf(RabProvider provider) async {
    final pdf = pw.Document();
    
    // 1. Muat Aset (Logo & Font)
    final logoImage = pw.MemoryImage(
      (await rootBundle.load('assets/images/logo_polos.png')).buffer.asUint8List(),
    );
    final font = await PdfGoogleFonts.poppinsRegular();
    final boldFont = await PdfGoogleFonts.poppinsBold();
    
    // Data yang dibutuhkan
    final rabData = provider.rabData;
    final calculationResult = provider.calculationResult?['hasil_rab'];
    if (calculationResult == null) return; // Keluar jika tidak ada hasil

    final rincianBiaya = calculationResult['rincian_biaya'] as Map<String, dynamic>;
    final totalBiayaKonstruksi = calculationResult['total_biaya_konstruksi_rp'];
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    // 2. Membuat halaman PDF
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: font, bold: boldFont),
        header: (context) => _buildHeader(logoImage),
        build: (context) => [
          _buildProjectInfo(rabData),
          pw.SizedBox(height: 24),
          _buildRabTable(rincianBiaya, currencyFormatter),
          pw.SizedBox(height: 24),
          _buildSummary(totalBiayaKonstruksi, currencyFormatter),
        ],
        footer: (context) => _buildFooter(),
      ),
    );

    // 3. Tampilkan PDF untuk dicetak atau disimpan
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // --- Widget-widget Pembantu untuk PDF ---

  static pw.Widget _buildHeader(pw.MemoryImage logo) {
    return pw.Container(
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300, width: 1.5)),
      ),
      padding: const pw.EdgeInsets.only(bottom: 10),
      margin: const pw.EdgeInsets.only(bottom: 20),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Row(
            children: [
              pw.Image(logo, height: 40),
              pw.SizedBox(width: 10),
              pw.Text('RabCalc', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24)),
            ]
          ),
          pw.Text('Rencana Anggaran Biaya', style: const pw.TextStyle(fontSize: 16, color: PdfColors.grey700)),
        ],
      ),
    );
  }

  static pw.Widget _buildProjectInfo(RabData data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _infoRow('Nama Proyek:', data.projectName ?? '-'),
        _infoRow('Lokasi Proyek:', data.location ?? '-'),
        _infoRow('Tanggal Dokumen:', DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.now())),
      ]
    );
  }

  // FUNGSI _buildRabTable DIPERBARUI DARI KODE BARU
  static pw.Widget _buildRabTable(Map<String, dynamic> rincian, NumberFormat formatter) {
    final headers = ['No', 'Uraian Pekerjaan', 'Volume', 'Satuan', 'Harga Satuan (Rp)', 'Jumlah Harga (Rp)'];
    int i = 1;
    final data = rincian.entries.map((entry) {
      String uraian = entry.key.replaceAll('_', ' ').replaceAll('pekerjaan ', '').capitalize();
      String satuan = entry.key.split('_').last;
      return [
        (i++).toString(),
        uraian,
        entry.value['volume'].toString(),
        satuan,
        formatter.format(entry.value['harga_satuan_rp']),
        formatter.format(entry.value['jumlah_harga_rp']),
      ];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
      cellStyle: const pw.TextStyle(fontSize: 9),
      cellAlignments: {
        0: pw.Alignment.center,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
        4: pw.Alignment.centerRight,
        5: pw.Alignment.centerRight,
      },
      columnWidths: {
        0: const pw.FlexColumnWidth(0.5),
        1: const pw.FlexColumnWidth(4),
        2: const pw.FlexColumnWidth(1),
        3: const pw.FlexColumnWidth(1),
        4: const pw.FlexColumnWidth(2),
        5: const pw.FlexColumnWidth(2.5),
      }
    );
  }

  static pw.Widget _buildSummary(double total, NumberFormat formatter) {
    final ppn = total * 0.11;
    final totalAkhir = total + ppn;
    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.SizedBox(
        width: 280,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Divider(color: PdfColors.grey300),
            _summaryRow('Subtotal', formatter.format(total)),
            _summaryRow('PPN (11%)', formatter.format(ppn)),
            pw.Divider(color: PdfColors.grey300),
            _summaryRow('Total Akhir', formatter.format(totalAkhir), isBold: true),
          ]
        ),
      )
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Container(
      alignment: pw.Alignment.center,
      margin: const pw.EdgeInsets.only(top: 20),
      child: pw.Text('Dokumen ini dibuat secara otomatis oleh Aplikasi RabCalc', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey))
    );
  }
  
  static pw.Widget _infoRow(String title, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        children: [
          pw.SizedBox(width: 120, child: pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
          pw.Text(': $value'),
        ]
      )
    );
  }
  
  static pw.Widget _summaryRow(String title, String value, {bool isBold = false}) {
    final style = isBold ? pw.TextStyle(fontWeight: pw.FontWeight.bold) : const pw.TextStyle();
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(title, style: style),
          pw.Text(value, style: style),
        ]
      )
    );
  }
}