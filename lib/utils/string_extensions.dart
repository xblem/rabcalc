// lib/utils/string_extensions.dart

// Helper untuk membuat huruf pertama kapital
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
