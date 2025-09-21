// lib/screens/results_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rabcalc/providers/rab_provider.dart';
import 'package:rabcalc/main.dart';
import 'package:rabcalc/utils/pdf_generator.dart';
import 'package:rabcalc/utils/excel_generator.dart';
import 'package:rabcalc/utils/show_custom_flushbar.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  bool _isGeneratingPdf = false;
  bool _isGeneratingExcel = false;

  // Helper untuk mengubah nilai dynamic menjadi String yang aman
  String _safeString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  // Helper untuk mengubah angka menjadi String dengan format 2 desimal
  String _safeDouble(dynamic value) {
    if (value is num) {
      return value.toStringAsFixed(2);
    }
    return '0.00';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Detail RAB Lengkap'),
        actions: [
          IconButton(
            icon: _isGeneratingPdf 
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white))
                : const Icon(Icons.picture_as_pdf),
            onPressed: _isGeneratingPdf ? null : () async {
              setState(() => _isGeneratingPdf = true);
              try {
                await PdfGenerator.generateAndShowPdf(Provider.of<RabProvider>(context, listen: false));
              } catch (e) {
                if (mounted) showErrorFlushbar(context, 'Gagal membuat PDF: ${e.toString()}');
              } finally {
                if (mounted) setState(() => _isGeneratingPdf = false);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share functionality
            },
          ),
        ],
      ),
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
                  _safeString(provider.calculationResult?['error'] ?? 'Terjadi kesalahan.'),
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
    // Membongkar semua data dari backend, termasuk data baru
    final results = provider.calculationResult!;
    final dataOrganisasiRuang = results['data_organisasi_ruang'] as Map<String, dynamic>? ?? {};
    final rencanaSpesifikasi = results['rencana_spesifikasi'] as List<dynamic>? ?? [];
    final hasilRab = results['hasil_rab'] as Map<String, dynamic>? ?? {};
    final rekapitulasi = hasilRab['rekapitulasi'] as Map<String, dynamic>? ?? {};
    final billOfQuantity = hasilRab['bill_of_quantity'] as List<dynamic>? ?? [];
    final kebutuhanSumberDaya = hasilRab['kebutuhan_sumber_daya'] as List<dynamic>? ?? [];
    final tabelKebutuhanBahan = hasilRab['tabel_kebutuhan_bahan'] as List<dynamic>? ?? []; 
    final tabelBiayaTenaga = hasilRab['tabel_kebutuhan_biaya_tenaga'] as List<dynamic>? ?? [];
    final tabelKebutuhanBiaya = hasilRab['tabel_kebutuhan_biaya'] as List<dynamic>? ?? [];
    final jadwalTenagaKerja = hasilRab['jadwal_tenaga_kerja'] as List<dynamic>? ?? [];
    final tabelCashFlow = hasilRab['tabel_cash_flow'] as List<dynamic>? ?? [];
    final jadwalPekerjaan = hasilRab['jadwal_pekerjaan'] as List<dynamic>? ?? [];
    final jadwalKebutuhanBahan = hasilRab['jadwal_kebutuhan_bahan'] as List<dynamic>? ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildProjectHeader(dataOrganisasiRuang['info_proyek'] as Map<String, dynamic>? ?? {}),
          const SizedBox(height: 24),

          _buildSectionTitle('1. DATA ORGANISASI RUANG'),
          _buildDataOrganisasiRuangTable(dataOrganisasiRuang['detail_ruang'] as List<dynamic>? ?? []),
          const SizedBox(height: 24),

          _buildSectionTitle('2. RENCANA SPESIFIKASI'),
          _buildRencanaSpesifikasiTable(rencanaSpesifikasi),
          const SizedBox(height: 24),
          
          _buildSectionTitle('3. REKAPITULASI BIAYA'),
          _buildRekapitulasiTable(rekapitulasi),
          const SizedBox(height: 16),
          _buildGrandTotal(hasilRab),
          const SizedBox(height: 24),

          _buildSectionTitle('4. BILL OF QUANTITY (BOQ)'),
          _buildGroupedBoq(billOfQuantity),
          const SizedBox(height: 24),
          
          _buildSectionTitle('5. KEBUTUHAN SUMBER DAYA PER KEGIATAN'),
          _buildSumberDayaTable(kebutuhanSumberDaya),
          const SizedBox(height: 24),

          _buildSectionTitle('6. TOTAL KEBUTUHAN MATERIAL'),
          _buildTotalMaterialTable(tabelKebutuhanBahan),
          const SizedBox(height: 24),

          _buildSectionTitle('7. KEBUTUHAN BIAYA TENAGA'),
          _buildBiayaTenagaTable(tabelBiayaTenaga),
          const SizedBox(height: 24),

          _buildSectionTitle('8. TOTAL KEBUTUHAN BIAYA'),
          _buildKebutuhanBiayaTable(tabelKebutuhanBiaya),
          const SizedBox(height: 24),

          _buildSectionTitle('9. JADWAL PEKERJAAN (13 Minggu)'),
          _buildJadwalPekerjaanTable(jadwalPekerjaan),
          const SizedBox(height: 24),
            
          _buildSectionTitle('10. JADWAL KEBUTUHAN BAHAN (13 Minggu)'),
          _buildJadwalBahanTable(jadwalKebutuhanBahan),
          const SizedBox(height: 24),

          _buildSectionTitle('11. JADWAL TENAGA KERJA (13 Minggu)'),
          _buildJadwalTenagaTable(jadwalTenagaKerja),
          const SizedBox(height: 24),

          _buildSectionTitle('12. CASH FLOW PROYEK (13 Minggu)'),
          _buildCashFlowTable(tabelCashFlow),
          const SizedBox(height: 32),
          
          ElevatedButton.icon(
            icon: _isGeneratingExcel 
                ? Container(width: 24, height: 24, padding: const EdgeInsets.all(2.0), child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                : const Icon(Icons.table_chart, color: Colors.white),
            label: Text(_isGeneratingExcel ? 'MEMBUAT EXCEL...' : 'Download Laporan Excel'),
            onPressed: _isGeneratingExcel ? null : () async {
              setState(() => _isGeneratingExcel = true);
              try {
                await ExcelGenerator.generateAndSaveExcel(provider);
                if (mounted) showSuccessFlushbar(context, 'File Excel berhasil disimpan di folder Downloads.');
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
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
                provider.startNewCalculation();
                Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Hitung RAB Baru'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
    );
  }

  Widget _buildProjectHeader(Map<String, dynamic> info) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_safeString(info['Nama']), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 20.0,
              runSpacing: 8.0,
              children: [
                _buildHeaderInfo('Lokasi', "${_safeString(info['Kabupaten/Kota'])}, ${_safeString(info['Provinsi'])}"),
                _buildHeaderInfo('Luas Tanah', _safeString(info['Luas Tanah'])),
                _buildHeaderInfo('Luas Bangunan', _safeString(info['Luas Bangunan'])),
                _buildHeaderInfo('Jumlah Lantai', _safeString(info['Jumlah Lantai'])),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildDataOrganisasiRuangTable(List<dynamic> detailRuang) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('NAMA RUANG')),
          DataColumn(label: Text('PANJANG (m)')),
          DataColumn(label: Text('LEBAR (m)')),
          DataColumn(label: Text('LUAS (m²)')),
          DataColumn(label: Text('JENDELA')),
        ],
        rows: detailRuang.map((ruang) => DataRow(cells: [
          DataCell(Text(_safeString(ruang['nama']))),
          DataCell(Text(_safeDouble(ruang['panjang']))),
          DataCell(Text(_safeDouble(ruang['lebar']))),
          DataCell(Text(_safeDouble(ruang['luas']))),
          DataCell(Text(_safeString(ruang['jendela']))),
        ])).toList(),
      ),
    );
  }

  Widget _buildRencanaSpesifikasiTable(List<dynamic> spesifikasi) {
     return Card(
       elevation: 1,
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
       child: Padding(
         padding: const EdgeInsets.all(12.0),
         child: Column(
           children: spesifikasi.map((spec) => Padding(
             padding: const EdgeInsets.symmetric(vertical: 4.0),
             child: Row(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Expanded(flex: 2, child: Text(_safeString(spec['pekerjaan']), style: const TextStyle(fontWeight: FontWeight.bold))),
                 const Text(" : "),
                 Expanded(flex: 3, child: Text(_safeString(spec['spesifikasi']))),
               ],
             ),
           )).toList(),
         ),
       ),
     );
  }
  
  Widget _buildRekapitulasiTable(Map<String, dynamic> rekap) {
     return Card(
       elevation: 2,
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
       child: DataTable(
         columns: const [
           DataColumn(label: Text('URAIAN PEKERJAAN')),
           DataColumn(label: Text('JUMLAH BIAYA'), numeric: true),
         ],
         rows: rekap.entries.map((entry) => DataRow(
           cells: [
             DataCell(Text(_safeString(entry.key))),
             DataCell(Text(_safeString(entry.value is Map ? entry.value['jumlah_rp'] : ''))),
           ]
         )).toList(),
       ),
     );
  }
  
  Widget _buildGrandTotal(Map<String, dynamic> hasilRab) {
     return Card(
       color: AppColors.primaryDark,
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
       child: Padding(
         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
         child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             const Text('GRAND TOTAL', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
             Text(_safeString(hasilRab['grand_total_rp']), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
           ],
         ),
       ),
     );
  }

  Widget _buildGroupedBoq(List<dynamic> boqItems) {
    if (boqItems.isEmpty) return const Text("Data BOQ tidak tersedia.");
    final groupedBoq = groupBy(boqItems, (dynamic item) => _safeString(item['kategori']));
    final categoryOrder = [
      'A. Pekerjaan Persiapan', 'B. Pekerjaan Tanah & Pondasi', 'C. Pekerjaan Beton Bertulang',
      'D. Pekerjaan Dinding', 'E. Pekerjaan Plesteran & Acian', 'F. Pekerjaan Atap',
      'G. Pekerjaan Plafon', 'H. Pekerjaan Kusen, Pintu & Kaca', 'I. Pekerjaan Lantai',
      'J. Pekerjaan Pelapis Dinding', 'K. Pekerjaan Sanitasi & Pemipaan', 'L. Pekerjaan Pengecatan',
      'M. Pekerjaan Listrik', 'N. Pekerjaan Kunci & Aksesori', 'O. Pekerjaan Pelengkap'
    ];

    List<Widget> boqWidgets = [];
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0);

    for (var category in categoryOrder) {
      if (!groupedBoq.containsKey(category)) continue;

      final itemsInCategory = groupedBoq[category]!;
      double subTotal = itemsInCategory.fold(0.0, (sum, item) => sum + ((item['jumlah_harga_raw'] as num?)?.toDouble() ?? 0.0));

      boqWidgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Text(category.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        )
      );

      boqWidgets.add(
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowHeight: 0,
            columns: const [
              DataColumn(label: Text('URAIAN')),
              DataColumn(label: Text('VOL')),
              DataColumn(label: Text('SAT')),
              DataColumn(label: Text('JUMLAH (Rp)')),
            ],
            rows: [
              ...itemsInCategory.map((item) => DataRow(cells: [
                DataCell(SizedBox(width: 200, child: Text(_safeString(item['uraian'])))),
                DataCell(Text(_safeString(item['volume']))),
                DataCell(Text(_safeString(item['satuan']))),
                DataCell(Text(_safeString(item['jumlah_harga_rp']).replaceAll('Rp ', ''))),
              ])),
              DataRow(
                cells: [
                  DataCell(Text('Sub Total ${category.replaceAll("Pekerjaan ", "")}', style: const TextStyle(fontWeight: FontWeight.bold))),
                  const DataCell(Text('')),
                  const DataCell(Text('')),
                  DataCell(Text(
                    currencyFormatter.format(subTotal),
                    style: const TextStyle(fontWeight: FontWeight.bold))
                  ),
                ]
              ),
            ],
          ),
        )
      );
    }

    final header = DataTable(
      headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[200]!),
      columns: const [
        DataColumn(label: SizedBox(width: 200, child: Text('URAIAN PEKERJAAN'))),
        DataColumn(label: Text('VOL'), numeric: true),
        DataColumn(label: Text('SAT')),
        DataColumn(label: Text('JUMLAH (Rp)'), numeric: true),
      ],
      rows: const [],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        ...boqWidgets,
      ],
    );
  }

  Widget _buildSumberDayaTable(List<dynamic> sumberDayaItems) {
    return Column(
      children: sumberDayaItems.map((kegiatan) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ExpansionTile(
            title: Text(
              _safeString(kegiatan['uraian_pekerjaan']),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Volume: ${_safeString(kegiatan['volume'])} ${_safeString(kegiatan['satuan'])} | Total: ${_safeString(kegiatan['total_harga_rp'])}",
            ),
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Komponen')),
                    DataColumn(label: Text('Volume'), numeric: true),
                    DataColumn(label: Text('Satuan')),
                    DataColumn(label: Text('Harga Satuan')),
                    DataColumn(label: Text('Jumlah Harga')),
                  ],
                  rows: ((kegiatan['detail'] as List<dynamic>?) ?? []).map((detail) {
                    return DataRow(cells: [
                      DataCell(Text(_safeString(detail['uraian']))),
                      DataCell(Text(_safeString(detail['volume']))),
                      DataCell(Text(_safeString(detail['satuan']))),
                      DataCell(Text(_safeString(detail['harga_satuan_rp']))),
                      DataCell(Text(_safeString(detail['jumlah_harga_rp']))),
                    ]);
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTotalMaterialTable(List<dynamic> materials) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Nama Material')),
          DataColumn(label: Text('Total Volume'), numeric: true),
          DataColumn(label: Text('Satuan')),
        ],
        rows: materials.map((mat) {
          return DataRow(cells: [
            DataCell(Text(_safeString(mat['nama']))),
            DataCell(Text(_safeString(mat['volume']))),
            DataCell(Text(_safeString(mat['satuan']))),
          ]);
        }).toList(),
      ),
    );
  }

  Widget _buildBiayaTenagaTable(List<dynamic> items) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Tenaga Kerja')),
        DataColumn(label: Text('Volume (Hari)')),
        DataColumn(label: Text('Total Biaya')),
      ],
      rows: items.map((item) => DataRow(cells: [
        DataCell(Text(_safeString(item['uraian']))),
        DataCell(Text(_safeString(item['volume']))),
        DataCell(Text(_safeString(item['biaya_rp']))),
      ])).toList(),
    );
  }

  Widget _buildKebutuhanBiayaTable(List<dynamic> items) {
    return Card(
      elevation: 2,
      child: Column(
        children: items.map<Widget>((item) {
          final isTotal = _safeString(item['uraian']).contains("TOTAL");
          return ListTile(
            title: Text(_safeString(item['uraian']), style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
            trailing: Text(_safeString(item['biaya_rp']), style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildJadwalPekerjaanTable(List<dynamic> jadwal) {
    if (jadwal.isEmpty) return const Text("Jadwal tidak tersedia.");
    
    final int weekCount = ((jadwal[0]['distribusi_mingguan'] as List<dynamic>?) ?? []).length;

    List<DataColumn> columns = [
      const DataColumn(label: Text('Pekerjaan')),
      const DataColumn(label: Text('Vol')),
      const DataColumn(label: Text('Sat')),
      const DataColumn(label: Text('Bobot')),
    ];
    for (int i = 1; i <= weekCount; i++) {
      columns.add(DataColumn(label: Text('MGG $i'), numeric: true));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: columns,
        rows: jadwal.map((pekerjaan) {
          List<DataCell> cells = [
            DataCell(SizedBox(width: 200, child: Text(_safeString(pekerjaan['uraian_pekerjaan'])))),
            DataCell(Text(_safeString(pekerjaan['volume']))),
            DataCell(Text(_safeString(pekerjaan['satuan']))),
            DataCell(Text(_safeString(pekerjaan['bobot']))),
          ];
          cells.addAll((((pekerjaan['distribusi_mingguan'] as List<dynamic>?) ?? [])).map((val) => DataCell(Text(_safeString(val)))));
          return DataRow(cells: cells);
        }).toList(),
      ),
    );
  }

  Widget _buildJadwalTenagaTable(List<dynamic> jadwal) {
    if (jadwal.isEmpty) return const Text("Jadwal tidak tersedia.");
    
    List<DataColumn> columns = [const DataColumn(label: Text('Tenaga Kerja'))];
    for (int i = 1; i <= (((jadwal[0]['mingguan'] as List<dynamic>?) ?? []).length); i++) {
      columns.add(DataColumn(label: Text('MGG $i'), numeric: true));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: columns,
        rows: jadwal.map((tenaga) {
          List<DataCell> cells = [DataCell(Text(_safeString(tenaga['tenaga'])))];
          cells.addAll((((tenaga['mingguan'] as List<dynamic>?) ?? [])).map((val) => DataCell(Text(_safeString(val)))));
          return DataRow(cells: cells);
        }).toList(),
      ),
    );
  }

  Widget _buildCashFlowTable(List<dynamic> cashflow) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Minggu')),
          DataColumn(label: Text('Pengeluaran Mingguan')),
          DataColumn(label: Text('Komulatif Total')),
        ],
        rows: cashflow.map((cf) => DataRow(cells: [
          DataCell(Text(_safeString(cf['minggu']))),
          DataCell(Text(_safeString(cf['pengeluaran_mingguan']))),
          DataCell(Text(_safeString(cf['komulatif_total']))),
        ])).toList(),
      ),
    );
  }

  Widget _buildJadwalBahanTable(List<dynamic> jadwal) {
    if (jadwal.isEmpty) return const Text("Jadwal tidak tersedia.");
    
    final int weekCount = ((jadwal[0]['distribusi_mingguan'] as List<dynamic>?) ?? []).length;
    
    List<DataColumn> columns = [
      const DataColumn(label: Text('Bahan Material')),
      const DataColumn(label: Text('Total Vol')),
      const DataColumn(label: Text('Satuan')),
    ];
    for (int i = 1; i <= weekCount; i++) {
      columns.add(DataColumn(label: Text('MGG $i'), numeric: true));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: columns,
        rows: jadwal.map((bahan) {
          List<DataCell> cells = [
            DataCell(SizedBox(width: 200, child: Text(_safeString(bahan['uraian_bahan'])))),
            DataCell(Text(_safeString(bahan['volume']))),
            DataCell(Text(_safeString(bahan['satuan']))),
          ];
          cells.addAll((((bahan['distribusi_mingguan'] as List<dynamic>?) ?? [])).map((val) => DataCell(Text(_safeString(val)))));
          return DataRow(cells: cells);
        }).toList(),
      ),
    );
  }
}