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
                log('Lanjut ke Spesifikasi Material');
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MaterialSpecsScreen()));
              },
              child: const Text('Lanjut ke Spesifikasi Material'),
            ),
          ),
        );
      },
    );
  }

  // ---- KONTEN UNTUK SETIAP PANEL (LENGKAP) ----
  Widget _buildLantai1Content(RabProvider provider) {
    return Column(
      children: [
        _buildRoomCounter('Teras', provider.rabData.teras.length, provider.updateTerasCount),
        _buildDynamicInputs(provider, 'teras', provider.rabData.teras),
        _buildDivider(),
        _buildStaticRoomInput(provider, provider.rabData.ruangTamuL1, 'Ruang Tamu', hasWindow: true),
        _buildDivider(),
        _buildStaticRoomInput(provider, provider.rabData.selasarL1, 'Selasar/Foyer'),
        _buildDivider(),
        _buildRoomCounter('Ruang Tidur', provider.rabData.ruangTidurL1.length, provider.updateRuangTidurL1Count),
        _buildDynamicInputs(provider, 'ruangTidurL1', provider.rabData.ruangTidurL1, hasWindow: true),
        _buildDivider(),
        _buildStaticRoomInput(provider, provider.rabData.ruangMakanL1, 'Ruang Makan', hasWindow: true),
        _buildDivider(),
        _buildStaticRoomInput(provider, provider.rabData.ruangDapurL1, 'Ruang Dapur', hasWindow: true),
        _buildDivider(),
        _buildStaticRoomInput(provider, provider.rabData.ruangKeluargaL1, 'Ruang Keluarga', hasWindow: true),
        _buildDivider(),
        _buildRoomCounter('Kamar Mandi', provider.rabData.kamarMandiL1.length, provider.updateKamarMandiL1Count),
        _buildDynamicInputs(provider, 'kamarMandiL1', provider.rabData.kamarMandiL1, hasWindow: true, windowLabel: "Jendela/Bovenlight"),
        _buildDivider(),
        _buildStaticRoomInput(provider, provider.rabData.garasiL1, 'Garasi Mobil'),
        _buildDivider(),
        _buildStaticRoomInput(provider, provider.rabData.parkiranL1, 'Parkiran'),
        _buildDivider(),
        _buildRoomCounter('Taman', provider.rabData.taman.length, provider.updateTamanCount),
        _buildDynamicInputs(provider, 'taman', provider.rabData.taman),
      ],
    );
  }

  Widget _buildLantai2Content(RabProvider provider) => Column(
        children: [
          _buildRoomCounter('Tangga', provider.rabData.tangga.length, provider.updateTanggaCount),
          _buildDynamicInputs(provider, 'tangga', provider.rabData.tangga),
          _buildDivider(),
          _buildRoomCounter('Void', provider.rabData.voidL2.length, provider.updateVoidL2Count),
          _buildDynamicInputs(provider, 'voidL2', provider.rabData.voidL2, hasWindow: true),
          _buildDivider(),
          _buildRoomCounter('Selasar', provider.rabData.selasarL2.length, provider.updateSelasarL2Count),
          _buildDynamicInputs(provider, 'selasarL2', provider.rabData.selasarL2),
          _buildDivider(),
          _buildRoomCounter('Ruang Tidur', provider.rabData.ruangTidurL2.length, provider.updateRuangTidurL2Count),
          _buildDynamicInputs(provider, 'ruangTidurL2', provider.rabData.ruangTidurL2, hasWindow: true),
          _buildDivider(),
          _buildStaticRoomInput(provider, provider.rabData.ruangKeluargaL2, 'Ruang Keluarga', hasWindow: true),
          _buildDivider(),
          _buildRoomCounter('Kamar Mandi', provider.rabData.kamarMandiL2.length, provider.updateKamarMandiL2Count),
          _buildDynamicInputs(provider, 'kamarMandiL2', provider.rabData.kamarMandiL2, hasWindow: true, windowLabel: "Jendela/Bovenlight"),
          _buildDivider(),
          _buildRoomCounter('Balkon', provider.rabData.balkon.length, provider.updateBalkonCount),
          _buildDynamicInputs(provider, 'balkon', provider.rabData.balkon),
        ],
      );

  Widget _buildBangunanSementaraContent(RabProvider provider) {
    return Column(
      children: [
        _buildStaticRoomInput(provider, provider.rabData.gudangKerja, 'Gudang Kerja'),
        _buildStaticRoomInput(provider, provider.rabData.bedengKerja, 'Bedeng Kerja'),
        _buildDivider(),
        _buildStaticRoomInput(provider, provider.rabData.kolamIkan, 'Kolam Ikan Koi', hasHeight: true, heightLabel: "Tinggi/Dalam"),
        _buildDivider(),
        _buildStaticRoomInput(provider, provider.rabData.kolamRenang, 'Kolam Renang', hasHeight: true, heightLabel: "Tinggi/Dalam"),
        _buildDivider(),
        _buildStaticRoomInput(provider, provider.rabData.pagar, 'Pagar Rumah', hasHeight: true, heightLabel: "Tinggi"),
        _buildStaticRoomInput(provider, provider.rabData.teralis, 'Teralis Pagar', hasHeight: true, heightLabel: "Tinggi", hasWindow: true, windowLabel: "Jumlah"),
        _buildStaticRoomInput(provider, provider.rabData.pintuPagar, 'Pintu Pagar', hasHeight: true, heightLabel: "Tinggi"),
      ],
    );
  }

  Widget _buildPlafonContent(RabProvider provider) {
    return Column(
      children: [
        _buildSingleInput(
          label: "Tinggi Plafon Lantai 1 (m)",
          initialValue: provider.rabData.ceilingHeightL1?.toString(),
          onChanged: (value) => provider.updateCeilingHeight(1, double.tryParse(value) ?? 0.0),
        ),
        if (widget.floorCount == 2) ...[
          const SizedBox(height: 16),
          _buildSingleInput(
            label: "Tinggi Plafon Lantai 2 (m)",
            initialValue: provider.rabData.ceilingHeightL2?.toString(),
            onChanged: (value) => provider.updateCeilingHeight(2, double.tryParse(value) ?? 0.0),
          ),
        ]
      ],
    );
  }

  // --- WIDGET-WIDGET PEMBANTU (HELPER) LENGKAP ---
  
  Widget _buildStaticRoomInput(RabProvider provider, RoomDimension room, String displayName, {bool hasWindow = false, String windowLabel = 'Jumlah Jendela', bool hasHeight = false, String heightLabel = 'Tinggi (m)'}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(displayName, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _buildTextFormField(
                label: 'Panjang (m)',
                initialValue: room.panjang == 0 ? '' : room.panjang.toString(),
                onChanged: (val) => provider.updateStaticRoomDimension(room, panjang: double.tryParse(val) ?? 0.0),
              )),
              const SizedBox(width: 16),
              Expanded(child: _buildTextFormField(
                label: 'Lebar (m)',
                initialValue: room.lebar == 0 ? '' : room.lebar.toString(),
                onChanged: (val) => provider.updateStaticRoomDimension(room, lebar: double.tryParse(val) ?? 0.0),
              )),
            ]),
            if (hasHeight) ...[
              const SizedBox(height: 12),
              _buildTextFormField(
                label: heightLabel,
                initialValue: room.tinggi == 0 ? '' : room.tinggi.toString(),
                onChanged: (val) => provider.updateStaticRoomDimension(room, tinggi: double.tryParse(val) ?? 0.0),
              )
            ],
            if (hasWindow) ...[
              const SizedBox(height: 12),
              _buildTextFormField(
                label: windowLabel,
                initialValue: room.jumlahJendela == 0 ? '' : room.jumlahJendela.toString(),
                onChanged: (val) => provider.updateStaticRoomDimension(room, jumlahJendela: int.tryParse(val) ?? 0),
                keyboardType: TextInputType.number
              )
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSingleInput({required String label, String? initialValue, ValueChanged<String>? onChanged}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _buildTextFormField(label: label, initialValue: initialValue, onChanged: onChanged),
      ),
    );
  }

  Widget _buildDynamicInputs(RabProvider provider, String roomKey, List<RoomDimension> roomList, {bool hasWindow = false, String windowLabel = 'Jumlah Jendela'}) {
    if (roomList.isEmpty) return const SizedBox.shrink();
    
    String displayName = roomKey.replaceAll('L1', '').replaceAll('L2', '').replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}').trim();
    displayName = displayName[0].toUpperCase() + displayName.substring(1);

    return Column(
      children: List.generate(roomList.length, (index) {
        final room = roomList[index];
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$displayName ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: _buildTextFormField(
                    label: 'Panjang (m)',
                    initialValue: room.panjang.toString(),
                    onChanged: (value) => provider.updateRoomDimension(roomList, index, panjang: double.tryParse(value) ?? 0.0),
                  )),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextFormField(
                    label: 'Lebar (m)',
                    initialValue: room.lebar.toString(),
                    onChanged: (value) => provider.updateRoomDimension(roomList, index, lebar: double.tryParse(value) ?? 0.0),
                  )),
                ]),
                if (hasWindow) ...[
                  const SizedBox(height: 12),
                  _buildTextFormField(
                    label: windowLabel,
                    initialValue: room.jumlahJendela.toString(),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => provider.updateRoomDimension(roomList, index, jumlahJendela: int.tryParse(value) ?? 0),
                  ),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }

  TextFormField _buildTextFormField({
    required String label,
    String? initialValue,
    ValueChanged<String>? onChanged,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      key: ValueKey(initialValue), 
      initialValue: initialValue,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      keyboardType: keyboardType ?? const TextInputType.numberWithOptions(decimal: true),
    );
  }
  
  Widget _buildCustomExpansionTile({required String title, required bool isExpanded, required VoidCallback onTap, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isExpanded ? Colors.blue.shade300 : Colors.grey.shade300, width: 1.5),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
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