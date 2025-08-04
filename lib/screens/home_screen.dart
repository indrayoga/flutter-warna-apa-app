import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:warna_apa/services/color_service.dart';
import 'package:warna_apa/services/image_service.dart';
import 'package:warna_apa/widgets/color_info_display.dart';
import 'package:warna_apa/warna.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Services
  final ImagePicker _picker = ImagePicker();
  final ColorService _colorService = ColorService();
  final ImageService _imageService = ImageService();

  // State
  bool isLoading = false;
  File? _imageFile;
  img.Image? _decodedImage;
  // Warna dominan yang diambil dari gambar
  Color? _dominantColor;
  // Warna yang diambil dari titik tap pada gambar
  Color? _tappedColor;
  // Warna terdekat yang ditemukan dari ColorService dan dikonversi ke nama warna dalam daftar warna
  Warna? _warna;

  final GlobalKey _imageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Memuat data warna dalam bahasa indonesia saat aplikasi pertama kali dijalankan
    _colorService.loadWarna();
  }

  /*
  Fungsi untuk memilih gambar dari galeri.
  Jika gambar dipilih, akan menghitung warna dominan
  dan mencari nama warna terdekat menggunakan ColorService.
  */
  Future<void> _pickImageFromGallery() async {
    // tampilkan indikator loading, karena proses ini bisa memakan waktu
    setState(() => isLoading = true);

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      final bytes = await imageFile.readAsBytes();
      final decoded = img.decodeImage(bytes);
      final dominantColor = await _imageService.getDominantColor(imageFile);

      setState(() {
        _imageFile = imageFile;
        _decodedImage = decoded;
        _dominantColor = dominantColor;
        _tappedColor = null; // Reset tapped color
        if (dominantColor != null) {
          _warna = _colorService.cariNamaWarnaTerdekat(dominantColor);
        }
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  void _getTappedColor(TapDownDetails details) {
    if (_decodedImage == null) return;

    final RenderBox box =
        _imageKey.currentContext!.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(details.globalPosition);

    final color = _imageService.getPixelColor(
      _decodedImage!,
      box.size,
      localPosition,
    );

    if (color != null) {
      setState(() {
        _tappedColor = color;
        _warna = _colorService.cariNamaWarnaTerdekat(color);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WarnaApa'), centerTitle: true),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InteractiveViewer(
                      child: Container(
                        constraints: const BoxConstraints(
                          maxHeight: 400,
                          maxWidth: double.infinity,
                        ),
                        child: _imageFile != null
                            ? GestureDetector(
                                onTapDown: _getTappedColor,
                                child: Image.file(
                                  _imageFile!,
                                  key: _imageKey,
                                  fit: BoxFit.contain,
                                ),
                              )
                            : const Text(
                                "Pilih Gambar dari Galeri atau Ambil dari Camera",
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_tappedColor != null)
                      ColorInfoDisplay(
                        color: _tappedColor!,
                        closestWarna: _warna,
                        title: 'Warna dari titik tap:',
                      ),
                    if (_tappedColor == null && _dominantColor != null)
                      ColorInfoDisplay(
                        color: _dominantColor!,
                        closestWarna: _warna,
                        title: 'Warna Dominan:',
                      ),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImageFromGallery,
        child: Icon(Icons.color_lens),
      ),
    );
  }
}
