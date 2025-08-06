// lib/models/room_dimension.dart

class RoomDimension {
  double? panjang;
  double? lebar;
  double? tinggi; // <-- PROPERTI YANG HILANG, SEKARANG DITAMBAHKAN
  int? jumlahJendela;

  // Properti ini hanya untuk logika UI, tidak perlu disimpan
  final bool hasHeight;
  final bool hasWindow;

  RoomDimension({
    this.panjang = 0.0, 
    this.lebar = 0.0, 
    this.tinggi = 0.0, 
    this.jumlahJendela = 0,
    this.hasHeight = false,
    this.hasWindow = false,
  });

  // toJson diperbarui untuk menyertakan semua data
  Map<String, dynamic> toJson() => {
    'panjang': panjang,
    'lebar': lebar,
    'tinggi': tinggi,
    'jendela': jumlahJendela,
  };
}