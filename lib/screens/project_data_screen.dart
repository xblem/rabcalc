// lib/screens/project_data_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rabcalc/models/province.dart';
import 'package:rabcalc/models/regency.dart';
import 'package:rabcalc/providers/rab_provider.dart';
import 'package:rabcalc/screens/room_details_screen.dart';
import 'package:rabcalc/services/location_service.dart';
import 'package:rabcalc/utils/show_custom_flushbar.dart';
import 'package:rabcalc/widgets/custom_dropdown.dart';

class ProjectDataScreen extends StatefulWidget {
  const ProjectDataScreen({super.key});

  @override
  State<ProjectDataScreen> createState() => _ProjectDataScreenState();
}

class _ProjectDataScreenState extends State<ProjectDataScreen> {
  final LocationService _locationService = LocationService();
  List<Province> _provinces = [];
  List<Regency> _regencies = [];
  Province? _selectedProvince;
  Regency? _selectedRegency;
  bool _isLoadingProvinces = true;
  bool _isLoadingRegencies = false;

  final _projectNameController = TextEditingController();
  final _panjangTanahController = TextEditingController();
  final _lebarTanahController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final rabProvider = Provider.of<RabProvider>(context, listen: false);
    _projectNameController.text = rabProvider.rabData.projectName ?? '';
    _panjangTanahController.text = rabProvider.rabData.landLength?.toString() ?? '';
    _lebarTanahController.text = rabProvider.rabData.landWidth?.toString() ?? '';
    _fetchProvinces();
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _panjangTanahController.dispose();
    _lebarTanahController.dispose();
    super.dispose();
  }

  Future<void> _fetchProvinces() async {
    try {
      final provinces = await _locationService.getProvinces();
      setState(() {
        _provinces = provinces;
        _isLoadingProvinces = false;
      });
    } catch (e) {
      setState(() => _isLoadingProvinces = false);
      if (mounted) showErrorFlushbar(context, 'Gagal memuat provinsi: $e');
    }
  }

  Future<void> _fetchRegencies(String provinceId) async {
    setState(() {
      _isLoadingRegencies = true;
      _regencies = [];
      _selectedRegency = null;
    });
    try {
      final regencies = await _locationService.getRegencies(provinceId);
      setState(() {
        _regencies = regencies;
        _isLoadingRegencies = false;
      });
    } catch (e) {
      setState(() => _isLoadingRegencies = false);
      if (mounted) showErrorFlushbar(context, 'Gagal memuat kabupaten: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final rabProvider = Provider.of<RabProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Langkah 1: Data Dasar Proyek')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Info Umum'),
            const SizedBox(height: 16),
            _buildTextInput(
              controller: _projectNameController,
              label: 'Nama Proyek',
              hint: 'Contoh: Pembangunan Rumah Tipe 45',
              onChanged: (value) => rabProvider.updateProjectName(value),
            ),
            const SizedBox(height: 16),
            
            _isLoadingProvinces
                ? const Center(child: CircularProgressIndicator())
                : CustomDropdown<Province>(
                    hintText: 'Pilih Provinsi',
                    items: _provinces,
                    value: _selectedProvince,
                    onChanged: (province) {
                      if (province != null) {
                        setState(() => _selectedProvince = province);
                        _fetchRegencies(province.id);
                      }
                    },
                    itemBuilder: (province) => Text(province.name),
                  ),
            const SizedBox(height: 16),
            
            if (_selectedProvince != null)
              _isLoadingRegencies
                  ? const Center(child: CircularProgressIndicator())
                  : CustomDropdown<Regency>(
                      hintText: 'Pilih Kabupaten/Kota',
                      items: _regencies,
                      value: _selectedRegency,
                      onChanged: (regency) {
                        setState(() => _selectedRegency = regency);
                      },
                      itemBuilder: (regency) => Text(regency.name),
                    ),
            const SizedBox(height: 32),

            _buildSectionTitle('Tipe & Ukuran Bangunan'),
            const SizedBox(height: 16),
            
            CustomDropdown<String>(
              hintText: 'Pilih Tipe Bangunan',
              items: const ['Rumah'],
              value: rabProvider.rabData.buildingType,
              onChanged: (value) => rabProvider.updateBuildingType(value ?? 'Rumah'),
              itemBuilder: (item) => Text(item),
            ),
            const SizedBox(height: 16),
            CustomDropdown<String>(
              hintText: 'Pilih Jumlah Lantai',
              items: const ['1', '2'],
              value: rabProvider.rabData.floorCount?.toString(),
              onChanged: (value) => rabProvider.updateFloorCount(int.tryParse(value ?? '1') ?? 1),
              itemBuilder: (item) => Text(item),
            ),
            const SizedBox(height: 16),
            _buildTextInput(
              controller: _panjangTanahController,
              label: 'Panjang Tanah (m)',
              hint: 'Contoh: 12.5',
              keyboardType: TextInputType.number,
              onChanged: (value) => rabProvider.updateLandSize(
                panjang: double.tryParse(value) ?? 0.0,
                lebar: rabProvider.rabData.landWidth ?? 0.0,
              ),
            ),
            const SizedBox(height: 16),
            _buildTextInput(
              controller: _lebarTanahController,
              label: 'Lebar Tanah (m)',
              hint: 'Contoh: 6',
              keyboardType: TextInputType.number,
              onChanged: (value) => rabProvider.updateLandSize(
                panjang: rabProvider.rabData.landLength ?? 0.0,
                lebar: double.tryParse(value) ?? 0.0,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            rabProvider.updateLocation(
              provinsi: _selectedProvince?.name,
              kabupaten: _selectedRegency?.name,
            );

            if (rabProvider.rabData.floorCount != null && _selectedProvince != null && _selectedRegency != null) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => RoomDetailsScreen(floorCount: rabProvider.rabData.floorCount!),
              ));
            } else {
              showErrorFlushbar(context, 'Harap lengkapi semua data, termasuk provinsi dan kabupaten/kota.');
            }
          },
          child: const Text('Lanjut ke Detail Ruangan'),
        ),
      ),
    );
  }
 
  Widget _buildTextInput({
    required String label, required String hint,
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label, hintText: hint,
        filled: true, fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue, width: 1.5)),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    // Sedikit perbaikan dengan mengambil style dari Theme
    return Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold));
  }
}