// lib/models/rab_data.dart

import 'package:rabcalc/models/room_dimension.dart';

class RabData {
  String? projectName, location, buildingType = 'Rumah';
  int? floorCount;
  double? landLength, landWidth;

  // DATA STATIS (DITAMBAHKAN DARI KODE BARU)
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

  // DATA DINAMIS
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
    // Reset data umum
    projectName = null; 
    location = null; 
    buildingType = 'Rumah'; 
    floorCount = null;
    landLength = null; 
    landWidth = null;
    ceilingHeightL1 = null; 
    ceilingHeightL2 = null;
    
    // Reset data statis
    ruangTamuL1 = RoomDimension();
    selasarL1 = RoomDimension();
    ruangMakanL1 = RoomDimension();
    ruangDapurL1 = RoomDimension();
    ruangKeluargaL1 = RoomDimension();
    garasiL1 = RoomDimension();
    parkiranL1 = RoomDimension();
    kolamIkan = RoomDimension(hasHeight: true);
    kolamRenang = RoomDimension(hasHeight: true);
    pagar = RoomDimension(hasHeight: true);
    teralis = RoomDimension(hasHeight: true, hasWindow: true);
    pintuPagar = RoomDimension(hasHeight: true);
    gudangKerja = RoomDimension();
    bedengKerja = RoomDimension();
    ruangKeluargaL2 = RoomDimension();
    
    // Reset semua list ruangan dinamis ke state awal (1 item)
    teras = [RoomDimension()];
    ruangTidurL1 = [RoomDimension()];
    kamarMandiL1 = [RoomDimension()];
    taman = [RoomDimension()];
    tangga = [RoomDimension()];
    voidL2 = [RoomDimension()];
    selasarL2 = [RoomDimension()];
    ruangTidurL2 = [RoomDimension()];
    kamarMandiL2 = [RoomDimension()];
    balkon = [RoomDimension()];

    materialSelections.clear();
  }
}