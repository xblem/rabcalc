# rabcalc_backend/boq_calculator.py

def calculate_boq(project_info, static_room_details, room_details):
    """
    Menghitung Bill of Quantity (BoQ) super detail berdasarkan
    input dimensi dari pengguna dan asumsi teknis yang lebih akurat.
    (Struktur disesuaikan dengan versi lama)
    """
    
    # --- 1. Kumpulkan Data Dasar ---
    tinggi_plafon_l1 = project_info.get('ceiling_height_l1') or 3.5
    tinggi_plafon_l2 = project_info.get('ceiling_height_l2') or tinggi_plafon_l1
    jumlah_lantai = project_info.get('floor_count', 1)
    
    # --- Inisialisasi total volume ---
    total_luas_lantai_bangunan_m2 = 0.0
    total_luas_dinding_kotor_m2 = 0.0
    total_panjang_dinding_pondasi_m = 0.0
    total_luas_jendela_m2 = 0.0
    total_luas_plafon_m2 = 0.0
    
    # Gabungkan semua ruangan menjadi satu list untuk dihitung
    semua_ruangan = list(static_room_details.values())
    for room_list in room_details.values():
        semua_ruangan.extend(room_list)

    # Iterasi melalui semua ruangan untuk perhitungan agregat
    for room in semua_ruangan:
        panjang = room.get('panjang') or 0.0
        lebar = room.get('lebar') or 0.0
        
        # Asumsi semua tinggi dinding sama untuk penyederhanaan
        tinggi_dinding = tinggi_plafon_l1

        luas_lantai = panjang * lebar
        keliling = 2 * (panjang + lebar)
        
        total_luas_lantai_bangunan_m2 += luas_lantai
        total_luas_dinding_kotor_m2 += keliling * tinggi_dinding
        total_panjang_dinding_pondasi_m += keliling # Asumsi semua dinding punya pondasi
        total_luas_jendela_m2 += (room.get('jumlah_jendela') or 0) * 1.5 # Asumsi luas 1 jendela = 1.5 m2
        total_luas_plafon_m2 += luas_lantai # Asumsi luas plafon = luas lantai

    # --- Kalkulasi Volume Pekerjaan Berdasarkan Asumsi Teknis (Logika Baru) ---

    # A. PEKERJAAN PERSIAPAN
    panjang_bangunan = static_room_details.get('ruang_tamu_l1', {}).get('panjang', 10)
    lebar_bangunan = static_room_details.get('ruang_tamu_l1', {}).get('lebar', 8)
    volume_bouwplank_m = 2 * (panjang_bangunan + lebar_bangunan)

    # B. PEKERJAAN TANAH & PONDASI
    volume_galian_m3 = total_panjang_dinding_pondasi_m * 0.8 * 0.8
    volume_urugan_pasir_m3 = total_panjang_dinding_pondasi_m * 0.8 * 0.05
    volume_pondasi_m3 = total_panjang_dinding_pondasi_m * 0.7 * 0.8

    # C. PEKERJAAN STRUKTUR BETON
    vol_sloof_m3 = total_luas_lantai_bangunan_m2 * 0.08
    vol_kolom_m3 = total_luas_lantai_bangunan_m2 * 0.07 * jumlah_lantai
    vol_ring_balok_m3 = total_luas_lantai_bangunan_m2 * 0.06 * jumlah_lantai

    # D. PEKERJAAN DINDING & FINISHING
    luas_bukaan_m2 = (len(semua_ruangan) * 2.1) + total_luas_jendela_m2
    luas_dinding_bersih_m2 = total_luas_dinding_kotor_m2 - luas_bukaan_m2
    if luas_dinding_bersih_m2 < 0: luas_dinding_bersih_m2 = 0
    
    luas_plesteran_acian_m2 = luas_dinding_bersih_m2 * 2
    luas_pengecatan_m2 = luas_plesteran_acian_m2 + total_luas_plafon_m2

    # E. PEKERJAAN ATAP
    luas_atap_m2 = (total_luas_lantai_bangunan_m2 / jumlah_lantai) * 1.4

    # F. PEKERJAAN LISTRIK
    jumlah_titik_lampu = round(total_luas_lantai_bangunan_m2 / 12) or 1

    # Buat dictionary untuk hasil akhir volume (Output dari kode baru)
    volumes = {
        'pekerjaan_pengukuran_dan_bouwplank_m': round(volume_bouwplank_m, 2),
        'pekerjaan_galian_tanah_pondasi_m3': round(volume_galian_m3, 2),
        'pekerjaan_urugan_pasir_bawah_pondasi_m3': round(volume_urugan_pasir_m3, 2),
        'pekerjaan_pondasi_batu_belah_m3': round(volume_pondasi_m3, 2),
        'pekerjaan_beton_sloof_20x30_m3': round(vol_sloof_m3, 2),
        'pekerjaan_beton_kolom_25x25_m3': round(vol_kolom_m3, 2),
        'pekerjaan_beton_ring_balok_15x20_m3': round(vol_ring_balok_m3, 2),
        'pekerjaan_dinding_bata_merah_m2': round(luas_dinding_bersih_m2, 2),
        'pekerjaan_dinding_bata_ringan_m2': round(luas_dinding_bersih_m2, 2),
        'pekerjaan_plesteran_dinding_m2': round(luas_plesteran_acian_m2, 2),
        'pekerjaan_acian_dinding_m2': round(luas_plesteran_acian_m2, 2),
        'pekerjaan_lantai_keramik_40x40_m2': round(total_luas_lantai_bangunan_m2, 2),
        'pekerjaan_dinding_keramik_20x25_m2': round(len(room_details.get('kamar_mandi_l1',[])) * 15, 2),
        'pekerjaan_rangka_atap_baja_ringan_m2': round(luas_atap_m2, 2),
        'pekerjaan_penutup_atap_genteng_beton_m2': round(luas_atap_m2, 2),
        'pekerjaan_plafon_gypsum_m2': round(total_luas_plafon_m2, 2),
        'pekerjaan_pengecatan_tembok_m2': round(luas_pengecatan_m2, 2),
        'pekerjaan_titik_lampu_titik': jumlah_titik_lampu,
    }
    
    return volumes