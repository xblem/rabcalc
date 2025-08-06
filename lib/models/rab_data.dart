// lib/models/rab_data.dart

import 'package:rabcalc/models/room_dimension.dart';

class RabData {
  String? projectName, location, buildingType = 'Rumah';
  int? floorCount;
  double? landLength, landWidth;

  RoomDimension ruangTamuL1 = RoomDimension();
  RoomDimension selasarL1 = RoomDimension();
  RoomDimension ruangMakanL1 = RoomDimension();
  RoomDimension ruangDapurL1 = RoomDimension();
  RoomDimension ruangKeluargaL1 = RoomDimension();
  RoomDimension garasiL1 = RoomDimension();
  RoomDimension parkiranL1 = RoomDimension();
  RoomDimension kolamIkan = RoomDimension(hasHeight: true);
  RoomDimension kolamRenang = RoomDimension(hasHeight: true);
  RoomDimension pagar = RoomDimension(hasHeight: true);
  RoomDimension teralis = RoomDimension(hasHeight: true, hasWindow: true);
  RoomDimension pintuPagar = RoomDimension(hasHeight: true);
  RoomDimension gudangKerja = RoomDimension();
  RoomDimension bedengKerja = RoomDimension();
  RoomDimension ruangKeluargaL2 = RoomDimension();
  double? ceilingHeightL1;
  double? ceilingHeightL2;

  List<RoomDimension> teras = [RoomDimension()];
  List<RoomDimension> ruangTidurL1 = [RoomDimension()];
  List<RoomDimension> kamarMandiL1 = [RoomDimension()];
  List<RoomDimension> taman = [RoomDimension()];
  List<RoomDimension> tangga = [RoomDimension()];
  List<RoomDimension> voidL2 = [RoomDimension()];
  List<RoomDimension> selasarL2 = [RoomDimension()];
  List<RoomDimension> ruangTidurL2 = [RoomDimension()];
  List<RoomDimension> kamarMandiL2 = [RoomDimension()];
  List<RoomDimension> balkon = [RoomDimension()];

  Map<String, String?> materialSelections = {};

  void clear() {
    // ... (implementasi clear() yang sudah lengkap)
  }

  // --- FUNGSI BARU UNTUK MENGUBAH SEMUA DATA MENJADI JSON ---
  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> roomListToJson(List<RoomDimension> list) {
      return list.map((r) => r.toJson()).toList();
    }

    return {
      'project_info': { 
        'project_name': projectName, 
        'location': location, 
        'floor_count': floorCount, 
        'ceiling_height': ceilingHeightL1,
        'ceiling_height_l2': ceilingHeightL2,
      },
      'static_room_details': {
        'ruang_tamu_l1': ruangTamuL1.toJson(),
        'selasar_l1': selasarL1.toJson(),
        'ruang_makan_l1': ruangMakanL1.toJson(),
        'ruang_dapur_l1': ruangDapurL1.toJson(),
        'ruang_keluarga_l1': ruangKeluargaL1.toJson(),
        'garasi_l1': garasiL1.toJson(),
        'parkiran_l1': parkiranL1.toJson(),
        'kolam_ikan': kolamIkan.toJson(),
        'kolam_renang': kolamRenang.toJson(),
        'pagar': pagar.toJson(),
        'teralis': teralis.toJson(),
        'pintu_pagar': pintuPagar.toJson(),
        'gudang_kerja': gudangKerja.toJson(),
        'bedeng_kerja': bedengKerja.toJson(),
        'ruang_keluarga_l2': ruangKeluargaL2.toJson(),
      },
      'room_details': { 
        'teras_l1': roomListToJson(teras), 
        'ruang_tidur_l1': roomListToJson(ruangTidurL1), 
        'kamar_mandi_l1': roomListToJson(kamarMandiL1), 
        'taman_l1': roomListToJson(taman), 
        'tangga_l2': roomListToJson(tangga), 
        'void_l2': roomListToJson(voidL2), 
        'selasar_l2': roomListToJson(selasarL2), 
        'ruang_tidur_l2': roomListToJson(ruangTidurL2), 
        'kamar_mandi_l2': roomListToJson(kamarMandiL2), 
        'balkon_l2': roomListToJson(balkon), 
      },
      'material_selections': materialSelections,
      'custom_prices': {}
    };
  }
}