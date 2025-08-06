// lib/screens/history_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rabcalc/providers/rab_provider.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Proyek'),
      ),
      body: Consumer<RabProvider>(
        builder: (context, provider, child) {
          if (provider.history.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_toggle_off_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Riwayat perhitungan masih kosong.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: provider.history.length,
            itemBuilder: (context, index) {
              final item = provider.history[index];
              final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
              final dateFormatter = DateFormat('dd MMMM yyyy, HH:mm', 'id_ID');

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.receipt_long_outlined),
                  ),
                  title: Text(item.projectName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(dateFormatter.format(item.date)),
                  trailing: Text(
                    currencyFormatter.format(item.totalCost), 
                    style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.green)
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}