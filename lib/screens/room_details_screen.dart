// lib/screens/room_details_screen.dart

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rabcalc/models/room_dimension.dart';
import 'package:rabcalc/providers/rab_provider.dart';
import 'package:rabcalc/screens/material_specs_screen.dart';

class RoomDetailsScreen extends StatefulWidget {
  final int floorCount;
  const RoomDetailsScreen({super.key, required this.floorCount});

  @override
  State<RoomDetailsScreen> createState() => _RoomDetailsScreenState();
}

class _RoomDetailsScreenState extends State<RoomDetailsScreen> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  void _saveAllDataToProvider() {
    final provider = Provider.of<RabProvider>(context, listen: false);

    // Menyimpan data dinamis
    provider.updateRoomDimensions(roomList: provider.rabData.teras, roomKey: 'teras', controllers: _controllers);
    provider.updateRoomDimensions(roomList: provider.rabData.ruangTidurL1, roomKey: 'ruangTidurL1', controllers: _controllers, hasWindow: true);
    provider.updateRoomDimensions(roomList: provider.rabData.kamarMandiL1, roomKey: 'kamarMandiL1', controllers: _controllers, hasWindow: true);
    provider.updateRoomDimensions(roomList: provider.rabData.taman, roomKey: 'taman', controllers: _controllers);
    if (widget.floorCount == 2) {
      provider.updateRoomDimensions(roomList: provider.rabData.tangga, roomKey: 'tangga', controllers: _controllers);
      provider.updateRoomDimensions(roomList: provider.rabData.voidL2, roomKey: 'voidL2', controllers: _controllers, hasWindow: true);
      provider.updateRoomDimensions(roomList: provider.rabData.selasarL2, roomKey: 'selasarL2', controllers: _controllers);
      provider.updateRoomDimensions(roomList: provider.rabData.ruangTidurL2, roomKey: 'ruangTidurL2', controllers: _controllers, hasWindow: true);
      provider.updateRoomDimensions(roomList: provider.rabData.kamarMandiL2, roomKey: 'kamarMandiL2', controllers: _controllers, hasWindow: true);
      provider.updateRoomDimensions(roomList: provider.rabData.balkon, roomKey: 'balkon', controllers: _controllers);
    }

    // Menyimpan data statis
    provider.updateStaticRoomDimensionFromText(provider.rabData.ruangTamuL1, controllers: _controllers, roomKey: 'ruangTamuL1', hasWindow: true);
    provider.updateStaticRoomDimensionFromText(provider.rabData.selasarL1, controllers: _controllers, roomKey: 'selasarL1');
    provider.updateStaticRoomDimensionFromText(provider.rabData.ruangMakanL1, controllers: _controllers, roomKey: 'ruangMakanL1', hasWindow: true);
    provider.updateStaticRoomDimensionFromText(provider.rabData.ruangDapurL1, controllers: _controllers, roomKey: 'ruangDapurL1', hasWindow: true);
    provider.updateStaticRoomDimensionFromText(provider.rabData.ruangKeluargaL1, controllers: _controllers, roomKey: 'ruangKeluargaL1', hasWindow: true);
    provider.updateStaticRoomDimensionFromText(provider.rabData.garasiL1, controllers: _controllers, roomKey: 'garasiL1');
    provider.updateStaticRoomDimensionFromText(provider.rabData.parkiranL1, controllers: _controllers, roomKey: 'parkiranL1');
    provider.updateStaticRoomDimensionFromText(provider.rabData.kolamIkan, controllers: _controllers, roomKey: 'kolamIkan', hasHeight: true);
    provider.updateStaticRoomDimensionFromText(provider.rabData.kolamRenang, controllers: _controllers, roomKey: 'kolamRenang', hasHeight: true);
    provider.updateStaticRoomDimensionFromText(provider.rabData.pagar, controllers: _controllers, roomKey: 'pagar', hasHeight: true);
    provider.updateStaticRoomDimensionFromText(provider.rabData.teralis, controllers: _controllers, roomKey: 'teralis', hasHeight: true, hasWindow: true);
    provider.updateStaticRoomDimensionFromText(provider.rabData.pintuPagar, controllers: _controllers, roomKey: 'pintuPagar', hasHeight: true);
    provider.updateStaticRoomDimensionFromText(provider.rabData.gudangKerja, controllers: _controllers, roomKey: 'gudangKerja');
    provider.updateStaticRoomDimensionFromText(provider.rabData.bedengKerja, controllers: _controllers, roomKey: 'bedengKerja');
    if (widget.floorCount == 2) {
      provider.updateStaticRoomDimensionFromText(provider.rabData.ruangKeluargaL2, controllers: _controllers, roomKey: 'ruangKeluargaL2', hasWindow: true);
    }
    
    // Menyimpan data plafon
    provider.updateCeilingHeight(double.tryParse(_controllers['ceilingHeightL1']?.text ?? ''));
    if (widget.floorCount == 2) {
      provider.updateCeilingHeightL2(double.tryParse(_controllers['ceilingHeightL2']?.text ?? ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RabProvider>(
      builder: (context, rabProvider, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Langkah 2: Organisasi Ruang')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildCustomExpansionTile(
                  title: 'LANTAI 1',
                  isExpanded: rabProvider.isPanelExpanded(0),
                  onTap: () => rabProvider.togglePanel(0),
                  child: _buildLantai1Content(rabProvider),
                ),
                const SizedBox(height: 12),
                if (widget.floorCount == 2) ...[
                  _buildCustomExpansionTile(
                    title: 'LANTAI 2',
                    isExpanded: rabProvider.isPanelExpanded(1),
                    onTap: () => rabProvider.togglePanel(1),
                    child: _buildLantai2Content(rabProvider),
                  ),
                  const SizedBox(height: 12),
                ],
                _buildCustomExpansionTile(
                  title: 'BANGUNAN SEMENTARA & EKSTERIOR',
                  isExpanded: rabProvider.isPanelExpanded(2),
                  onTap: () => rabProvider.togglePanel(2),
                  child: _buildBangunanSementaraContent(rabProvider),
                ),
                const SizedBox(height: 12),
                _buildCustomExpansionTile(
                  title: 'KETINGGIAN PLAFON',
                  isExpanded: rabProvider.isPanelExpanded(3),
                  onTap: () => rabProvider.togglePanel(3),
                  child: _buildPlafonContent(rabProvider),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _saveAllDataToProvider();
                log('Data dimensi disimpan, lanjut ke Spesifikasi Material...');
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MaterialSpecsScreen()));
              },
              child: const Text('Lanjut ke Spesifikasi Material'),
            ),
          ),
        );
      },
    );
  }

  // ---- KONTEN UNTUK SETIAP PANEL ----
  Widget _buildLantai1Content(RabProvider provider) {
    return Column(
      children: [
        _buildRoomCounter('Teras', provider.rabData.teras.length, provider.updateTerasCount),
        _buildDynamicInputs('Teras', 'teras', provider.rabData.teras),
        _buildDivider(),
        _buildStaticRoomInput('ruangTamuL1', 'Ruang Tamu', provider.rabData.ruangTamuL1, hasWindow: true),
        _buildDivider(),
        _buildStaticRoomInput('selasarL1', 'Selasar/Foyer', provider.rabData.selasarL1),
        _buildDivider(),
        _buildRoomCounter('Ruang Tidur', provider.rabData.ruangTidurL1.length, provider.updateRuangTidurL1Count),
        _buildDynamicInputs('Ruang Tidur', 'ruangTidurL1', provider.rabData.ruangTidurL1, hasWindow: true),
        _buildDivider(),
        _buildStaticRoomInput('ruangMakanL1', 'Ruang Makan', provider.rabData.ruangMakanL1, hasWindow: true),
        _buildDivider(),
        _buildStaticRoomInput('ruangDapurL1', 'Ruang Dapur', provider.rabData.ruangDapurL1, hasWindow: true),
        _buildDivider(),
        _buildStaticRoomInput('ruangKeluargaL1', 'Ruang Keluarga', provider.rabData.ruangKeluargaL1, hasWindow: true),
        _buildDivider(),
        _buildRoomCounter('Kamar Mandi', provider.rabData.kamarMandiL1.length, provider.updateKamarMandiL1Count),
        _buildDynamicInputs('Kamar Mandi', 'kamarMandiL1', provider.rabData.kamarMandiL1, hasWindow: true, windowLabel: "Jendela/Bovenlight"),
        _buildDivider(),
        _buildStaticRoomInput('garasiL1', 'Garasi Mobil', provider.rabData.garasiL1),
        _buildDivider(),
        _buildStaticRoomInput('parkiranL1', 'Parkiran', provider.rabData.parkiranL1),
        _buildDivider(),
        _buildRoomCounter('Taman', provider.rabData.taman.length, provider.updateTamanCount),
        _buildDynamicInputs('Taman', 'taman', provider.rabData.taman),
      ],
    );
  }

  Widget _buildLantai2Content(RabProvider provider) => Column(
        children: [
          _buildRoomCounter('Tangga', provider.rabData.tangga.length, provider.updateTanggaCount),
          _buildDynamicInputs('Tangga', 'tangga', provider.rabData.tangga),
          _buildDivider(),
          _buildRoomCounter('Void', provider.rabData.voidL2.length, provider.updateVoidL2Count),
          _buildDynamicInputs('Void', 'voidL2', provider.rabData.voidL2, hasWindow: true),
          _buildDivider(),
          _buildRoomCounter('Selasar', provider.rabData.selasarL2.length, provider.updateSelasarL2Count),
          _buildDynamicInputs('Selasar', 'selasarL2', provider.rabData.selasarL2),
          _buildDivider(),
          _buildRoomCounter('Ruang Tidur', provider.rabData.ruangTidurL2.length, provider.updateRuangTidurL2Count),
          _buildDynamicInputs('Ruang Tidur', 'ruangTidurL2', provider.rabData.ruangTidurL2, hasWindow: true),
          _buildDivider(),
          _buildStaticRoomInput('ruangKeluargaL2', 'Ruang Keluarga', provider.rabData.ruangKeluargaL2, hasWindow: true),
          _buildDivider(),
          _buildRoomCounter('Kamar Mandi', provider.rabData.kamarMandiL2.length, provider.updateKamarMandiL2Count),
          _buildDynamicInputs('Kamar Mandi', 'kamarMandiL2', provider.rabData.kamarMandiL2, hasWindow: true, windowLabel: "Jendela/Bovenlight"),
          _buildDivider(),
          _buildRoomCounter('Balkon', provider.rabData.balkon.length, provider.updateBalkonCount),
          _buildDynamicInputs('Balkon', 'balkon', provider.rabData.balkon),
        ],
      );

  Widget _buildBangunanSementaraContent(RabProvider provider) {
    return Column(
      children: [
        _buildStaticRoomInput('gudangKerja', 'Gudang Kerja', provider.rabData.gudangKerja),
        _buildDivider(),
        _buildStaticRoomInput('bedengKerja', 'Bedeng Kerja', provider.rabData.bedengKerja),
        _buildDivider(),
        _buildStaticRoomInput('kolamIkan', 'Kolam Ikan Koi', provider.rabData.kolamIkan, hasHeight: true, heightLabel: "Tinggi/Dalam"),
        _buildDivider(),
        _buildStaticRoomInput('kolamRenang', 'Kolam Renang', provider.rabData.kolamRenang, hasHeight: true, heightLabel: "Tinggi/Dalam"),
        _buildDivider(),
        _buildStaticRoomInput('pagar', 'Pagar Rumah', provider.rabData.pagar, hasHeight: true, heightLabel: "Tinggi"),
        _buildDivider(),
        _buildStaticRoomInput('teralis', 'Teralis Pagar', provider.rabData.teralis, hasHeight: true, heightLabel: "Tinggi", hasWindow: true, windowLabel: "Jumlah"),
        _buildDivider(),
        _buildStaticRoomInput('pintuPagar', 'Pintu Pagar', provider.rabData.pintuPagar, hasHeight: true, heightLabel: "Tinggi"),
      ],
    );
  }

  Widget _buildPlafonContent(RabProvider provider) {
    return Column(
      children: [
        _buildSingleInput(
          label: "Tinggi Plafon Lantai 1 (m)",
          controllerKey: 'ceilingHeightL1',
          initialValue: provider.rabData.ceilingHeightL1?.toString()
        ),
        if (widget.floorCount == 2) ...[
          const SizedBox(height: 16),
          _buildSingleInput(
            label: "Tinggi Plafon Lantai 2 (m)",
            controllerKey: 'ceilingHeightL2',
            initialValue: provider.rabData.ceilingHeightL2?.toString()
          ),
        ]
      ],
    );
  }

  // --- WIDGET-WIDGET PEMBANTU (HELPER) ---
  
  Widget _buildDynamicInputs(String displayName, String roomKey, List<RoomDimension> roomList, {bool hasWindow = false, String windowLabel = 'Jumlah Jendela'}) {
    if (roomList.isEmpty) return const SizedBox.shrink();
    return Column(
      children: List.generate(roomList.length, (index) {
        final room = roomList[index];
        final panjangKey = '${roomKey}_${index}_panjang';
        final lebarKey = '${roomKey}_${index}_lebar';
        final jendelaKey = '${roomKey}_${index}_jendela';

        _controllers.putIfAbsent(panjangKey, () => TextEditingController(text: room.panjang == 0 ? '' : room.panjang.toString()));
        _controllers.putIfAbsent(lebarKey, () => TextEditingController(text: room.lebar == 0 ? '' : room.lebar.toString()));
        if (hasWindow) {
          _controllers.putIfAbsent(jendelaKey, () => TextEditingController(text: room.jumlahJendela == 0 ? '' : room.jumlahJendela.toString()));
        }

        return Card(
          elevation: 0, shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(8)), margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$displayName ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: _buildTextFormField(label: 'Panjang (m)', controller: _controllers[panjangKey]!)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextFormField(label: 'Lebar (m)', controller: _controllers[lebarKey]!)),
                ]),
                if (hasWindow) ...[
                  const SizedBox(height: 12),
                  _buildTextFormField(label: windowLabel, controller: _controllers[jendelaKey]!, keyboardType: TextInputType.number)
                ],
              ],
            ),
          ),
        );
      }),
    );
  }
  
  Widget _buildStaticRoomInput(String roomKey, String displayName, RoomDimension room, {bool hasWindow = false, String windowLabel = 'Jumlah Jendela', bool hasHeight = false, String heightLabel = 'Tinggi (m)'}) {
    final panjangKey = '${roomKey}_panjang';
    final lebarKey = '${roomKey}_lebar';
    final tinggiKey = '${roomKey}_tinggi';
    final jendelaKey = '${roomKey}_jendela';

    _controllers.putIfAbsent(panjangKey, () => TextEditingController(text: room.panjang == 0 ? '' : room.panjang.toString()));
    _controllers.putIfAbsent(lebarKey, () => TextEditingController(text: room.lebar == 0 ? '' : room.lebar.toString()));
    if (hasHeight) {
      _controllers.putIfAbsent(tinggiKey, () => TextEditingController(text: room.tinggi == 0 ? '' : room.tinggi.toString()));
    }
    if (hasWindow) {
      _controllers.putIfAbsent(jendelaKey, () => TextEditingController(text: room.jumlahJendela == 0 ? '' : room.jumlahJendela.toString()));
    }

    return Card(
      elevation: 0, shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(8)), margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(displayName, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _buildTextFormField(label: 'Panjang (m)', controller: _controllers[panjangKey]!)),
              const SizedBox(width: 16),
              Expanded(child: _buildTextFormField(label: 'Lebar (m)', controller: _controllers[lebarKey]!)),
            ]),
            if (hasHeight) ...[
              const SizedBox(height: 12),
              _buildTextFormField(label: heightLabel, controller: _controllers[tinggiKey]!)
            ],
            if (hasWindow) ...[
              const SizedBox(height: 12),
              _buildTextFormField(label: windowLabel, controller: _controllers[jendelaKey]!, keyboardType: TextInputType.number)
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSingleInput({required String label, required String controllerKey, String? initialValue}) {
    _controllers.putIfAbsent(controllerKey, () => TextEditingController(text: initialValue ?? ''));
    return Card(
      elevation: 0, shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(8)), margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _buildTextFormField(label: label, controller: _controllers[controllerKey]!),
      ),
    );
  }

  TextFormField _buildTextFormField({required String label, required TextEditingController controller, TextInputType keyboardType = const TextInputType.numberWithOptions(decimal: true)}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        isDense: true, contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      keyboardType: keyboardType,
    );
  }
  
  Widget _buildCustomExpansionTile({required String title, required bool isExpanded, required VoidCallback onTap, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: isExpanded ? Colors.blue.shade300 : Colors.grey.shade300, width: 1.5)),
      child: Column(
        children: [
          InkWell(
            onTap: onTap, borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Icon(isExpanded ? Icons.expand_less : Icons.expand_more, color: Colors.grey.shade700),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Visibility(
              visible: isExpanded,
              child: Container(width: double.infinity, padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), child: child),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRoomCounter(String label, int count, ValueChanged<int> onCountChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Jumlah $label:', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        Row(children: [
          IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => onCountChanged(count > 0 ? count - 1 : 0), color: Colors.red.shade700),
          Text('$count', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => onCountChanged(count < 5 ? count + 1 : 5), color: Colors.green.shade700),
        ]),
      ],
    );
  }

  Divider _buildDivider() => const Divider(height: 24, thickness: 0.5, indent: 8, endIndent: 8);
}