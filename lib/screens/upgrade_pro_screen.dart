import 'package:flutter/material.dart';
import 'package:rabcalc/main.dart'; // Import AppColors
import 'package:rabcalc/screens/payment_methods_screen.dart';

class UpgradeProScreen extends StatelessWidget {
  const UpgradeProScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upgrade ke RabCalc Pro'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Pilih Paket yang Tepat untuk Anda',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Buka semua fitur canggih untuk mempercepat pekerjaan Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),

            // --- KARTU HARGA SESUAI KONTEN ANDA ---
            _buildPricingCard(
              context: context,
              title: 'Pelajar',
              price: '49K',
              description: 'Teman setia mahasiswa buat belajar dan latihan nyusun RAB.',
              features: const [
                'Template Perhitungan RAB',
                'Referensi Harga Satuan',
                'Referensi AHSP Permen PUPR 2024',
                'Export RAB ke File Excel',
              ],
            ),
            const SizedBox(height: 24),
            _buildPricingCard(
              context: context,
              title: 'Pemula',
              price: '100K',
              description: 'Solusi tepat untuk Konsultan atau Perangkat Desa.',
              features: const [
                'Semua fitur paket Pelajar',
                'Referensi RAB Sederhana',
              ],
            ),
            const SizedBox(height: 24),
            _buildPricingCard(
              context: context,
              title: 'Profesional',
              price: '499K',
              description: 'Dirancang khusus untuk kontraktor memenangkan tender.',
              features: const [
                'Semua fitur paket Pemula',
                'Personal Tim Support untuk Diskusi',
                'Pembuatan Jadwal & Kurva S Otomatis',
                'Hitung Kebutuhan Material & Upah',
                'Hitung Harga Sewa Peralatan',
                'Fitur Upload RAB (coming soon)',
                'Fitur RAP vs RAB (coming soon)',
              ],
              isRecommended: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingCard({
    required BuildContext context,
    required String title,
    required String price,
    required String description,
    required List<String> features,
    bool isRecommended = false,
  }) {
    // Menyesuaikan warna dengan tema aplikasi kita
    final Color primaryColor = isRecommended ? AppColors.primaryDark : const Color(0xFF6558d3);
    final Color cardBgColor = isRecommended ? AppColors.background : const Color(0xFFECF0FF);
    final Color priceBgColor = isRecommended ? AppColors.lightGray : const Color(0xFFBED6FB);
    final Color priceColor = AppColors.primaryDark;
    final Color iconBgColor = isRecommended ? AppColors.primaryDark : const Color(0xFF1FCAC5);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isRecommended ? AppColors.primaryDark.withAlpha(128) : Colors.transparent)           
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: priceColor)),
              const SizedBox(height: 8),
              Text(description, style: TextStyle(color: Colors.grey.shade700, fontSize: 15)),
              const SizedBox(height: 16),
              ...features.map((feature) => Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Container(
                      width: 20, height: 20,
                      decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
                      child: const Icon(Icons.check, color: Colors.white, size: 14),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(feature, style: const TextStyle(fontSize: 15))),
                  ],
                ),
              )),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentMethodsScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 2,
                  ),
                  child: const Text('Choose Plan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: priceBgColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(24),
              ),
            ),
            child: RichText(
              text: TextSpan(
                text: price,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: priceColor, fontFamily: 'Poppins'),
                children: [
                  TextSpan(
                    text: ' /m',
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14, color: Colors.grey.shade700, fontFamily: 'Poppins'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}