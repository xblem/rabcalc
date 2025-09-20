# rabcalc_backend/database.py

# Kamus ini menyimpan harga default (berdasarkan data referensi dan rerata nasional)
HARGA_DEFAULT = {
    # Upah
    "upah_pekerja": 120000.0,
    "upah_tukang_batu": 150000.0,
    "upah_tukang_kayu": 155000.0,
    "upah_tukang_besi": 155000.0,
    "upah_tukang_cat": 150000.0,
    "upah_kepala_tukang": 170000.0,
    "upah_mandor": 180000.0,

    # Material Pokok & Struktur
    "semen_pc_50kg": 75000.0,
    "pasir_pasang": 250000.0,       # per m3
    "pasir_beton": 280000.0,        # per m3
    "pasir_urug": 220000.0,         # per m3
    "batu_pecah_1-2": 320000.0,     # per m3 (Kerikil)
    "batu_belah_10-15": 280000.0,   # per m3 (Pondasi)
    "bata_merah_bakar": 800.0,      # per bh
    "bata_ringan_hebel": 650000.0,  # per m3
    "semen_instan_perekat": 95000.0, # per sak 40kg
    "besi_beton_polos": 15000.0,     # per kg
    "kawat_beton": 25000.0,         # per kg
    
    # Material Bekisting & Persiapan
    "papan_kayu_kelas_3": 2500000.0, # per m3
    "balok_kayu_kelas_2": 4000000.0, # per m3
    "paku_biasa": 22000.0,           # per kg
    "minyak_bekisting": 15000.0,     # per liter
    "plywood_9mm": 130000.0,         # per lembar

    # Material Atap
    "baja_ringan_c75": 180000.0,      # per m2 (terpasang)
    "genteng_beton_flat": 3500.0,    # per bh
    "nok_genteng_beton": 15000.0,    # per bh
    "sekrup_baja_ringan": 500.0,      # per bh

    # Material Finishing & Interior
    "cat_tembok_vinilex": 30000.0,    # per kg
    "cat_tembok_dulux": 65000.0,      # per kg
    "plamir_tembok": 15000.0,         # per kg
    "keramik_lantai_40x40": 70000.0,  # per m2
    "keramik_dinding_20x25": 75000.0, # per m2
    "semen_nat": 25000.0,             # per kg
    "gypsum_board_9mm": 65000.0,      # per lembar
    "rangka_hollow_galvanis": 18000.0, # per m
    "kusen_pintu_kayu_kamper": 4500000.0, # per m3
    "pintu_panel_kayu": 450000.0,       # per m2
    
    # Material Sanitasi & Elektrikal
    "kloset_duduk_toto": 2200000.0, # per bh
    "pipa_pvc_4_inch": 35000.0,       # per m
    "stop_kontak_panasonic": 30000.0, # per bh
    "lampu_led_philips": 40000.0,       # per bh
    "kabel_nym_2x1.5": 8000.0,        # per m
}

# Kamus ini adalah "Buku Resep" AHSP kita, sudah disempurnakan.
KOEFISIEN_AHSP = {
    # --- PEKERJAAN PERSIAPAN ---
    "pekerjaan_pengukuran_dan_bouwplank_m": {
        "default": {"balok_kayu_kelas_2": 0.012, "paku_biasa": 0.02, "papan_kayu_kelas_3": 0.007, "upah_pekerja": 0.1, "upah_tukang_kayu": 0.1, "upah_kepala_tukang": 0.01, "upah_mandor": 0.005}
    },
    "pekerjaan_pembersihan_lokasi_m2": {
        "default": {"upah_pekerja": 0.05, "upah_mandor": 0.005}
    },

    # --- PEKERJAAN TANAH & PONDASI ---
    "pekerjaan_galian_tanah_pondasi_m3": {
        "default": { "upah_pekerja": 0.75, "upah_mandor": 0.025 }
    },
    "pekerjaan_urugan_pasir_bawah_pondasi_m3": {
        "default": { "pasir_urug": 1.2, "upah_pekerja": 0.3, "upah_mandor": 0.01 }
    },
    "pekerjaan_pondasi_batu_belah_m3": {
        "default": {"batu_belah_10-15": 1.2, "semen_pc_50kg": 2.72, "pasir_pasang": 0.544, "upah_pekerja": 1.5, "upah_tukang_batu": 0.75, "upah_kepala_tukang": 0.075, "upah_mandor": 0.075}
    },

    # --- PEKERJAAN BETON BERTULANG ---
    "pekerjaan_beton_sloof_20x30_m3": {
        "default": {"semen_pc_50kg": 8.4, "pasir_beton": 0.52, "batu_pecah_1-2": 0.78, "besi_beton_polos": 180.0, "kawat_beton": 2.7, "papan_kayu_kelas_3": 0.27, "paku_biasa": 2.0, "minyak_bekisting": 0.6, "upah_pekerja": 5.2, "upah_tukang_batu": 1.5, "upah_tukang_besi": 1.2, "upah_tukang_kayu": 1.25, "upah_kepala_tukang": 0.2, "upah_mandor": 0.26}
    },
    "pekerjaan_beton_kolom_25x25_m3": {
        "default": {"semen_pc_50kg": 8.4, "pasir_beton": 0.52, "batu_pecah_1-2": 0.78, "besi_beton_polos": 150.0, "kawat_beton": 2.25, "papan_kayu_kelas_3": 0.27, "paku_biasa": 2.0, "minyak_bekisting": 0.6, "upah_pekerja": 5.2, "upah_tukang_batu": 1.5, "upah_tukang_besi": 1.2, "upah_tukang_kayu": 1.25, "upah_kepala_tukang": 0.2, "upah_mandor": 0.26}
    },
    "pekerjaan_beton_ring_balok_15x20_m3": {
        "default": {"semen_pc_50kg": 8.4, "pasir_beton": 0.52, "batu_pecah_1-2": 0.78, "besi_beton_polos": 175.0, "kawat_beton": 2.6, "papan_kayu_kelas_3": 0.27, "paku_biasa": 2.0, "minyak_bekisting": 0.6, "upah_pekerja": 5.2, "upah_tukang_batu": 1.5, "upah_tukang_besi": 1.2, "upah_tukang_kayu": 1.25, "upah_kepala_tukang": 0.2, "upah_mandor": 0.26}
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
        "default": {"baja_ringan_c75": 1.05, "upah_pekerja": 0.2, "upah_tukang_besi": 0.2, "upah_kepala_tukang": 0.02, "upah_mandor": 0.01}
    },
    "pekerjaan_penutup_atap_genteng_beton_m2": {
        "default": {"genteng_beton_flat": 11.0, "nok_genteng_beton": 0.2, "paku_biasa": 0.15, "upah_pekerja": 0.15, "upah_tukang_batu": 0.075, "upah_mandor": 0.008}
    },
    
    # --- PEKERJAAN LISTRIK ---
    "pekerjaan_titik_lampu_titik": {
        "default": {"kabel_nym_2x1.5": 12.0, "upah_pekerja": 0.2, "upah_tukang_besi": 0.5, "upah_kepala_tukang": 0.05, "upah_mandor": 0.01}
    },
}