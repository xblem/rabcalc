// lib/utils/logger.dart
import 'package:logger/logger.dart';

// Kita buat satu instance logger yang bisa diakses dari mana saja
final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 1, // Hanya tampilkan 1 method call di stack trace
    errorMethodCount: 5, // Tampilkan 5 method call jika terjadi error
    lineLength: 120, // Lebar baris
    colors: true, // Aktifkan warna
    printEmojis: true, // Tampilkan emoji untuk setiap level log
    printTime: true, // Tampilkan timestamp
  ),
);