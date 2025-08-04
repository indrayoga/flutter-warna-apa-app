import 'package:flutter/material.dart';
import 'package:warna_apa/warna.dart';

class ColorInfoDisplay extends StatelessWidget {
  final Color color;
  final Warna? closestWarna;
  final String title;

  const ColorInfoDisplay({
    super.key,
    required this.color,
    required this.closestWarna,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    // Helper untuk mengubah Color ke String HEX
    final hexString =
        '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 100,
          height: 100,
          color: color,
          margin: const EdgeInsets.only(right: 16),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                'RGB: (${(color.r * 255).toInt() & 0xff}, ${(color.g * 255).toInt() & 0xff}, ${(color.b * 255).toInt() & 0xff})',
              ),
              Text('HEX: $hexString'),
              if (closestWarna != null) ...[
                Text('Nama Warna: ${closestWarna!.nama}'),
                Text('Warna Dasar: ${closestWarna!.warnaDasar}'),
              ] else ...[
                const Text('Nama Warna: Tidak diketahui'),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
