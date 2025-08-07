# rabcalc_backend/app.py

from flask import Flask, jsonify, request
from flask_cors import CORS
from boq_calculator import calculate_boq
from price_calculator import calculate_total_cost

app = Flask(__name__)
CORS(app)

@app.route('/')
def index():
    return jsonify({"message": "Selamat datang di RabCalc Backend!", "status": "ok"})

@app.route('/hitung-rab', methods=['POST'])
def hitung_rab_endpoint():
    user_data = request.get_json()
    
    print("===== DEBUG PYTHON: DATA DITERIMA =====")
    print(user_data)
    print("=======================================")
    
    
    if not user_data:
        return jsonify({"error": "Data tidak valid"}), 400

    # 1. Membongkar paket data lengkap dari Flutter
    project_info = user_data.get('project_info', {})
    
    # --- DEBUG VALUE & TYPE ---
    tinggi_plafon_l1 = project_info.get('ceiling_height_l1')
    print(f"Value 'ceiling_height_l1': {tinggi_plafon_l1}")
    print(f"Type 'ceiling_height_l1': {type(tinggi_plafon_l1)}")
    
    room_details = user_data.get('room_details', {})
    material_selections = user_data.get('material_selections', {})
    custom_prices = user_data.get('custom_prices', {})

    # 2. Hitung Volume (BoQ) dengan data yang sudah dibongkar
    hasil_volume = calculate_boq(project_info, room_details)
    
    # 3. Hitung Harga Total (RAB)
    hasil_akhir_rab = calculate_total_cost(hasil_volume, material_selections, custom_prices)
    
    # 4. Mengirim kembali hasil lengkap ke Flutter
    return jsonify({
        "status": "sukses",
        "data_input": user_data, # Mengirim kembali data input untuk debugging
        "hasil_rab": hasil_akhir_rab
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)