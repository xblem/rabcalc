// lib/main.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rabcalc/providers/rab_provider.dart';
import 'package:rabcalc/screens/auth/welcome_screen.dart';
import 'package:rabcalc/screens/history_screen.dart';
import 'package:rabcalc/screens/profile_screen.dart';
import 'package:rabcalc/screens/project_data_screen.dart';
import 'package:intl/date_symbol_data_local.dart';  // IMPORT DARI KODE BARU


class AppColors {
  static const Color primaryDark = Color(0xFF030047);
  static const Color primaryAccent = Color(0xFFFFCC3E);
  static const Color lightGray = Color(0xFFE1E5F4);
  static const Color background = Color(0xFFF8FBFF);
}

// FUNGSI main() DIPERBARUI DARI KODE BARU
void main() {
  // Memastikan format tanggal untuk Bahasa Indonesia siap digunakan
  initializeDateFormatting('id_ID', null).then((_) {
    runApp(
      ChangeNotifierProvider(
        create: (context) => RabProvider(),
        child: const RabCalcApp(),
      ),
    );
  });
}

class RabCalcApp extends StatelessWidget {
  const RabCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RabCalc',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryDark,
          primary: AppColors.primaryDark,
          secondary: AppColors.primaryAccent,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryDark,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
          ),
        ),
      ),
      // LAYAR PEMBUKA DIPERBARUI DARI KODE BARU
      home: const WelcomeScreen(),
    );
  }
}

// Widget MainScreen DARI KODE LAMA (TIDAK DIHAPUS)
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePageContent(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Widget HomePageContent DARI KODE LAMA (TIDAK DIHAPUS)
class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/logo.png', height: 32),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.1,
              child: Image.asset('assets/images/hero_bg.png', fit: BoxFit.cover),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProjectDataScreen()));
                  },
                  borderRadius: BorderRadius.circular(16.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.home_work_outlined, size: 48.0, color: Colors.blue.shade700),
                        const SizedBox(height: 16.0),
                        const Text('Mulai Hitung RAB Rumah Baru', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8.0),
                        Text('Perkirakan biaya membangun rumah Anda dengan mudah.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}