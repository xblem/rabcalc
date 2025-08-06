import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Metode Pembayaran')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPaymentCategory("Virtual Account (Bank Transfer)"),
          _buildPaymentTile('Bank BCA', 'assets/images/logo_bca.png'),
          _buildPaymentTile('Bank BNI', 'assets/images/logo_bni.png'),
          _buildPaymentTile('Bank BRI', 'assets/images/logo_bri.png'),
          _buildPaymentTile('Bank Mandiri', 'assets/images/logo_mandiri.png'),
          
          const Divider(height: 40),

          _buildPaymentCategory("E-Wallet"),
          _buildPaymentTile('GOPAY', 'assets/images/logo_gopay.png'),
          _buildPaymentTile('DANA', 'assets/images/logo_dana.png'),

           const Divider(height: 40),

          _buildPaymentCategory("QR Code"),
          _buildPaymentTile('QRIS', 'assets/images/logo_qris.png'),
        ],
      ),
    );
  }

  Widget _buildPaymentCategory(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
    );
  }

  Widget _buildPaymentTile(String title, String logoPath) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Image.asset(logoPath, height: 24),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Aksi saat metode pembayaran dipilih
        },
      ),
    );
  }
}