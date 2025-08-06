// lib/screens/material_specs_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rabcalc/providers/rab_provider.dart';
import 'package:rabcalc/screens/results_screen.dart';
import 'package:rabcalc/widgets/custom_dropdown.dart';

class MaterialSpecsScreen extends StatelessWidget {
  const MaterialSpecsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Langkah 3: Spesifikasi Material'),
      ),
      body: Consumer<RabProvider>(
        builder: (context, provider, child) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildPickerSection(
                label: 'Bahan Dinding',
                child: CustomDropdown<String>(
                  hintText: 'Pilih Bahan Dinding',
                  items: const ['Hebel/Bata Ringan', 'Batu Bata/Bata Merah', 'Batako Semen', 'Batako Putih'],
                  value: provider.rabData.materialSelections['Bahan Dinding'],
                  onChanged: (newValue) => provider.updateMaterialSelection('Bahan Dinding', newValue),
                  itemBuilder: (item) => Text(item),
                ),
              ),
              _buildPickerSection(
                label: 'Bahan Cat Tembok',
                child: CustomDropdown<String>(
                  hintText: 'Pilih Bahan Cat',
                  items: const ['Cat Kualitas Sedang', 'Cat Kualitas Baik', 'Wallpaper'],
                  value: provider.rabData.materialSelections['Bahan Cat Tembok'],
                  onChanged: (newValue) => provider.updateMaterialSelection('Bahan Cat Tembok', newValue),
                  itemBuilder: (item) => Text(item),
                ),
              ),
              _buildPickerSection(
                label: 'Bahan Lantai',
                child: CustomDropdown<String>(
                  hintText: 'Pilih Bahan Lantai',
                  items: const ['Lantai Keramik 40x40 Polished', 'Lantai Keramik 20x20', 'Lantai Keramik 30x30', 'Lantai Keramik 40x40 Unpolished', 'Lantai Keramik 60x60', 'Lantai Keramik 60x90', 'Lantai Granit', 'Lantai Marmer', 'Lantai Parquet Jati'],
                  value: provider.rabData.materialSelections['Bahan Lantai'],
                  onChanged: (newValue) => provider.updateMaterialSelection('Bahan Lantai', newValue),
                  itemBuilder: (item) => Text(item),
                ),
              ),
              _buildPickerSection(
                label: 'Bahan Rangka Atap',
                child: CustomDropdown<String>(
                  hintText: 'Pilih Rangka Atap',
                  items: const ['Baja Ringan', 'Kayu Kamper', 'Kayu Borneo'],
                  value: provider.rabData.materialSelections['Bahan Rangka Atap'],
                  onChanged: (newValue) => provider.updateMaterialSelection('Bahan Rangka Atap', newValue),
                  itemBuilder: (item) => Text(item),
                ),
              ),
              _buildPickerSection(
                label: 'Bahan Penutup Atap',
                child: CustomDropdown<String>(
                  hintText: 'Pilih Penutup Atap',
                  items: const ['Genteng Beton', 'Genteng Plentong', 'Seng', 'Asbes', 'Metal', 'Sirap'],
                  value: provider.rabData.materialSelections['Bahan Penutup Atap'],
                  onChanged: (newValue) => provider.updateMaterialSelection('Bahan Penutup Atap', newValue),
                  itemBuilder: (item) => Text(item),
                ),
              ),
              _buildPickerSection(
                label: 'Bahan Plafon',
                child: CustomDropdown<String>(
                  hintText: 'Pilih Bahan Plafon',
                  items: const ['Gypsum Rangka Hollow', 'Akustik Rangka Hollow', 'GRC Rangka Kayu', 'Triplek Rangka Kayu'],
                  value: provider.rabData.materialSelections['Bahan Plafon'],
                  onChanged: (newValue) => provider.updateMaterialSelection('Bahan Plafon', newValue),
                  itemBuilder: (item) => Text(item),
                ),
              ),
              _buildPickerSection(
                label: 'Bahan Kusen Pintu/Jendela',
                child: CustomDropdown<String>(
                  hintText: 'Pilih Bahan Kusen',
                  items: const ['Kayu Borneo', 'Kayu Kamper', 'Alumunium'],
                  value: provider.rabData.materialSelections['Bahan Kusen'],
                  onChanged: (newValue) => provider.updateMaterialSelection('Bahan Kusen', newValue),
                  itemBuilder: (item) => Text(item),
                ),
              ),
              _buildPickerSection(
                label: 'Bahan Kloset',
                child: CustomDropdown<String>(
                  hintText: 'Pilih Tipe Kloset',
                  items: const ['Kloset Duduk', 'Kloset Jongkok'],
                  value: provider.rabData.materialSelections['Bahan Kloset'],
                  onChanged: (newValue) => provider.updateMaterialSelection('Bahan Kloset', newValue),
                  itemBuilder: (item) => Text(item),
                ),
              ),
              
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  await Provider.of<RabProvider>(context, listen: false).calculateRAB();
                  if (context.mounted) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ResultsScreen()));
                  }
                },
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('LIHAT HASIL ESTIMASI RAB'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPickerSection({required String label, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}