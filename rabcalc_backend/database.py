# rabcalc_backend/database.py

# Kamus ini menyimpan harga default (berdasarkan data referensi dan rerata nasional)
HARGA_DEFAULT = {
    # Upah
    "upah_pekerja": 145920.0,
    "upah_tukang_batu": 232760.0,
    "upah_tukang_kayu": 232760.0,
    "upah_tukang_besi": 232760.0,
    "upah_tukang_cat": 232760.0,
    "upah_kepala_tukang": 170000.0,
    "upah_mandor": 180000.0,
    "upah_tukang_ledeng": 211600.0,
    "upah_tukang_listrik": 232760.0,
    "upah_tukang_gali": 169280.0,

    # Material Pokok & Struktur
    "semen_pc_50kg": 115013.85,
    "pasir_pasang": 230595.75,
    "pasir_beton": 243173.70,
    "pasir_urug": 226403.10,
    "batu_pecah_1-2": 421344.0,
    "batu_belah_10-15": 228690.0,
    "bata_merah_bakar": 952.35,
    "bata_ringan_hebel": 650000.0,
    "semen_instan_perekat": 95000.0,
    "besi_beton_polos": 15293.25,
    "kawat_beton": 26595.45,
    
    # Material Bekisting & Persiapan
    "papan_kayu_kelas_3": 2917530.0,
    "balok_kayu_kelas_2": 5835060.0,
    "paku_biasa": 26595.45,
    "minyak_bekisting": 38420.55,
    "plywood_9mm": 198725.10,
    "seng_gelombang": 135637.95,
    "balok_kayu_kamper": 6710319.0,
    "besi_c_channel": 21940.80,
    "genteng_plentong": 3974.25,
    "nok_genteng_keramik": 34446.30,

    # Material Finishing & Interior
    "cat_tembok_vinilex": 30000.0,
    "cat_tembok_dulux": 46370.10,
    "plamir_tembok": 34446.30,
    "keramik_lantai_40x40": 82139.40,
    "keramik_dinding_20x25": 86114.70,
    "semen_nat": 6259.05,
    "gypsum_board_9mm": 95387.25,
    "rangka_hollow_galvanis": 18000.0,
    "kusen_pintu_kayu_kamper": 4500000.0,
    "pintu_panel_kayu": 450000.0,
    "hollow_4x4": 39893.70,
    "hollow_2x4": 33245.10,
    "compound": 5829.60,
    "cotton_plester": 10598.70,
    "paku_sekrup": 132.30,
    "ramseth": 1986.60,

    # Material Sanitasi & Elektrikal
    "kloset_duduk_toto": 1457316.0,
    "pipa_pvc_4_inch": 78285.90,
    "stop_kontak_panasonic": 31795.05,
    "lampu_led_philips": 66241.35,
    "kabel_nym_2x1.5": 8000.0,
    "kabel_nya_2x2.5": 847892.85,
    "kabel_nym_3x2.5": 1066490.25,
    "panel_listrik": 264966.45,
    "shower": 105987.0,
    "bak_mandi_fiberglass": 569677.50,
    "kitchen_sink": 158979.45,
    "wastafel": 1099610.40,
    "keran_air": 33121.20,
    "floor_drain": 46370.10,
    "soap_holder": 46370.10,
    "pompa_air": 576303.0,

    # Material Tambahan
    "aluminium_daun_pintu_jendela": 99582.00,
    "aluminium_kusen_pintu_jendela_4in": 119014.35,
    "atap_upvc": 298087.65,
    "kawat_las": 6624.45,
    "besi_profil": 22141.35,
    "sirtu_pasir_koral": 222210.45,
    "conblok_4_21x105x8cm_abu": 125185.20,
    "meni_kayu": 37095.45,
    "cat_dasar_primer": 56967.75,
    "cat_besi": 79490.25,
    "ampelas": 7949.55,
    "roll_cat": 30471.00,
    "lem_kayu": 39744.60,
    "kuas_3inchi": 11923.80,
    "lampu_baret_30cm": 291463.20,
    "kaca_3mm": 185476.20,
    "kaca_5mm": 278214.30,
    "keramik_20x20": 86114.70,
    "plint_keramik_10x30": 7287.00,
    "scafolding_set": 311336.55,
    "teakwood_4mm": 132483.75,
    "kunci_pintu_2slaag_besar": 125859.30,
    "kunci_pintu_2slaag_standar": 92738.10,
    "selot_gerendel_pintu_4in": 19873.35,
    "selot_gerendel_jendela_3in": 15898.05,
    "engsel_pintu": 33121.20,
    "engsel_jendela": 26496.75,
    "door_holder": 43718.85,
    "kait_angin_jendela": 19873.35,
    "paku_semua_ukuran": 26595.45,
    "paku_ukuran_besar": 26595.45,
    "paku_5_10cm": 26595.45,
    "paku_1_5cm": 26595.45,
    "paku_7_10cm": 26595.45,
    "injuk": 14254.80,
    "pipa_pvc_aw_1_2in": 8612.10,
    "pipa_pvc_aw_2in": 36131.55,
    "pintu_aluminium_pvc": 1099610.40,
    "papan_kayu_kamper_medan": 6710319.00,
    "balok_dolken_8_10cm": 58350.60,
    "keran_air_angsa": 99362.55,
    "penyambungan_pipa_pdam": 2007322.00,
    "penyambungan_daya_listrik": 2523490.00,

    # Material dari kode lama yang tidak ada di kode baru
    "sekrup_baja_ringan": 500.0,
    "baja_ringan_c75": 180000.0,
    "genteng_beton_flat": 3500.0,
    "nok_genteng_beton": 15000.0,
}

# Kamus ini adalah "Buku Resep" AHSP kita, sudah disempurnakan.
KOEFISIEN_AHSP = {
    # --- PEKERJAAN PERSIAPAN ---
    "pekerjaan_pengukuran_dan_bouwplank_m": {
        "default": {"balok_kayu_kelas_2": 0.012, "paku_biasa": 0.02, "papan_kayu_kelas_3": 0.007, "upah_pekerja": 0.1, "upah_tukang_kayu": 0.1, "upah_kepala_tukang": 0.01, "upah_mandor": 0.005}
    },
    "pekerjaan_pembersihan_lokasi_proyek_m2": { 
        "default": {"upah_pekerja": 0.1, "upah_mandor": 0.05}
    },
    "pekerjaan_pembuatan_gudang_proyek_m2": { 
        "default": {"balok_kayu_kelas_2": 0.18, "seng_gelombang": 1.2, "paku_biasa": 0.3, "upah_pekerja": 0.5, "upah_tukang_kayu": 0.7, "upah_kepala_tukang": 0.07, "upah_mandor": 0.025}
    },

    # --- PEKERJAAN TANAH & PONDASI ---
    "pekerjaan_galian_tanah_pondasi_m3": {
        "default": { "upah_pekerja": 0.75, "upah_mandor": 0.025 }
    },
    "pekerjaan_urugan_tanah_kembali_m3": { 
        "default": { "upah_pekerja": 0.25, "upah_mandor": 0.008 }
    },
    "pekerjaan_urugan_pasir_bawah_pondasi_m3": {
        "default": { "pasir_urug": 1.2, "upah_pekerja": 0.3, "upah_mandor": 0.01 }
    },
    "pekerjaan_pondasi_batu_kosong_m3": {
        "default": {"batu_belah_10-15": 1.2, "pasir_urug": 0.432, "upah_pekerja": 0.78, "upah_tukang_batu": 0.39, "upah_kepala_tukang": 0.039, "upah_mandor": 0.039}
    },
    "pekerjaan_pondasi_batu_kali_m3": {
        "default": {"batu_belah_10-15": 1.2, "semen_pc_50kg": 2.72, "pasir_pasang": 0.544, "upah_pekerja": 1.5, "upah_tukang_batu": 0.75, "upah_kepala_tukang": 0.075, "upah_mandor": 0.075}
    },
    "pekerjaan_pondasi_plat_beton_m3": {
        "default": {"papan_kayu_kelas_3": 0.2, "paku_biasa": 1.5, "minyak_bekisting": 0.4, "besi_beton_polos": 125.0, "kawat_beton": 2.25, "semen_pc_50kg": 6.46, "pasir_beton": 0.52, "batu_pecah_1-2": 0.78, "upah_pekerja": 3.9, "upah_tukang_batu": 0.35, "upah_tukang_kayu": 1.04, "upah_tukang_besi": 1.05, "upah_kepala_tukang": 0.15, "upah_mandor": 0.2}
    },

    # --- PEKERJAAN BETON BERTULANG ---
    "pekerjaan_beton_sloof_m3": {
        "default": {"semen_pc_50kg": 8.4, "pasir_beton": 0.52, "batu_pecah_1-2": 0.78, "besi_beton_polos": 180.0, "kawat_beton": 2.7, "papan_kayu_kelas_3": 0.27, "paku_biasa": 2.0, "minyak_bekisting": 0.6, "upah_pekerja": 5.2, "upah_tukang_batu": 1.5, "upah_tukang_besi": 1.2, "upah_tukang_kayu": 1.25, "upah_kepala_tukang": 0.2, "upah_mandor": 0.26}
    },
    "pekerjaan_beton_kolom_m3": {
        "default": {"semen_pc_50kg": 8.4, "pasir_beton": 0.52, "batu_pecah_1-2": 0.78, "besi_beton_polos": 150.0, "kawat_beton": 2.25, "papan_kayu_kelas_3": 0.27, "paku_biasa": 2.0, "minyak_bekisting": 0.6, "upah_pekerja": 5.2, "upah_tukang_batu": 1.5, "upah_tukang_besi": 1.2, "upah_tukang_kayu": 1.25, "upah_kepala_tukang": 0.2, "upah_mandor": 0.26}
    },
    "pekerjaan_beton_ring_balok_m3": {
        "default": {"semen_pc_50kg": 8.4, "pasir_beton": 0.52, "batu_pecah_1-2": 0.78, "besi_beton_polos": 175.0, "kawat_beton": 2.6, "papan_kayu_kelas_3": 0.27, "paku_biasa": 2.0, "minyak_bekisting": 0.6, "upah_pekerja": 5.2, "upah_tukang_batu": 1.5, "upah_tukang_besi": 1.2, "upah_tukang_kayu": 1.25, "upah_kepala_tukang": 0.2, "upah_mandor": 0.26}
    },
    "pekerjaan_beton_tangga_m3": {
        "default": {"semen_pc_50kg": 6.45, "pasir_beton": 0.52, "batu_pecah_1-2": 0.78, "besi_beton_polos": 200.0, "kawat_beton": 3.0, "papan_kayu_kelas_3": 0.25, "paku_biasa": 3.0, "minyak_bekisting": 1.2, "balok_kayu_kelas_2": 0.3, "plywood_9mm": 2.5, "upah_pekerja": 5.6, "upah_tukang_batu": 0.35, "upah_tukang_kayu": 2.3, "upah_tukang_besi": 1.4, "upah_kepala_tukang": 0.23, "upah_mandor": 0.28}
    },
    "pekerjaan_plat_lantai_beton_m3": {
        "default": {"semen_pc_50kg": 6.72, "pasir_beton": 0.54, "batu_pecah_1-2": 0.81, "besi_beton_polos": 120.75, "kawat_beton": 2.3, "papan_kayu_kelas_3": 0.33, "paku_biasa": 3.33, "minyak_bekisting": 1.67, "balok_kayu_kelas_2": 0.33, "plywood_9mm": 2.92, "upah_pekerja": 5.33, "upah_tukang_batu": 0.35, "upah_tukang_kayu": 2.75, "upah_tukang_besi": 1.15, "upah_kepala_tukang": 0.28, "upah_mandor": 0.27}
    },

    # --- PEKERJAAN DINDING & FINISHING ---
    "pekerjaan_dinding_bata_merah_m2": {
        "default": {"bata_merah_bakar": 70.0, "semen_pc_50kg": 0.23, "pasir_pasang": 0.04, "upah_pekerja": 0.3, "upah_tukang_batu": 0.1, "upah_kepala_tukang": 0.01, "upah_mandor": 0.015}
    },
     "pekerjaan_dinding_bata_ringan_m2": {
        "default": {"bata_ringan_hebel": 0.1, "semen_instan_perekat": 0.25, "upah_pekerja": 0.1, "upah_tukang_batu": 0.1, "upah_kepala_tukang": 0.01, "upah_mandor": 0.005}
    },
    "pekerjaan_plesteran_dinding_m2": {
        "default": { "semen_pc_50kg": 0.154, "pasir_pasang": 0.023, "upah_pekerja": 0.3, "upah_tukang_batu": 0.15, "upah_kepala_tukang": 0.015, "upah_mandor": 0.015 }
    },
    "pekerjaan_acian_dinding_m2": {
        "default": { "semen_pc_50kg": 0.065, "upah_pekerja": 0.1, "upah_tukang_batu": 0.075, "upah_kepala_tukang": 0.008, "upah_mandor": 0.005 }
    },
    "pekerjaan_pengecatan_tembok_m2": {
        "Cat Kualitas Sedang": { "plamir_tembok": 0.1, "cat_tembok_vinilex": 0.26, "upah_pekerja": 0.02, "upah_tukang_cat": 0.063, "upah_kepala_tukang": 0.006, "upah_mandor": 0.003 },
        "Cat Kualitas Baik": { "plamir_tembok": 0.1, "cat_tembok_dulux": 0.26, "upah_pekerja": 0.02, "upah_tukang_cat": 0.063, "upah_kepala_tukang": 0.006, "upah_mandor": 0.003 }
    },
    "pekerjaan_lantai_keramik_40x40_m2": {
        "default": {"keramik_lantai_40x40": 1.05, "semen_pc_50kg": 0.2, "pasir_pasang": 0.045, "semen_nat": 0.03, "upah_pekerja": 0.35, "upah_tukang_batu": 0.25, "upah_kepala_tukang": 0.025, "upah_mandor": 0.012}
    },
    "pekerjaan_dinding_keramik_20x25_m2": {
        "default": {"keramik_dinding_20x25": 1.05, "semen_pc_50kg": 0.2, "pasir_pasang": 0.045, "semen_nat": 0.03, "upah_pekerja": 0.45, "upah_tukang_batu": 0.3, "upah_kepala_tukang": 0.03, "upah_mandor": 0.02}
    },
    "pekerjaan_plafon_gypsum_m2": {
        "default": {"gypsum_board_9mm": 0.364, "rangka_hollow_galvanis": 4.5, "paku_biasa": 0.11, "upah_pekerja": 0.1, "upah_tukang_kayu": 0.5, "upah_kepala_tukang": 0.05, "upah_mandor": 0.005}
    },

    # --- PEKERJAAN ATAP ---
    "pekerjaan_rangka_atap_baja_ringan_m2": {
        "default": {"baja_ringan_c75": 1.05, "sekrup_baja_ringan": 0.5, "upah_pekerja": 0.2, "upah_tukang_besi": 0.2, "upah_kepala_tukang": 0.02, "upah_mandor": 0.01}
    },
    "pekerjaan_penutup_atap_genteng_beton_m2": {
        "default": {"genteng_beton_flat": 11.0, "nok_genteng_beton": 0.2, "paku_biasa": 0.15, "upah_pekerja": 0.15, "upah_tukang_batu": 0.075, "upah_mandor": 0.008}
    },
    "pekerjaan_rangka_atap_kayu_kamper_m3": {
        "default": {"balok_kayu_kamper": 1.1, "besi_c_channel": 15.0, "paku_ukuran_besar": 0.8, "meni_kayu": 0.4, "upah_pekerja": 4.0, "upah_tukang_kayu": 12.0, "upah_kepala_tukang": 1.2, "upah_mandor": 0.4}
    },
    "pekerjaan_kaso_reng_kayu_m2": {
        "default": {"balok_kayu_kelas_2": 0.012, "paku_7_10cm": 0.15, "upah_pekerja": 0.1, "upah_tukang_kayu": 0.1, "upah_kepala_tukang": 0.01, "upah_mandor": 0.005}
    },
    "pekerjaan_penutup_atap_genteng_plentong_m2": {
        "default": {"genteng_plentong": 25.0, "upah_pekerja": 0.15, "upah_tukang_kayu": 0.075, "upah_mandor": 0.008}
    },
    "pekerjaan_nok_genteng_keramik_m2": {
        "default": {"nok_genteng_keramik": 5.0, "semen_pc_50kg": 0.16, "pasir_pasang": 0.032, "upah_pekerja": 0.3, "upah_tukang_kayu": 0.2, "upah_kepala_tukang": 0.02, "upah_mandor": 0.01}
    },
    
    # --- PEKERJAAN LISTRIK ---
    "pekerjaan_titik_lampu_titik": {
        "default": {"kabel_nym_2x1.5": 12.0, "upah_pekerja": 0.2, "upah_tukang_listrik": 0.5, "upah_kepala_tukang": 0.05, "upah_mandor": 0.01}
    },
    "pekerjaan_stop_kontak_bh": { 
        "default": {"stop_kontak_panasonic": 1.0, "kabel_nym_2x1.5": 8.0, "upah_pekerja": 0.1, "upah_tukang_listrik": 0.3, "upah_kepala_tukang": 0.03, "upah_mandor": 0.005}
    },
    "pekerjaan_panel_listrik_unit": {
        "default": {"panel_listrik": 1.0, "upah_pekerja": 0.1, "upah_tukang_listrik": 1.0, "upah_kepala_tukang": 0.1, "upah_mandor": 0.05}
    },
    "pekerjaan_penyambungan_daya_listrik_ls": {
        "default": {"penyambungan_daya_listrik": 1.0, "upah_pekerja": 0.5, "upah_tukang_listrik": 1.0, "upah_kepala_tukang": 0.1, "upah_mandor": 0.05}
    },

    # --- PEKERJAAN SANITASI ---
    "pekerjaan_kloset_duduk_unit": {
        "default": {"kloset_duduk_toto": 1.0, "upah_pekerja": 3.3, "upah_tukang_batu": 1.1, "upah_kepala_tukang": 0.11, "upah_mandor": 0.055}
    },
    "pekerjaan_shower_unit": {
        "default": {"shower": 1.0, "upah_pekerja": 0.01, "upah_tukang_batu": 0.1, "upah_kepala_tukang": 0.01, "upah_mandor": 0.005}
    },
    "pekerjaan_bak_mandi_fiberglass_unit": {
        "default": {"bak_mandi_fiberglass": 1.0, "upah_pekerja": 1.8, "upah_tukang_batu": 2.7, "upah_kepala_tukang": 0.27, "upah_mandor": 0.135}
    },
    "pekerjaan_kitchen_sink_unit": {
        "default": {"kitchen_sink": 1.0, "wastafel": 1.0, "upah_pekerja": 0.03, "upah_tukang_batu": 0.3, "upah_kepala_tukang": 0.03, "upah_mandor": 0.015}
    },
    "pekerjaan_keran_air_unit": {
        "default": {"keran_air": 1.0, "upah_pekerja": 0.01, "upah_tukang_batu": 0.1, "upah_kepala_tukang": 0.01, "upah_mandor": 0.005}
    },
    "pekerjaan_keran_angsa_unit": {
        "default": {"keran_air_angsa": 1.0, "upah_pekerja": 0.01, "upah_tukang_batu": 0.1, "upah_kepala_tukang": 0.01, "upah_mandor": 0.005}
    },
    "pekerjaan_floor_drain_unit": {
        "default": {"floor_drain": 1.0, "upah_pekerja": 0.01, "upah_tukang_batu": 0.1, "upah_kepala_tukang": 0.01, "upah_mandor": 0.005}
    },
    "pekerjaan_soap_holder_unit": {
        "default": {"soap_holder": 1.0, "upah_pekerja": 0.01, "upah_tukang_batu": 0.1, "upah_kepala_tukang": 0.01, "upah_mandor": 0.005}
    },
    "pekerjaan_septic_tank_unit": {
        "default": {"bata_merah_bakar": 62.0, "semen_pc_50kg": 0.88, "pasir_pasang": 0.07, "batu_pecah_1-2": 0.07, "besi_beton_polos": 1.6, "pasir_beton": 0.06, "pipa_pvc_4_inch": 14.4, "injuk": 5.0, "sirtu_pasir_koral": 1.05, "upah_pekerja": 4.0, "upah_tukang_batu": 3.0, "upah_kepala_tukang": 0.3, "upah_mandor": 0.15}
    },

    # --- PEKERJAAN PEMIPAIAN ---
    "pekerjaan_pipa_pvc_1_2_inchi_m": {
        "default": {"pipa_pvc_aw_1_2in": 1.1, "upah_pekerja": 0.036, "upah_tukang_ledeng": 0.06, "upah_kepala_tukang": 0.006, "upah_mandor": 0.003}
    },
    "pekerjaan_pipa_pvc_2_inchi_m": {
        "default": {"pipa_pvc_aw_2in": 1.1, "upah_pekerja": 0.054, "upah_tukang_ledeng": 0.09, "upah_kepala_tukang": 0.009, "upah_mandor": 0.005}
    },
    "pekerjaan_pipa_pvc_4_inchi_m": {
        "default": {"pipa_pvc_4_inch": 1.1, "upah_pekerja": 0.081, "upah_tukang_ledeng": 0.135, "upah_kepala_tukang": 0.014, "upah_mandor": 0.007}
    },
    "pekerjaan_pompa_air_unit": {
        "default": {"pompa_air": 1.0, "upah_pekerja": 0.08, "upah_tukang_ledeng": 0.14, "upah_kepala_tukang": 0.014, "upah_mandor": 0.007}
    },
    "pekerjaan_penyambungan_pipa_pdam_ls": {
        "default": {"penyambungan_pipa_pdam": 1.0, "upah_pekerja": 0.5, "upah_tukang_ledeng": 1.0, "upah_kepala_tukang": 0.1, "upah_mandor": 0.05}
    },

    # --- PEKERJAAN ALUMINIUM & KACA ---
    "pekerjaan_kusen_aluminium_unit": {
        "default": {"aluminium_kusen_pintu_jendela_4in": 9.24, "aluminium_daun_pintu_jendela": 11.04, "kaca_3mm": 2.4, "engsel_jendela": 4.0, "selot_gerendel_jendela_3in": 2.0, "kait_angin_jendela": 2.0, "upah_pekerja": 1.95, "upah_tukang_besi": 1.4, "upah_kepala_tukang": 0.14, "upah_mandor": 0.07}
    },
    "pekerjaan_pintu_aluminium_unit": {
        "default": {"aluminium_kusen_pintu_jendela_4in": 7.56, "kaca_3mm": 0.45, "papan_kayu_kamper_medan": 0.033, "paku_1_5cm": 0.504, "lem_kayu": 0.504, "teakwood_4mm": 1.68, "engsel_pintu": 3.0, "selot_gerendel_pintu_4in": 1.0, "kunci_pintu_2slaag_standar": 1.0, "upah_pekerja": 1.01, "upah_tukang_kayu": 3.36, "upah_tukang_besi": 1.15, "upah_kepala_tukang": 0.34, "upah_mandor": 0.17}
    },
    "pekerjaan_kaca_5mm_m2": {
        "default": {"kaca_5mm": 1.1, "upah_pekerja": 0.015, "upah_tukang_kayu": 0.15, "upah_kepala_tukang": 0.015, "upah_mandor": 0.008}
    },

    # --- PEKERJAAN PENGAMAN & AKSESORI ---
    "pekerjaan_kunci_pintu_besar_unit": {
        "default": {"kunci_pintu_2slaag_besar": 1.0, "upah_pekerja": 0.06, "upah_tukang_kayu": 0.6, "upah_kepala_tukang": 0.06, "upah_mandor": 0.03}
    },
    "pekerjaan_kunci_pintu_standar_unit": {
        "default": {"kunci_pintu_2slaag_standar": 1.0, "upah_pekerja": 0.06, "upah_tukang_kayu": 0.5, "upah_kepala_tukang": 0.05, "upah_mandor": 0.025}
    },
    "pekerjaan_engsel_pintu_unit": {
        "default": {"engsel_pintu": 1.0, "upah_pekerja": 0.016, "upah_tukang_kayu": 0.15, "upah_kepala_tukang": 0.015, "upah_mandor": 0.008}
    },
    "pekerjaan_engsel_jendela_unit": {
        "default": {"engsel_jendela": 1.0, "upah_pekerja": 0.01, "upah_tukang_kayu": 0.1, "upah_kepala_tukang": 0.01, "upah_mandor": 0.005}
    },
    "pekerjaan_door_holder_unit": {
        "default": {"door_holder": 1.0, "upah_pekerja": 0.05, "upah_tukang_kayu": 0.5, "upah_kepala_tukang": 0.05, "upah_mandor": 0.025}
    },
    "pekerjaan_kait_angin_unit": {
        "default": {"kait_angin_jendela": 1.0, "upah_pekerja": 0.015, "upah_tukang_kayu": 0.15, "upah_kepala_tukang": 0.015, "upah_mandor": 0.008}
    },
    "pekerjaan_gerendel_pintu_unit": {
        "default": {"selot_gerendel_pintu_4in": 1.0, "upah_pekerja": 0.05, "upah_tukang_kayu": 0.5, "upah_kepala_tukang": 0.05, "upah_mandor": 0.025}
    },
    "pekerjaan_gerendel_jendela_unit": {
        "default": {"selot_gerendel_jendela_3in": 1.0, "upah_pekerja": 0.05, "upah_tukang_kayu": 0.5, "upah_kepala_tukang": 0.05, "upah_mandor": 0.025}
    },

    # --- PEKERJAAN PENGECATAN ---
    "pekerjaan_pengecatan_tembok_plafon_m2": {
        "Cat Kualitas Baik": {"plamir_tembok": 0.1, "cat_tembok_dulux": 0.26, "scafolding_set": 0.01, "ampelas": 0.5, "roll_cat": 0.01, "upah_pekerja": 0.06, "upah_tukang_cat": 0.02, "upah_kepala_tukang": 0.002, "upah_mandor": 0.001}
    },
    "pekerjaan_pengecatan_besi_m2": {
        "default": {"meni_kayu": 0.1, "cat_besi": 0.13, "kuas_3inchi": 0.01, "ampelas": 0.5, "upah_pekerja": 0.2, "upah_tukang_cat": 0.2, "upah_kepala_tukang": 0.02, "upah_mandor": 0.01}
    },

    # --- PEKERJAAN PELENGKAP ---
    "pekerjaan_paving_block_m2": {
        "default": {"pasir_urug": 0.1, "conblok_4_21x105x8cm_abu": 1.05, "upah_pekerja": 0.4, "upah_tukang_batu": 0.2, "upah_kepala_tukang": 0.02, "upah_mandor": 0.01}
    },
    "pekerjaan_atap_parkiran_upvc_m2": {
        "default": {"besi_profil": 29.6, "atap_upvc": 1.05, "meni_kayu": 0.17, "kawat_las": 2.96, "cat_besi": 0.17, "kuas_3inchi": 0.01, "ampelas": 0.64, "upah_pekerja": 0.8, "upah_tukang_besi": 0.4, "upah_tukang_cat": 0.27, "upah_kepala_tukang": 0.07, "upah_mandor": 0.04}
    }
}