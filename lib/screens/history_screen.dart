// lib/screens/history_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rabcalc/main.dart'; 
import 'package:rabcalc/screens/history_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Get the current logged-in user
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Proyek'),
      ),
      // Use StreamBuilder to listen for real-time data from Firestore
      body: StreamBuilder<QuerySnapshot>(
        // 1. Define the data source: the 'projects' subcollection of the current user
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid) // Get user UID
            .collection('projects')
            .orderBy('date', descending: true) // Show the latest on top
            .snapshots(),
        builder: (context, snapshot) {
          // 2. Show a loading spinner while data is being loaded
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 3. Show a message if there is no history or an error occurs
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Riwayat perhitungan Anda masih kosong.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            );
          }

          // 4. If data exists, store it in a variable
          final projectDocs = snapshot.data!.docs;

          // 5. Display the data using ListView.builder
          return ListView.builder(
            itemCount: projectDocs.length,
            itemBuilder: (context, index) {
              final project = projectDocs[index].data() as Map<String, dynamic>;
              
              // Format currency and date for a clean look
              final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
              final dateFormatter = DateFormat('dd MMMM yyyy, HH:mm', 'id_ID');
              
              // Convert Timestamp from Firestore to a DateTime object
              final date = (project['date'] as Timestamp).toDate();

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.receipt_long_outlined, color: AppColors.primaryDark),
                  title: Text(project['projectName'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(dateFormatter.format(date)),
                  trailing: Text(
                    currencyFormatter.format(project['totalCost']),
                    style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.green, fontSize: 16),
                  ),
                  onTap: () {
                    // Ambil data lengkap dari dokumen Firestore
                    final fullData = project['fullCalculationResult'] as Map<String, dynamic>;
                    // Navigasi ke halaman detail sambil mengirim data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryDetailScreen(calculationData: fullData),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}