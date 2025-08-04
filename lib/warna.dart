// To parse this JSON data, do
//
//     final warna = warnaFromJson(jsonString);

import 'dart:convert';

Warna warnaFromJson(String str) => Warna.fromJson(json.decode(str));

String warnaToJson(Warna data) => json.encode(data.toJson());

class Warna {
  String nama;
  String hex;
  String r;
  String g;
  String b;
  String warnaDasar;

  Warna({
    required this.nama,
    required this.hex,
    required this.r,
    required this.g,
    required this.b,
    required this.warnaDasar,
  });

  factory Warna.fromJson(Map<String, dynamic> json) => Warna(
    nama: json["nama"],
    hex: json["hex"],
    r: json["r"],
    g: json["g"],
    b: json["b"],
    warnaDasar: json["warna_dasar"],
  );

  Map<String, dynamic> toJson() => {
    "nama": nama,
    "hex": hex,
    "r": r,
    "g": g,
    "b": b,
    "warna_dasar": warnaDasar,
  };
}
