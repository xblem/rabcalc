# rabcalc_backend/boq_calculator.py

def calculate_boq(project_info, static_room_details, room_details):
    """
    Menghitung Bill of Quantity (BoQ) super detail berdasarkan
    input dimensi dari pengguna dan asumsi teknis yang lebih akurat.
    (Struktur disesuaikan dengan versi lama dan ditambahkan fitur baru)
    """
    
    # --- 1. Kumpulkan Data Dasar ---
    tinggi_plafon_l1 = project_info.get('ceiling_height_l1') or 3.5
    tinggi_plafon_l2 = project_info.get('ceiling_height_l2') or tinggi_plafon_l1
    jumlah_lantai = project_info.get('floor_count', 1)
    luas_tanah = project_info.get('land_size', 200)
    
    # --- Inisialisasi total volume ---
    total_luas_lantai_bangunan_m2 = 0.0
    total_luas_dinding_kotor_m2 = 0.0
    total_panjang_dinding_pondasi_m = 0.0
    total_luas_jendela_m2 = 0.0
    total_luas_plafon_m2 = 0.0
    jumlah_kamar_mandi = 0
    jumlah_pintu = 0
    jumlah_jendela_total = 0
    
    # Gabungkan semua ruangan menjadi satu list
    semua_ruangan = list(static_room_details.values())
    for room_list in room_details.values():
        semua_ruangan.extend(room_list)

    # Hitung jumlah pintu, jendela, dan kamar mandi
    for key, room_list in room_details.items():
        if 'kamar_mandi' in key:
            jumlah_kamar_mandi += len(room_list)
        if 'ruang_tidur' in key or 'teras' in key:
            jumlah_pintu += len(room_list)
    
    # Iterasi melalui semua ruangan untuk perhitungan agregat
    for room in semua_ruangan:
        panjang = room.get('panjang', 0.0)
        lebar = room.get('lebar', 0.0)
        luas_lantai = panjang * lebar
        keliling = 2 * (panjang + lebar)
        jumlah_jendela_ruangan = room.get('jumlah_jendela', 0)

        total_luas_lantai_bangunan_m2 += luas_lantai
        total_luas_dinding_kotor_m2 += keliling * tinggi_plafon_l1
        total_panjang_dinding_pondasi_m += keliling
        total_luas_jendela_m2 += jumlah_jendela_ruangan * 1.5
        jumlah_jendela_total += jumlah_jendela_ruangan
        total_luas_plafon_m2 += luas_lantai

    # --- Kalkulasi Volume Pekerjaan Berdasarkan Asumsi Teknis (Logika Di-upgrade) ---

    # A. PEKERJAAN PERSIAPAN
    panjang_bangunan = static_room_details.get('ruang_tamu_l1', {}).get('panjang', 10)
    lebar_bangunan = static_room_details.get('ruang_tamu_l1', {}).get('lebar', 8)
    volume_bouwplank_m = total_panjang_dinding_pondasi_m if total_panjang_dinding_pondasi_m > 0 else 15.0
    volume_gudang_m2 = 25.0
    volume_pembersihan_m2 = luas_tanah

    # B. PEKERJAAN TANAH & PONDASI
    volume_galian_m3 = total_panjang_dinding_pondasi_m * 0.8 * 0.8
    volume_urugan_kembali_m3 = volume_galian_m3 * (1/3)
    volume_urugan_pasir_m3 = total_panjang_dinding_pondasi_m * 0.8 * 0.05
    volume_pondasi_batu_kosong_m3 = total_panjang_dinding_pondasi_m * 0.8 * 0.2
    volume_pondasi_m3 = total_panjang_dinding_pondasi_m * 0.7 * 0.8
    volume_pondasi_plat_m3 = (total_luas_lantai_bangunan_m2 / 50) * 0.2

    # C. PEKERJAAN STRUKTUR BETON
    vol_sloof_m3 = total_panjang_dinding_pondasi_m * 0.15 * 0.25
    vol_kolom_m3 = (total_luas_lantai_bangunan_m2 / 12) * 0.15 * 0.15 * tinggi_plafon_l1 * jumlah_lantai
    vol_ring_balok_m3 = total_panjang_dinding_pondasi_m * 0.15 * 0.20 * jumlah_lantai
    vol_tangga_m3 = 1.5 * (jumlah_lantai - 1) if jumlah_lantai > 1 else 0
    vol_plat_lantai_m3 = total_luas_plafon_m2 * 0.12 * (jumlah_lantai - 1) if jumlah_lantai > 1 else 0

    # D. PEKERJAAN DINDING & FINISHING
    luas_bukaan_m2 = (jumlah_pintu * 2.1 * 0.8) + total_luas_jendela_m2
    luas_dinding_bersih_m2 = max(0, total_luas_dinding_kotor_m2 - luas_bukaan_m2)
    luas_plesteran_acian_m2 = luas_dinding_bersih_m2 * 2
    luas_pengecatan_tembok_m2 = luas_plesteran_acian_m2 + total_luas_plafon_m2
    luas_dinding_keramik_km_m2 = jumlah_kamar_mandi * 15

    # E. PEKERJAAN ATAP
    luas_atap_m2 = (total_luas_lantai_bangunan_m2 / jumlah_lantai) * 1.4
    volume_rangka_atap_kayu_m3 = luas_atap_m2 * 0.08
    
    # F. PEKERJAAN LISTRIK & SANITASI
    jumlah_titik_lampu = round(total_luas_lantai_bangunan_m2 / 12) or 1
    jumlah_stop_kontak = round(total_luas_lantai_bangunan_m2 / 20) or 1
    total_panjang_pipa = total_luas_lantai_bangunan_m2 * 0.5

    # Buat dictionary untuk hasil akhir volume (Output Lengkap)
    volumes = {
        'pekerjaan_pengukuran_dan_bouwplank_m': {'volume': round(volume_bouwplank_m, 2), 'spek': 'Pengukuran dan pemasangan bouwplank'},
        'pekerjaan_pembuatan_gudang_proyek_m2': {'volume': round(volume_gudang_m2, 2), 'spek': 'Gudang kerja sementara'},
        'pekerjaan_pembersihan_lokasi_proyek_m2': {'volume': round(volume_pembersihan_m2, 2), 'spek': 'Seluas tanah yang akan dibangun'},
        
        'pekerjaan_galian_tanah_pondasi_m3': {'volume': round(volume_galian_m3, 2), 'spek': 'Galian tanah pondasi'},
        'pekerjaan_urugan_tanah_kembali_m3': {'volume': round(volume_urugan_kembali_m3, 2), 'spek': 'Urugan tanah kembali'},
        'pekerjaan_urugan_pasir_bawah_pondasi_m3': {'volume': round(volume_urugan_pasir_m3, 2), 'spek': 'Urugan pasir bawah pondasi'},
        'pekerjaan_pondasi_batu_kosong_m3': {'volume': round(volume_pondasi_batu_kosong_m3, 2), 'spek': 'Pondasi batu kosong (aanstamping)'},
        'pekerjaan_pondasi_batu_kali_m3': {'volume': round(volume_pondasi_m3, 2), 'spek': 'Pondasi batu kali'},
        'pekerjaan_pondasi_plat_beton_m3': {'volume': round(volume_pondasi_plat_m3, 2), 'spek': 'Pondasi plat beton'},
        
        'pekerjaan_beton_sloof_m3': {'volume': round(vol_sloof_m3, 2), 'spek': 'Sloof beton bertulang'},
        'pekerjaan_beton_kolom_m3': {'volume': round(vol_kolom_m3, 2), 'spek': 'Kolom beton bertulang'},
        'pekerjaan_beton_ring_balok_m3': {'volume': round(vol_ring_balok_m3, 2), 'spek': 'Ring balok beton bertulang'},
        'pekerjaan_beton_tangga_m3': {'volume': round(vol_tangga_m3, 2), 'spek': 'Tangga beton bertulang'},
        'pekerjaan_plat_lantai_beton_m3': {'volume': round(vol_plat_lantai_m3, 2), 'spek': 'Plat lantai beton bertulang'},

        'pekerjaan_dinding_bata_merah_m2': {'volume': round(luas_dinding_bersih_m2, 2), 'spek': ''},
        'pekerjaan_dinding_bata_ringan_m2': {'volume': round(luas_dinding_bersih_m2, 2), 'spek': ''},
        'pekerjaan_plesteran_dinding_m2': {'volume': round(luas_plesteran_acian_m2, 2), 'spek': ''},
        'pekerjaan_acian_dinding_m2': {'volume': round(luas_plesteran_acian_m2, 2), 'spek': ''},
        'pekerjaan_lantai_keramik_40x40_m2': {'volume': round(total_luas_lantai_bangunan_m2, 2), 'spek': ''},
        'pekerjaan_dinding_keramik_20x25_m2': {'volume': round(luas_dinding_keramik_km_m2, 2), 'spek': 'Untuk dinding kamar mandi'},
        
        'pekerjaan_rangka_atap_baja_ringan_m2': {'volume': round(luas_atap_m2, 2), 'spek': ''},
        'pekerjaan_penutup_atap_genteng_beton_m2': {'volume': round(luas_atap_m2, 2), 'spek': ''},
        'pekerjaan_rangka_atap_kayu_kamper_m3': {'volume': round(volume_rangka_atap_kayu_m3, 2), 'spek': 'Konstruksi kuda-kuda kayu kamper'},
        'pekerjaan_kaso_reng_kayu_m2': {'volume': round(luas_atap_m2, 2), 'spek': 'Pasang kaso dan reng'},
        'pekerjaan_penutup_atap_genteng_plentong_m2': {'volume': round(luas_atap_m2, 2), 'spek': 'Atap genteng plentong'},
        'pekerjaan_nok_genteng_keramik_m2': {'volume': round(luas_atap_m2 * 0.1, 2), 'spek': 'Nok/bubungan atap'},

        'pekerjaan_plafon_gypsum_m2': {'volume': round(total_luas_plafon_m2, 2), 'spek': ''},
        'pekerjaan_pengecatan_tembok_plafon_m2': {'volume': round(luas_pengecatan_tembok_m2, 2), 'spek': ''},
        
        'pekerjaan_titik_lampu_titik': {'volume': jumlah_titik_lampu, 'spek': ''},
        'pekerjaan_stop_kontak_bh': {'volume': jumlah_stop_kontak, 'spek': ''},
        'pekerjaan_panel_listrik_unit': {'volume': 1, 'spek': ''},
        'pekerjaan_penyambungan_daya_listrik_ls': {'volume': 1, 'spek': ''},
        
        'pekerjaan_kloset_duduk_unit': {'volume': jumlah_kamar_mandi, 'spek': ''},
        'pekerjaan_shower_unit': {'volume': jumlah_kamar_mandi, 'spek': ''},
        'pekerjaan_keran_air_unit': {'volume': jumlah_kamar_mandi + 1, 'spek': 'KM + Dapur'},
        'pekerjaan_floor_drain_unit': {'volume': jumlah_kamar_mandi, 'spek': ''},
        'pekerjaan_septic_tank_unit': {'volume': 1, 'spek': ''},

        'pekerjaan_pipa_pvc_1_2_inchi_m': {'volume': round(total_panjang_pipa, 2), 'spek': 'Instalasi air bersih'},
        'pekerjaan_pipa_pvc_4_inchi_m': {'volume': round(total_panjang_pipa, 2), 'spek': 'Instalasi air kotor'},
        'pekerjaan_pompa_air_unit': {'volume': 1, 'spek': ''},
        'pekerjaan_penyambungan_pipa_pdam_ls': {'volume': 1, 'spek': ''},

        'pekerjaan_kunci_pintu_standar_unit': {'volume': jumlah_pintu, 'spek': ''},
        'pekerjaan_engsel_pintu_unit': {'volume': jumlah_pintu, 'spek': ''},
        'pekerjaan_engsel_jendela_unit': {'volume': jumlah_jendela_total, 'spek': ''},
        'pekerjaan_kait_angin_unit': {'volume': jumlah_jendela_total, 'spek': ''},
        'pekerjaan_kaca_5mm_m2': {'volume': round(total_luas_jendela_m2, 2), 'spek': ''},
    }
    
    return volumes