// lib/services/location_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rabcalc/models/province.dart';
import 'package:rabcalc/models/regency.dart';

class LocationService {
  // Base URL diperbarui ke API yang baru
  final String _baseUrl = 'https://www.emsifa.com/api-wilayah-indonesia/api';

  Future<List<Province>> getProvinces() async {
    final response = await http.get(Uri.parse('$_baseUrl/provinces.json'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Province.fromJson(json)).toList();
    } else {
      // Pesan error diperbarui
      throw Exception('Gagal memuat data provinsi dari API baru');
    }
  }

  Future<List<Regency>> getRegencies(String provinceId) async {
    final response = await http.get(Uri.parse('$_baseUrl/regencies/$provinceId.json'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Regency.fromJson(json)).toList();
    } else {
      // Pesan error diperbarui
      throw Exception('Gagal memuat data kabupaten/kota dari API baru');
    }
  }
}