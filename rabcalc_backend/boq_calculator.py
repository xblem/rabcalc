# rabcalc_backend/boq_calculator.py

def calculate_boq(project_info, room_details):
    """
    Menghitung Bill of Quantity (BoQ) lengkap berdasarkan
    input dimensi detail dari pengguna.
    """
    
    tinggi_plafon_l1 = project_info.get('ceiling_height', 3.0)
    # Asumsi tinggi plafon lantai 2 sama jika tidak diinput
    tinggi_plafon_l2 = project_info.get('ceiling_height_l2', tinggi_plafon_l1)
    
    # --- Inisialisasi total volume ---
    total_luas_dinding_m2 = 0.0
    total_luas_lantai_m2 = 0.0
    total_panjang_pondasi_m = 0.0
    total_luas_jendela_m2 = 0.0
    total_luas_plafon_m2 = 0.0
    total_volume_beton_m3 = 0.0

    # Iterasi melalui setiap jenis ruangan yang dikirim dari Flutter
    for room_type, rooms in room_details.items():
        is_lantai_1 = 'l1' in room_type or room_type in ['teras', 'taman', 'garasi']
        tinggi_dinding = tinggi_plafon_l1 if is_lantai_1 else tinggi_plafon_l2

        for room in rooms:
            panjang = room.get('panjang', 0.0)
            lebar = room.get('lebar', 0.0)
            
            # --- PERBAIKAN DARI KODE BARU DITERAPKAN DI SINI ---
            # Memastikan 'jumlah_jendela' tidak pernah None
            jumlah_jendela = room.get('jendela') or 0
            
            luas_lantai = panjang * lebar
            keliling = 2 * (panjang + lebar)
            luas_dinding = keliling * tinggi_dinding

            total_luas_lantai_m2 += luas_lantai
            total_luas_dinding_m2 += luas_dinding
            total_luas_plafon_m2 += luas_lantai # Luas plafon = luas lantai
            
            if is_lantai_1:
                total_panjang_pondasi_m += keliling
            
            total_luas_jendela_m2 += jumlah_jendela * 1.2

    # --- Kalkulasi Volume Pekerjaan Berdasarkan Asumsi Teknis ---
    
    # Volume Pondasi (Batu Kali)
    # Asumsi: lebar atas 0.3m, lebar bawah 0.6m, tinggi 0.8m
    volume_pondasi_m3 = total_panjang_pondasi_m * ((0.3 + 0.6) / 2) * 0.8
    
    # Volume Beton Bertulang (Sloof, Kolom, Balok)
    # Asumsi sederhana: 0.15 m3 beton per m2 luas lantai
    total_volume_beton_m3 = total_luas_lantai_m2 * 0.15
    
    # Kebutuhan Besi Beton
    # Asumsi: 125 kg besi per m3 beton
    total_kebutuhan_besi_kg = total_volume_beton_m3 * 125
    
    # Luas Bekisting
    # Asumsi: 8 m2 bekisting per m3 beton
    total_luas_bekisting_m2 = total_volume_beton_m3 * 8
    
    # Luas Atap
    # Asumsi: Luas atap = 1.3x luas lantai teratas
    luas_lantai_teratas = 0.0
    if project_info.get('floor_count', 1) > 1:
        # Hitung luas lantai 2 (atau lantai teratas)
        for room_type, rooms in room_details.items():
            if 'l2' in room_type:
                for room in rooms:
                    luas_lantai_teratas += room.get('panjang', 0.0) * room.get('lebar', 0.0)
    else:
        luas_lantai_teratas = total_luas_lantai_m2
    
    total_luas_atap_m2 = luas_lantai_teratas * 1.3

    # Finalisasi volume dinding bersih (dikurangi bukaan pintu & jendela)
    jumlah_ruangan = sum(len(v) for v in room_details.values())
    luas_dinding_bersih_m2 = total_luas_dinding_m2 - (jumlah_ruangan * 1.8) - total_luas_jendela_m2
    if luas_dinding_bersih_m2 < 0: luas_dinding_bersih_m2 = 0

    # Buat dictionary untuk hasil akhir volume
    volumes = {
        'pekerjaan_galian_tanah_biasa_1m_m3': round(volume_pondasi_m3 * 1.2, 2), # Galian lebih besar dari pondasi
        'pekerjaan_pondasi_batu_belah_1pc_5ps_m3': round(volume_pondasi_m3, 2),
        'pekerjaan_beton_k225_m3': round(total_volume_beton_m3, 2),
        'pekerjaan_pembesian_kg': round(total_kebutuhan_besi_kg, 2),
        'pekerjaan_bekisting_kolom_m2': round(total_luas_bekisting_m2, 2),
        'pekerjaan_dinding_m2': round(luas_dinding_bersih_m2, 2),
        'pekerjaan_plesteran_m2': round(luas_dinding_bersih_m2 * 2, 2),
        'pekerjaan_pengecatan_m2': round((luas_dinding_bersih_m2 * 2) + total_luas_plafon_m2, 2), # Pengecatan dinding + plafon
        'pekerjaan_keramik_lantai_m2': round(total_luas_lantai_m2, 2),
        'pekerjaan_plafon_gypsum_m2': round(total_luas_plafon_m2, 2),
        'pekerjaan_rangka_atap_baja_ringan_m2': round(total_luas_atap_m2, 2),
        'pekerjaan_penutup_atap_genteng_beton_m2': round(total_luas_atap_m2, 2),
    }
    
    return volumes