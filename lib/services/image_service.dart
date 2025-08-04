import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class ImageService {
  /// Menghitung warna dominan dari sebuah gambar dengan metode histogram sederhana.
  /// Melewatkan beberapa piksel (step) untuk meningkatkan performa.
  Future<Color?> getDominantColor(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) return null;

    final Map<int, int> colorCount = {};
    int maxCount = 0;
    int? dominantRgb;

    // Melewatkan beberapa piksel untuk performa lebih cepat
    const step = 5;

    for (int y = 0; y < image.height; y += step) {
      for (int x = 0; x < image.width; x += step) {
        final pixel = image.getPixel(x, y);
        final r = pixel.r.toInt();
        final g = pixel.g.toInt();
        final b = pixel.b.toInt();

        final rgb = (r << 16) | (g << 8) | b;
        final count = colorCount[rgb] = (colorCount[rgb] ?? 0) + 1;

        if (count > maxCount) {
          maxCount = count;
          dominantRgb = rgb;
        }
      }
    }

    if (dominantRgb == null) return null;

    final r = (dominantRgb >> 16) & 0xFF;
    final g = (dominantRgb >> 8) & 0xFF;
    final b = dominantRgb & 0xFF;

    return Color.fromARGB(255, r, g, b);
  }

  /// Mendapatkan warna dari posisi piksel tertentu pada gambar.
  Color? getPixelColor(img.Image image, Size widgetSize, Offset localPosition) {
    final scaleX = image.width / widgetSize.width;
    final scaleY = image.height / widgetSize.height;

    final pixelX = (localPosition.dx * scaleX).toInt();
    final pixelY = (localPosition.dy * scaleY).toInt();

    if (pixelX >= 0 &&
        pixelY >= 0 &&
        pixelX < image.width &&
        pixelY < image.height) {
      final pixel = image.getPixel(pixelX, pixelY);
      return Color.fromARGB(
        255,
        pixel.r.toInt(),
        pixel.g.toInt(),
        pixel.b.toInt(),
      );
    }

    return null;
  }
}
