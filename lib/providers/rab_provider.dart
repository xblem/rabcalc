// lib/providers/rab_provider.dart

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:rabcalc/models/rab_data.dart';
import 'package:http/http.dart' as http;
import 'package:rabcalc/models/room_dimension.dart';
import 'package:rabcalc/models/history_item.dart';

class RabProvider extends ChangeNotifier {
  final RabData _data = RabData();
  RabData get rabData => _data;

  final List<HistoryItem> _history = [];
  List<HistoryItem> get history => _history;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, dynamic>? _calculationResult;
  Map<String, dynamic>? get calculationResult => _calculationResult;
  
  final List<bool> _panelExpandedState = [true, false, false, false, false];
  bool isPanelExpanded(int index) => _panelExpandedState[index];

  void togglePanel(int index) {
    _panelExpandedState[index] = !_panelExpandedState[index];
    notifyListeners();
  }
  
  // --- Methods untuk update data ---
  void updateProjectName(String name) { _data.projectName = name; notifyListeners(); }
  void updateLocation({String? provinsi, String? kabupaten}) {
    final locationString = [kabupaten, provinsi].where((s) => s != null && s.isNotEmpty).join(', ');
    _data.location = locationString;
    notifyListeners();
  }
  void updateBuildingType(String type) { _data.buildingType = type; notifyListeners(); }
  void updateFloorCount(int count) { _data.floorCount = count; notifyListeners(); }
  void updateLandSize({required double panjang, required double lebar}) { _data.landLength = panjang; _data.landWidth = lebar; notifyListeners(); }

  // FUNGSI INI DIPERBARUI UNTUK MENANGANI TINGGI & JENDELA
  void updateStaticRoomDimension(RoomDimension room, {double? panjang, double? lebar, double? tinggi, int? jumlahJendela}) {
    if (panjang != null) room.panjang = panjang;
    if (lebar != null) room.lebar = lebar;
    if (tinggi != null) room.tinggi = tinggi;
    if (jumlahJendela != null) room.jumlahJendela = jumlahJendela;
    notifyListeners();
  }

  void updateCeilingHeight(int floor, double? height) {
    if (floor == 1) _data.ceilingHeightL1 = height;
    if (floor == 2) _data.ceilingHeightL2 = height;
    notifyListeners();
  }
  
  // --- Methods untuk data dinamis ---
  void updateTerasCount(int count) => _updateRoomList(_data.teras, count);
  void updateRuangTidurL1Count(int count) => _updateRoomList(_data.ruangTidurL1, count);
  void updateKamarMandiL1Count(int count) => _updateRoomList(_data.kamarMandiL1, count);
  void updateTamanCount(int count) => _updateRoomList(_data.taman, count);
  void updateTanggaCount(int count) => _updateRoomList(_data.tangga, count);
  void updateVoidL2Count(int count) => _updateRoomList(_data.voidL2, count);
  void updateSelasarL2Count(int count) => _updateRoomList(_data.selasarL2, count);
  void updateRuangTidurL2Count(int count) => _updateRoomList(_data.ruangTidurL2, count);
  void updateKamarMandiL2Count(int count) => _updateRoomList(_data.kamarMandiL2, count);
  void updateBalkonCount(int count) => _updateRoomList(_data.balkon, count);
  
  void _updateRoomList(List<RoomDimension> roomList, int newCount) {
    if (newCount < 0) return;
    while (newCount > roomList.length) { roomList.add(RoomDimension()); }
    while (newCount < roomList.length) { roomList.removeLast(); }
    notifyListeners();
  }
  
  void updateRoomDimension(List<RoomDimension> roomList, int index, {double? panjang, double? lebar, int? jumlahJendela}) {
    if (panjang != null) roomList[index].panjang = panjang;
    if (lebar != null) roomList[index].lebar = lebar;
    if (jumlahJendela != null) roomList[index].jumlahJendela = jumlahJendela;
    notifyListeners();
  }
  
  void updateMaterialSelection(String category, String? value) {
    _data.materialSelections[category] = value;
    notifyListeners();
  }

  Future<void> calculateRAB() async {
    _isLoading = true;
    _calculationResult = null;
    notifyListeners();

    List<Map<String, dynamic>> roomListToJson(List<RoomDimension> list) {
        return list.map((r) => r.toJson()).toList();
    }

    final dataToSend = {
      'project_info': { 
        'project_name': _data.projectName, 
        'location': _data.location, 
        'floor_count': _data.floorCount, 
        'ceiling_height': _data.ceilingHeightL1,
        'ceiling_height_l2': _data.ceilingHeightL2,
      },
      // BAGIAN INI DIPERBARUI UNTUK MENGIRIM SEMUA DATA STATIS
      'static_room_details': {
        'ruang_tamu_l1': _data.ruangTamuL1.toJson(),
        'selasar_l1': _data.selasarL1.toJson(),
        'ruang_makan_l1': _data.ruangMakanL1.toJson(),
        'ruang_dapur_l1': _data.ruangDapurL1.toJson(),
        'ruang_keluarga_l1': _data.ruangKeluargaL1.toJson(),
        'garasi_l1': _data.garasiL1.toJson(),
        'parkiran_l1': _data.parkiranL1.toJson(),
        'kolam_ikan': _data.kolamIkan.toJson(),
        'kolam_renang': _data.kolamRenang.toJson(),
        'pagar': _data.pagar.toJson(),
        'teralis': _data.teralis.toJson(),
        'pintu_pagar': _data.pintuPagar.toJson(),
        'gudang_kerja': _data.gudangKerja.toJson(),
        'bedeng_kerja': _data.bedengKerja.toJson(),
        'ruang_keluarga_l2': _data.ruangKeluargaL2.toJson(),
      },
      'room_details': { 
        'teras_l1': roomListToJson(_data.teras), 
        'ruang_tidur_l1': roomListToJson(_data.ruangTidurL1), 
        'kamar_mandi_l1': roomListToJson(_data.kamarMandiL1), 
        'taman_l1': roomListToJson(_data.taman), 
        'tangga_l2': roomListToJson(_data.tangga), 
        'void_l2': roomListToJson(_data.voidL2), 
        'selasar_l2': roomListToJson(_data.selasarL2), 
        'ruang_tidur_l2': roomListToJson(_data.ruangTidurL2), 
        'kamar_mandi_l2': roomListToJson(_data.kamarMandiL2), 
        'balkon_l2': roomListToJson(_data.balkon), 
      },
      'material_selections': _data.materialSelections,
      'custom_prices': {}
    };

    final url = Uri.parse('http://192.168.100.189:5000/hitung-rab'); 
    try {
      final body = json.encode(dataToSend);
      log("Mengirim data ke backend: $body");

      final response = await http.post( url, headers: {"Content-Type": "application/json"}, body: body).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        _calculationResult = json.decode(response.body);
        _saveToHistory();
        log("Hasil dari backend: $_calculationResult");
      } else {
        log("Server Error: ${response.body}");
        _calculationResult = {"error": "Gagal menghitung (Server Error: ${response.statusCode})"};
      }
    } catch (e) {
      log("Error Koneksi: $e");
      _calculationResult = {"error": "Tidak bisa terhubung ke server. Pastikan server Python berjalan dan IP Address sudah benar."};
    }
    
    _isLoading = false;
    notifyListeners();
  }

  void _saveToHistory() {
    if (_calculationResult != null && _calculationResult!['hasil_rab'] != null) {
      final newHistoryItem = HistoryItem(
        projectName: _data.projectName ?? 'Proyek Tanpa Nama',
        totalCost: _calculationResult!['hasil_rab']['total_biaya_konstruksi_rp'],
        date: DateTime.now(),
      );
      _history.insert(0, newHistoryItem);
    }
  }

  void startNewCalculation() {
    _data.clear();
    for(int i = 0; i < _panelExpandedState.length; i++) { _panelExpandedState[i] = (i==0); }
    notifyListeners();
  }
}