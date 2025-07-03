// File: lib/screens/edit_tontonan_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tontonan_provider.dart';

class EditTontonanScreen extends StatefulWidget {
  final String id;

  const EditTontonanScreen({super.key, required this.id});

  @override
  State<EditTontonanScreen> createState() => _EditTontonanScreenState();
}

class _EditTontonanScreenState extends State<EditTontonanScreen> {
  bool _sudahDitonton = false;
  double _ratingPribadi = 0.0;
  final _catatanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final tontonan =
        Provider.of<TontonanProvider>(context, listen: false).cariById(widget.id);
    if (tontonan != null) {
      _sudahDitonton = tontonan.sudahDitonton;
      _ratingPribadi = tontonan.ratingPribadi.toDouble();
      _catatanController.text = tontonan.catatanPribadi;
    }
  }

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  void _simpanPerubahan() {
    Provider.of<TontonanProvider>(context, listen: false).updateTontonan(
      widget.id,
      sudahDitonton: _sudahDitonton,
      ratingPribadi: _ratingPribadi,
      catatanPribadi: _catatanController.text,
    );
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perubahan disimpan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Edit Tontonan'),
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.45),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              SwitchListTile(
                activeColor: Colors.amber,
                title: const Text(
                  'Sudah Ditonton?',
                  style: TextStyle(color: Colors.white),
                ),
                value: _sudahDitonton,
                onChanged: (val) => setState(() => _sudahDitonton = val),
              ),
              const SizedBox(height: 16),
              const Text(
                'Rating Pribadi (0–5):',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              Slider(
                value: _ratingPribadi,
                onChanged: (val) => setState(() => _ratingPribadi = val),
                min: 0,
                max: 5,
                divisions: 5,
                label: _ratingPribadi.toStringAsFixed(1),
                activeColor: Colors.amber,
                inactiveColor: Colors.white24,
              ),
              const SizedBox(height: 16),
              const Text(
                'Catatan Pribadi:',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _catatanController,
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade800,
                  hintText: 'Masukkan catatan pribadi...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 246, 186, 6),        // warna mencolok
                  foregroundColor: Colors.black,        // teks hitam kontras
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _simpanPerubahan,
                icon: const Icon(Icons.save),
                label: const Text('SIMPAN'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
