# rabcalc_backend/database.py

# Kamus ini menyimpan harga default (berdasarkan data Medan atau nasional)
HARGA_DEFAULT = {
    # Upah
    "upah_pekerja_per_hari": 120000.0,
    "upah_tukang_per_hari": 150000.0,
    "upah_kepala_tukang_per_hari": 160000.0,
    "upah_mandor_per_hari": 165000.0,
    
    # Material Utama
    "semen_pc_50kg_per_sak": 75000.0,
    "pasir_pasang_per_m3": 250000.0,
    "pasir_beton_per_m3": 280000.0,
    "pasir_urug_per_m3": 220000.0,
    "batu_pecah_per_m3": 300000.0, # Split/Kerikil
    "batu_belah_per_m3": 280000.0, # Pondasi
    "bata_merah_per_bh": 800.0,
    "hebel_per_m3": 650000.0, # BARU
    "semen_instan_hebel_per_sak": 90000.0, # BARU
    "besi_beton_per_kg": 15000.0,
    "kawat_beton_per_kg": 25000.0,
    "papan_bekisting_per_m2": 60000.0,
    "paku_per_kg": 20000.0,
    "minyak_bekisting_per_liter": 15000.0,

    # Material Atap (BARU)
    "baja_ringan_truss_per_m2": 150000.0,
    "genteng_beton_per_bh": 3000.0,

    # Material Finishing
    "cat_tembok_kualitas_sedang_per_kg": 40000.0, # DIPERBARUI
    "cat_tembok_kualitas_baik_per_kg": 65000.0, # BARU
    "keramik_40x40_per_m2": 65000.0,
    "Keramik 20x20_per_m2": 67500.0,
    "semen_nat_per_kg": 25000.0, # BARU
    "gypsum_board_per_lembar": 60000.0, # BARU
    "rangka_hollow_per_m": 15000.0, # BARU
}

# Kamus ini adalah "Buku Resep" AHSP kita.
KOEFISIEN_AHSP = {
    # --- PEKERJAAN PERSIAPAN & TANAH ---
    "pekerjaan_galian_tanah_biasa_1m_m3": {
        "default": { "upah_pekerja_per_hari": 0.75, "upah_mandor_per_hari": 0.025 }
    },
    "pekerjaan_urugan_pasir_m3": {
        "default": { "pasir_urug_per_m3": 1.2, "upah_pekerja_per_hari": 0.3, "upah_mandor_per_hari": 0.01 }
    },
    
    # --- PEKERJAAN PONDASI ---
    "pekerjaan_pondasi_batu_belah_1pc_5ps_m3": {
        "default": {
            "batu_belah_per_m3": 1.2, "semen_pc_50kg_per_sak": 2.72, "pasir_pasang_per_m3": 0.544,
            "upah_pekerja_per_hari": 1.5, "upah_tukang_per_hari": 0.75, "upah_kepala_tukang_per_hari": 0.075, "upah_mandor_per_hari": 0.075,
        }
    },

    # --- PEKERJAAN BETON ---
    "pekerjaan_beton_k225_m3": {
        "default": {
            "semen_pc_50kg_per_sak": 7.52, "pasir_beton_per_m3": 0.48, "batu_pecah_per_m3": 0.77,
            "upah_pekerja_per_hari": 1.65, "upah_tukang_per_hari": 0.275, "upah_kepala_tukang_per_hari": 0.028, "upah_mandor_per_hari": 0.083,
        }
    },
    "pekerjaan_pembesian_kg": {
        "default": {
            "besi_beton_per_kg": 1.05, "kawat_beton_per_kg": 0.015,
            "upah_pekerja_per_hari": 0.007, "upah_tukang_per_hari": 0.007, "upah_kepala_tukang_per_hari": 0.0007, "upah_mandor_per_hari": 0.0004,
        }
    },
    "pekerjaan_bekisting_kolom_m2": {
        "default": {
            "papan_bekisting_per_m2": 1.1, "paku_per_kg": 0.4, "minyak_bekisting_per_liter": 0.2,
            "upah_pekerja_per_hari": 0.66, "upah_tukang_per_hari": 0.33, "upah_kepala_tukang_per_hari": 0.033, "upah_mandor_per_hari": 0.033,
        }
    },

    # --- PEKERJAAN DINDING & FINISHING ---
    "pekerjaan_dinding_m2": {
        "Batu Bata/Bata Merah": {
            "bata_merah_per_bh": 70.0, "semen_pc_50kg_per_sak": 0.23, "pasir_pasang_per_m3": 0.04,
            "upah_tukang_per_hari": 0.1, "upah_pekerja_per_hari": 0.3,
        },
        # RESEP DINDING BARU
        "Hebel/Bata Ringan": {
            "hebel_per_m3": 0.1, "semen_instan_hebel_per_sak": 0.25,
            "upah_tukang_per_hari": 0.1, "upah_pekerja_per_hari": 0.1,
        }
    },
    "pekerjaan_plesteran_m2": {
        "default": { "semen_pc_50kg_per_sak": 0.15, "pasir_pasang_per_m3": 0.02, "upah_tukang_per_hari": 0.15, "upah_pekerja_per_hari": 0.2 }
    },
    # RESEP PENGECATAN DIPERBARUI
    "pekerjaan_pengecatan_m2": {
        "Cat Kualitas Sedang": { "cat_tembok_kualitas_sedang_per_kg": 0.2, "upah_tukang_per_hari": 0.07, "upah_pekerja_per_hari": 0.02 },
        "Cat Kualitas Baik": { "cat_tembok_kualitas_baik_per_kg": 0.2, "upah_tukang_per_hari": 0.07, "upah_pekerja_per_hari": 0.02 }
    },
    # RESEP KERAMIK DIPERBARUI
    "pekerjaan_keramik_lantai_m2": {
        "default": {
            "keramik_40x40_per_m2": 1.05, "semen_pc_50kg_per_sak": 0.2, "pasir_pasang_per_m3": 0.045, "semen_nat_per_kg": 0.03,
            "upah_tukang_per_hari": 0.25, "upah_pekerja_per_hari": 0.35, "upah_kepala_tukang_per_hari": 0.025, "upah_mandor_per_hari": 0.012,
        }
    },
    # RESEP PLAFON BARU
    "pekerjaan_plafon_gypsum_m2": {
        "default": {
            "gypsum_board_per_lembar": 0.364,
            "rangka_hollow_per_m": 4.5,
            "paku_per_kg": 0.11,
            "upah_pekerja_per_hari": 0.1, "upah_tukang_per_hari": 0.5, "upah_kepala_tukang_per_hari": 0.05, "upah_mandor_per_hari": 0.005,
        }
    },
    
    # --- PEKERJAAN ATAP (BARU) ---
    "pekerjaan_rangka_atap_baja_ringan_m2": {
        "default": {
            "baja_ringan_truss_per_m2": 1.0,
        }
    },
    "pekerjaan_penutup_atap_genteng_beton_m2": {
        "default": {
            "genteng_beton_per_bh": 11.0,
            "paku_per_kg": 0.15,
            "upah_pekerja_per_hari": 0.15, "upah_tukang_per_hari": 0.075, "upah_mandor_per_hari": 0.008,
        }
    }
}