import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:warna_apa/warna.dart';

class ColorService {
  List<Warna> _listWarna = [];

  Future<void> loadWarna() async {
    if (_listWarna.isNotEmpty) return;

    final data = await rootBundle.loadString('assets/warna.json');
    final List<dynamic> jsonList = json.decode(data);
    _listWarna = jsonList.map((json) => Warna.fromJson(json)).toList();
  }

  /*
  Fungsi untuk mencari nama warna terdekat dari daftar warna
  berdasarkan warna yang diberikan.
  Menggunakan jarak Euclidean untuk menentukan warna terdekat.
  */
  Warna? cariNamaWarnaTerdekat(Color target) {
    double jarakTerdekat = double.infinity;
    Warna warnaTerdekat = Warna(
      nama: 'Tidak diketahui',
      hex: '#000000',
      r: '0',
      g: '0',
      b: '0',
      warnaDasar: 'Tidak diketahui',
    );

    for (var warna in _listWarna) {
      final color = Color(
        int.parse(warna.hex.substring(1), radix: 16) + 0xFF000000,
      );
      final rDiff = ((color.r * 255) - (target.r * 255));
      final gDiff = ((color.g * 255) - (target.g * 255));
      final bDiff = ((color.b * 255) - (target.b * 255));
      final jarak = rDiff * rDiff + gDiff * gDiff + bDiff * bDiff;

      if (jarak < jarakTerdekat) {
        jarakTerdekat = jarak;
        warnaTerdekat = warna;
      }
    }

    return warnaTerdekat;
  }
}
