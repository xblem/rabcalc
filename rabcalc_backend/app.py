# rabcalc_backend/app.py

from flask import Flask, request, jsonify
from flask_cors import CORS
import logging
from database import HARGA_DEFAULT, KOEFISIEN_AHSP
from boq_calculator import calculate_boq
import re
import math
from collections import defaultdict

app = Flask(__name__)
CORS(app)
logging.basicConfig(level=logging.DEBUG)
logging.basicConfig(level=logging.INFO, format='%(levelname)s:%(name)s:%(message)s')

# --- FUNGSI HELPER (DI-UPGRADE DARI KODE BARU) ---

def format_rupiah(amount):
    if amount is None or (isinstance(amount, float) and math.isnan(amount)):
        amount = 0
    return f"Rp {amount:,.2f}".replace(",", "X").replace(".", ",").replace("X", ".")

def clean_job_name(job_key):
    name = re.sub(r'_(m|m2|m3|titik|bh|unit|ls)$', '', job_key)
    name = name.replace('_', ' ').title()
    return name

def get_job_unit(job_key):
    match = re.search(r'_(m|m2|m3|titik|bh|unit|ls)$', job_key)
    if match:
        unit = match.group(1)
        if unit == 'm': return 'm¹'
        if unit == 'm2': return 'm²'
        if unit == 'm3': return 'm³'
        return unit
    return 'unit'

def get_material_unit(material_key): # <-- Di-upgrade
    if '50kg' in material_key: return 'sak'
    if any(s in material_key for s in ['pasir', 'batu', 'kayu', 'sirtu']): return 'm³'
    if any(s in material_key for s in ['bata', 'genteng', 'keramik', 'plint', 'conblok', 'hollow', 'dolken', 'lampu', 'panel', 'kloset', 'shower', 'bak', 'wastafel', 'keran', 'drain', 'holder', 'pompa', 'pintu', 'kunci', 'selot', 'engsel', 'holder', 'kait']): return 'bh'
    if any(s in material_key for s in ['kawat', 'besi', 'paku', 'compound']): return 'kg'
    if 'pipa' in material_key or 'aluminium' in material_key: return 'm'
    if any(s in material_key for s in ['seng', 'teakwood', 'plywood', 'gypsum', 'ampelas']): return 'lbr'
    if 'cat' in material_key or 'lem' in material_key or 'meni' in material_key or 'plamir' in material_key: return 'kg'
    if 'minyak' in material_key: return 'ltr'
    if 'roll' in material_key or 'scafolding' in material_key: return 'set'
    if 'kabel' in material_key: return 'roll'
    if any(s in material_key for s in ['pdam', 'listrik']): return 'ls'
    return 'unit'

def categorize_job(job_key): # <-- Di-upgrade
    if any(s in job_key for s in ['persiapan', 'bouwplank', 'gudang', 'pembersihan']): return "A. Pekerjaan Persiapan"
    if any(s in job_key for s in ['galian', 'urugan', 'tanah', 'pondasi']): return "B. Pekerjaan Tanah & Pondasi"
    if any(s in job_key for s in ['beton', 'sloof', 'kolom', 'balok', 'plat', 'tangga']): return "C. Pekerjaan Beton Bertulang"
    if 'dinding' in job_key and 'keramik' not in job_key: return "D. Pekerjaan Dinding"
    if any(s in job_key for s in ['plesteran', 'acian']): return "E. Pekerjaan Plesteran & Acian"
    if 'atap' in job_key or any(s in job_key for s in ['kaso', 'genteng', 'nok']): return "F. Pekerjaan Atap"
    if 'plafon' in job_key: return "G. Pekerjaan Plafon"
    if any(s in job_key for s in ['kusen', 'pintu', 'jendela', 'kaca']): return "H. Pekerjaan Kusen, Pintu & Kaca"
    if 'lantai' in job_key or ('keramik' in job_key and 'dinding' not in job_key): return "I. Pekerjaan Lantai"
    if 'dinding_keramik' in job_key: return "J. Pekerjaan Pelapis Dinding"
    if any(s in job_key for s in ['sanitasi', 'kloset', 'shower', 'bak', 'sink', 'keran', 'drain', 'septic', 'pipa', 'pompa', 'pdam']): return "K. Pekerjaan Sanitasi & Pemipaan"
    if 'pengecatan' in job_key: return "L. Pekerjaan Pengecatan"
    if any(s in job_key for s in ['listrik', 'lampu', 'stop_kontak', 'panel']): return "M. Pekerjaan Listrik"
    if any(s in job_key for s in ['kunci', 'engsel', 'gerendel', 'kait', 'holder']): return "N. Pekerjaan Kunci & Aksesori"
    return "O. Pekerjaan Pelengkap"

# --- FUNGSI BARU UNTUK PENJADWALAN ---
def generate_project_schedule(kebutuhan_sumber_daya, duration_weeks=13):
    project_phases = {
        "A. Pekerjaan Persiapan": (1, 2), "B. Pekerjaan Tanah & Pondasi": (1, 3),
        "C. Pekerjaan Beton Bertulang": (3, 8), "D. Pekerjaan Dinding": (5, 9),
        "E. Pekerjaan Plesteran & Acian": (7, 11), "F. Pekerjaan Atap": (8, 11),
        "G. Pekerjaan Plafon": (9, 12), "H. Pekerjaan Kusen, Pintu & Kaca": (10, 13),
        "I. Pekerjaan Lantai": (10, 13), "J. Pekerjaan Pelapis Dinding": (11, 13),
        "K. Pekerjaan Sanitasi & Pemipaan": (10, 13), "L. Pekerjaan Pengecatan": (11, 13),
        "M. Pekerjaan Listrik": (11, 13), "N. Pekerjaan Kunci & Aksesori": (12, 13),
        "O. Pekerjaan Pelengkap": (12, 13),
    }

    all_workers = sorted(list(set(detail['uraian'] for item in kebutuhan_sumber_daya for detail in item['detail'] if 'Upah' in detail['uraian'])))
    jadwal_tenaga = {worker: [0.0] * duration_weeks for worker in all_workers}
    cash_flow = {'bahan': [0.0] * duration_weeks, 'upah': [0.0] * duration_weeks}

    for item in kebutuhan_sumber_daya:
        category_key_base = item['uraian_pekerjaan'].lower().replace(' ', '_')
        category = next((cat for cat_key, cat in project_phases.items() if any(sub in category_key_base for sub in cat_key.split(" ")[1].lower().split(" & "))), "O. Pekerjaan Pelengkap")
        start_week, end_week = project_phases.get(category, (1, duration_weeks))
        num_weeks = end_week - start_week + 1

        for detail in item['detail']:
            if 'Upah' in detail['uraian']:
                total_hok = float(detail['volume'])
                hok_per_week = total_hok / num_weeks
                for week in range(start_week - 1, end_week):
                    jadwal_tenaga[detail['uraian']][week] += hok_per_week
            else:
                total_cost = float(detail['jumlah_harga_rp'].replace('Rp ', '').replace('.', '').replace(',', '.'))
                cost_per_week = total_cost / num_weeks
                for week in range(start_week - 1, end_week):
                    cash_flow['bahan'][week] += cost_per_week

    for worker, weekly_hok in jadwal_tenaga.items():
        worker_key = "upah_" + worker.replace('Upah ', '').replace(' ', '_').lower()
        upah_harian = HARGA_DEFAULT.get(worker_key, HARGA_DEFAULT.get("upah_pekerja"))
        weekly_cost = [h * upah_harian for h in weekly_hok]
        cash_flow['upah'] = [a + b for a, b in zip(cash_flow['upah'], weekly_cost)]

    jadwal_output = [
        {'tenaga': worker.replace('Upah ', ''), 'mingguan': [f"{val/6:.2f}" for val in values]}
        for worker, values in jadwal_tenaga.items()
    ]

    cash_flow_output, komulatif_total = [], 0
    for i in range(duration_weeks):
        mingguan_total = cash_flow['bahan'][i] + cash_flow['upah'][i]
        komulatif_total += mingguan_total
        cash_flow_output.append({ "minggu": f"Minggu {i+1}", "pengeluaran_mingguan": format_rupiah(mingguan_total), "komulatif_total": format_rupiah(komulatif_total) })

    return jadwal_output, cash_flow_output

# --- FUNGSI BARU UNTUK JADWAL PEKERJAAN DAN BAHAN ---
def generate_jadwal_pekerjaan(detailed_boq, duration_weeks=13):
    # Mapping pekerjaan ke minggu berdasarkan kategori
    project_phases = {
        "A. Pekerjaan Persiapan": (1, 2), "B. Pekerjaan Tanah & Pondasi": (1, 3),
        "C. Pekerjaan Beton Bertulang": (3, 8), "D. Pekerjaan Dinding": (5, 9),
        "E. Pekerjaan Plesteran & Acian": (7, 11), "F. Pekerjaan Atap": (8, 11),
        "G. Pekerjaan Plafon": (9, 12), "H. Pekerjaan Kusen, Pintu & Kaca": (10, 13),
        "I. Pekerjaan Lantai": (10, 13), "J. Pekerjaan Pelapis Dinding": (11, 13),
        "K. Pekerjaan Sanitasi & Pemipaan": (10, 13), "L. Pekerjaan Pengecatan": (11, 13),
        "M. Pekerjaan Listrik": (11, 13), "N. Pekerjaan Kunci & Aksesori": (12, 13),
        "O. Pekerjaan Pelengkap": (12, 13),
    }
    
    jadwal_pekerjaan = []
    total_biaya_proyek = sum(item['jumlah_harga_raw'] for item in detailed_boq)
    
    for item in detailed_boq:
        category = item['kategori']
        start_week, end_week = project_phases.get(category, (1, duration_weeks))
        num_weeks = end_week - start_week + 1
        
        # Hitung bobot pekerjaan
        bobot = (item['jumlah_harga_raw'] / total_biaya_proyek) * 100 if total_biaya_proyek > 0 else 0
        
        # Distribusikan volume per minggu
        volume_per_minggu = item['volume'] / num_weeks
        distribusi_mingguan = [0.0] * duration_weeks
        
        for week in range(start_week - 1, end_week):
            distribusi_mingguan[week] = volume_per_minggu
        
        jadwal_pekerjaan.append({
            "no": "",  # Nomor akan diisi nanti
            "uraian_pekerjaan": item['uraian'],
            "volume": f"{item['volume']:.2f}",
            "sat": item['satuan'],
            "bobot": f"{bobot:.2f}%",
            "distribusi_mingguan": [f"{vol:.2f}" for vol in distribusi_mingguan]
        })
    
    return jadwal_pekerjaan

def generate_jadwal_bahan(total_kebutuhan_material, duration_weeks=13):
    jadwal_bahan = []
    
    for material_key, total_volume in total_kebutuhan_material.items():
        material_name = material_key.replace('_', ' ').title()
        unit = get_material_unit(material_key)
        
        # Distribusikan kebutuhan bahan per minggu (contoh sederhana)
        # Dalam implementasi nyata, distribusi ini harus berdasarkan jadwal pekerjaan
        distribusi_mingguan = [0.0] * duration_weeks
        avg_per_week = total_volume / duration_weeks
        
        for week in range(duration_weeks):
            distribusi_mingguan[week] = avg_per_week
        
        jadwal_bahan.append({
            "no": "",  # Nomor akan diisi nanti
            "uraian_bahan": material_name,
            "volume": f"{total_volume:.2f}",
            "satuan": unit,
            "distribusi_mingguan": [f"{vol:.2f}" for vol in distribusi_mingguan]
        })
    
    return jadwal_bahan

# --- FUNGSI KALKULASI UTAMA (DI-UPGRADE TOTAL) ---
def calculate_rab_details(boq_volumes, material_selections, custom_prices):
    harga_satuan = {**HARGA_DEFAULT, **custom_prices}
    detailed_boq, rekapitulasi = [], defaultdict(float)
    kebutuhan_sumber_daya_per_kegiatan, total_kebutuhan_material = [], defaultdict(float)
    total_biaya_tenaga, total_biaya_bahan = defaultdict(float), 0

    for job_key, data in boq_volumes.items():
        volume = data.get('volume', 0)
        if volume == 0: continue

        job_name, job_unit, category = clean_job_name(job_key), get_job_unit(job_key), categorize_job(job_key)
        ahsp_options = KOEFISIEN_AHSP.get(job_key, {})
        selected_option_key = material_selections.get(job_key, 'default')
        ahsp_recipe = ahsp_options.get(selected_option_key, ahsp_options.get('default', {}))
        if not ahsp_recipe: continue

        unit_price, detail_sumber_daya = 0, []
        for component, coefficient in ahsp_recipe.items():
            price = harga_satuan.get(component, 0)
            unit_price += coefficient * price
            total_kebutuhan, jumlah_harga_komponen = coefficient * volume, (coefficient * volume) * price
            
            detail_sumber_daya.append({"uraian": component.replace('_', ' ').title(), "volume": f"{total_kebutuhan:.2f}", "satuan": "HOK" if "upah" in component else get_material_unit(component), "harga_satuan_rp": format_rupiah(price), "jumlah_harga_rp": format_rupiah(jumlah_harga_komponen)})
            
            if 'upah' in component:
                total_biaya_tenaga[component] += jumlah_harga_komponen
            else:
                total_biaya_bahan += jumlah_harga_komponen
                total_kebutuhan_material[component] += total_kebutuhan

        total_price = volume * unit_price
        detailed_boq.append({"uraian": job_name, "volume": volume, "satuan": job_unit, "harga_satuan_rp": format_rupiah(unit_price), "jumlah_harga_rp": format_rupiah(total_price), "jumlah_harga_raw": total_price, "spek": data.get('spek', ''), "kategori": category})
        kebutuhan_sumber_daya_per_kegiatan.append({"uraian_pekerjaan": job_name, "volume": f"{volume:.2f}", "satuan": job_unit, "total_harga_rp": format_rupiah(total_price), "detail": detail_sumber_daya})
        rekapitulasi[category] += total_price

    total_upah = sum(total_biaya_tenaga.values())
    total_biaya_alat_bantu = (total_biaya_bahan + total_upah) * 0.02
    grand_total_proyek = total_biaya_bahan + total_upah + total_biaya_alat_bantu

    jadwal_tenaga_kerja, tabel_cash_flow = generate_project_schedule(kebutuhan_sumber_daya_per_kegiatan)
    
    # Generate jadwal pekerjaan dan bahan
    jadwal_pekerjaan = generate_jadwal_pekerjaan(detailed_boq)
    jadwal_bahan = generate_jadwal_bahan(total_kebutuhan_material)
    
    return {
        "bill_of_quantity": detailed_boq,
        "rekapitulasi": {cat: {"jumlah_rp": format_rupiah(total), "jumlah_raw": total} for cat, total in rekapitulasi.items()},
        "grand_total_rp": format_rupiah(grand_total_proyek),
        "kebutuhan_sumber_daya": kebutuhan_sumber_daya_per_kegiatan,
        "tabel_kebutuhan_bahan": [{"nama": key.replace('_', ' ').title(), "volume": f"{vol:.2f}", "satuan": get_material_unit(key)} for key, vol in total_kebutuhan_material.items()],
        "tabel_kebutuhan_biaya_tenaga": [{"uraian": key.replace('upah_', ' ').title(), "volume": f"{val / HARGA_DEFAULT.get(key, 1):,.2f}", "satuan": "hari", "biaya_rp": format_rupiah(val)} for key, val in total_biaya_tenaga.items()],
        "tabel_kebutuhan_biaya": [
            {"uraian": "TOTAL BIAYA KEBUTUHAN BAHAN", "biaya_rp": format_rupiah(total_biaya_bahan)},
            {"uraian": "TOTAL BIAYA KEBUTUHAN TENAGA", "biaya_rp": format_rupiah(total_upah)},
            {"uraian": "TOTAL BIAYA ALAT BANTU (2%)", "biaya_rp": format_rupiah(total_biaya_alat_bantu)},
            {"uraian": "TOTAL BIAYA KEBUTUHAN", "biaya_rp": format_rupiah(grand_total_proyek)},
        ],
        "jadwal_tenaga_kerja": jadwal_tenaga_kerja,
        "tabel_cash_flow": tabel_cash_flow,
        "jadwal_pekerjaan": jadwal_pekerjaan,
        "jadwal_kebutuhan_bahan": jadwal_bahan
    }

# --- FLASK ROUTE (STRUKTUR LAMA DIPERTAHANKAN) ---
@app.route('/hitung-rab', methods=['POST'])
def hitung_rab_route():
    try:
        data = request.get_json()
        if not data:
            return jsonify({"error": "Invalid JSON"}), 400

        app.logger.info("===== DEBUG PYTHON: DATA DITERIMA =====")
        app.logger.info(data)

        project_info = data.get('project_info', {})
        static_room_details = data.get('static_room_details', {})
        room_details = data.get('room_details', {})
        material_selections = data.get('material_selections', {})
        custom_prices = data.get('custom_prices', {})

        boq_volumes = calculate_boq(project_info, static_room_details, room_details)
        hasil_akhir_rab = calculate_rab_details(boq_volumes, material_selections, custom_prices)

        # Siapkan Tabel DATA ORGANISASI RUANG
        data_organisasi_ruang = { "info_proyek": { "Nama": project_info.get('project_name', 'N/A'), "Pekerjaan": "Pembangunan Rumah", "Provinsi": project_info.get('location', 'N/A').split(',')[0].strip(), "Kabupaten/Kota": project_info.get('location', 'N/A').split(',')[-1].strip(), "Luas Tanah": f"{project_info.get('landLength', 0) * project_info.get('landWidth', 0)} m²", "Waktu Pelaksanaan": "13 Minggu", "Jumlah Lantai": project_info.get('floor_count', 1) }, "detail_ruang": [] }
        total_luas_bangunan = 0
        all_room_details = {**static_room_details, **room_details}
        
        for key, value in all_room_details.items():
            rooms = value if isinstance(value, list) else [value]
            for i, room in enumerate(rooms):
                panjang, lebar = room.get('panjang', 0), room.get('lebar', 0)
                luas = panjang * lebar
                total_luas_bangunan += luas
                data_organisasi_ruang["detail_ruang"].append({ "nama": f"{clean_job_name(key)} {i+1}" if isinstance(value, list) else clean_job_name(key), "panjang": panjang, "lebar": lebar, "luas": luas, "jendela": room.get('jumlah_jendela', 0), "keterangan": "" })
        
        data_organisasi_ruang["info_proyek"]["Luas Bangunan"] = f"{total_luas_bangunan:.2f} m²"

        # Siapkan Tabel RENCANA SPESIFIKASI
        rencana_spesifikasi = [{"pekerjaan": clean_job_name(key), "spesifikasi": value} for key, value in material_selections.items() if value]

        return jsonify({
            "status": "sukses",
            "hasil_rab": hasil_akhir_rab,
            "data_organisasi_ruang": data_organisasi_ruang,
            "rencana_spesifikasi": rencana_spesifikasi
        })

    except Exception as e:
        app.logger.error(f"Terjadi error saat kalkulasi: {e}", exc_info=True)
        return jsonify({"error": "Terjadi kesalahan di server saat menghitung."}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
    