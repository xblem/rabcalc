from database import HARGA_DEFAULT, KOEFISIEN_AHSP

def calculate_total_cost(volumes, material_selections, custom_prices={}):
    """
    Menghitung total biaya RAB berdasarkan volume,
    koefisien AHSP, dan pilihan material.
    """
    rincian_biaya = {}
    grand_total = 0.0

    for nama_pekerjaan, volume in volumes.items():
        if nama_pekerjaan in KOEFISIEN_AHSP:
            
            resep_pekerjaan = KOEFISIEN_AHSP[nama_pekerjaan]
            
            # Mencocokkan nama pekerjaan dengan kunci di material_selections
            # Contoh: 'pekerjaan_dinding_m2' -> 'Bahan Dinding'
            kunci_pilihan = 'Bahan ' + nama_pekerjaan.replace('pekerjaan_', '').replace('_m2', '').replace('_m3', '').replace('_', ' ').capitalize().strip()
            
            # Sedikit penyesuaian untuk kecocokan nama
            if 'Dinding' in kunci_pilihan: kunci_pilihan = 'Bahan Dinding'
            if 'Pengecatan' in kunci_pilihan: kunci_pilihan = 'Bahan Cat Tembok'

            pilihan_material = material_selections.get(kunci_pilihan)
            
            resep = None
            if pilihan_material and pilihan_material in resep_pekerjaan:
                resep = resep_pekerjaan[pilihan_material]
            elif "default" in resep_pekerjaan:
                resep = resep_pekerjaan["default"]
            
            if not resep:
                continue # Lewati jika tidak ada resep yang cocok

            harga_satuan = 0.0
            for bahan, koefisien in resep.items():
                harga = custom_prices.get(bahan, HARGA_DEFAULT.get(bahan, 0))
                harga_satuan += koefisien * harga
            
            jumlah_harga = harga_satuan * volume
            grand_total += jumlah_harga
            
            rincian_biaya[nama_pekerjaan] = {
                "volume": volume,
                "harga_satuan_rp": round(harga_satuan, 2),
                "jumlah_harga_rp": round(jumlah_harga, 2)
            }

    return {
        "rincian_biaya": rincian_biaya,
        "total_biaya_konstruksi_rp": round(grand_total, 2)
    }