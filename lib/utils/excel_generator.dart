import 'package:excel/excel.dart';
import 'package:rabcalc/providers/rab_provider.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:rabcalc/utils/string_extensions.dart';
import 'package:intl/intl.dart';

class ExcelGenerator {
  static Future<void> generateAndSaveExcel(RabProvider provider) async {
    final excel = Excel.createExcel();
    final Sheet sheet = excel['RAB'];

    final rabData = provider.rabData;
    final calculationResult = provider.calculationResult?['hasil_rab'];
    if (calculationResult == null) return;

    final rincianBiaya = calculationResult['rincian_biaya'] as Map<String, dynamic>;
    final totalBiayaKonstruksi = calculationResult['total_biaya_konstruksi_rp'];

    final formatRp = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    CellStyle headerStyle = CellStyle(
      bold: true,
      backgroundColorHex: ExcelColor.fromHexString("#030047"),
      fontColorHex: ExcelColor.fromHexString("#FFFFFF"),
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );

    CellStyle totalStyle = CellStyle(bold: true);

    // Judul
    sheet.merge(CellIndex.indexByString('A1'), CellIndex.indexByString('F1'));
    var titleCell = sheet.cell(CellIndex.indexByString('A1'));
    titleCell.value = TextCellValue('RENCANA ANGGARAN BIAYA (RAB)');
    titleCell.cellStyle = CellStyle(bold: true, fontSize: 16, horizontalAlign: HorizontalAlign.Center);

    // Info proyek
    sheet.cell(CellIndex.indexByString('A3')).value = TextCellValue('Proyek:');
    sheet.cell(CellIndex.indexByString('B3')).value = TextCellValue(rabData.projectName ?? '-');
    sheet.cell(CellIndex.indexByString('A4')).value = TextCellValue('Lokasi:');
    sheet.cell(CellIndex.indexByString('B4')).value = TextCellValue(rabData.location ?? '-');

    // Header tabel
    final headers = ['No', 'Uraian Pekerjaan', 'Volume', 'Satuan', 'Harga Satuan (Rp)', 'Jumlah Harga (Rp)'];
    sheet.appendRow([TextCellValue('')]); // spasi
    sheet.appendRow(headers.map((h) => TextCellValue(h)).toList());

    int headerRowIndex = sheet.maxRows - 1;
    for (var i = 0; i < headers.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: headerRowIndex)).cellStyle = headerStyle;
    }

    // Data isi tabel
    int itemNumber = 1;
    for (var entry in rincianBiaya.entries) {
      String uraian = entry.key.replaceAll('_', ' ').replaceAll('pekerjaan ', '').capitalize();
      String satuan = entry.key.split('_').last;
      var value = entry.value;

      final dataRow = [
        IntCellValue(itemNumber++),
        TextCellValue(uraian),
        DoubleCellValue(value['volume'].toDouble()),
        TextCellValue(satuan),
        TextCellValue(formatRp.format(value['harga_satuan_rp'])),
        TextCellValue(formatRp.format(value['jumlah_harga_rp'])),
      ];
      sheet.appendRow(dataRow);
    }

    // Ringkasan
    sheet.appendRow([TextCellValue('')]);
    int summaryRowStart = sheet.maxRows;

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: summaryRowStart)).value = TextCellValue('Subtotal');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: summaryRowStart)).value =
        TextCellValue(formatRp.format(totalBiayaKonstruksi));

    final ppn = totalBiayaKonstruksi * 0.11;
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: summaryRowStart + 1)).value = TextCellValue('PPN (11%)');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: summaryRowStart + 1)).value =
        TextCellValue(formatRp.format(ppn));

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: summaryRowStart + 2)).cellStyle = totalStyle;
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: summaryRowStart + 2)).value = TextCellValue('Total Akhir');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: summaryRowStart + 2)).value =
        TextCellValue(formatRp.format(totalBiayaKonstruksi + ppn));
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: summaryRowStart + 2)).cellStyle = totalStyle;

    // Simpan dan buka file
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/RAB_${rabData.projectName?.replaceAll(' ', '_') ?? 'Proyek'}.xlsx';
    final fileBytes = excel.save();

    if (fileBytes != null) {
      File(path)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);
      await OpenFile.open(path);
    }
  }
}
