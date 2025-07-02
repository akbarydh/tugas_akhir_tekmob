import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/tontonan.dart';
import '../providers/tontonan_provider.dart';

class AddTontonanScreen extends StatefulWidget {
  const AddTontonanScreen({super.key});

  @override
  State<AddTontonanScreen> createState() => _AddTontonanScreenState();
}

class _AddTontonanScreenState extends State<AddTontonanScreen> {
  final _judulController = TextEditingController();
  final _genreController = TextEditingController();
  final _ratingController = TextEditingController();
  final _sinopsisController = TextEditingController();
  final _catatanController = TextEditingController();
  bool _sudahDitonton = false;
  double _ratingPribadi = 0.0;

  void _simpanData() {
    final tontonan = Tontonan(
      id: const Uuid().v4(),
      judul: _judulController.text,
      genre: _genreController.text,
      rating: double.tryParse(_ratingController.text) ?? 0.0,
      sinopsis: _sinopsisController.text,
      sudahDitonton: _sudahDitonton,
      ratingPribadi: _ratingPribadi.toDouble(), // ✅ pastikan double
      catatanPribadi: _catatanController.text,
    );

    Provider.of<TontonanProvider>(context, listen: false)
        .tambahTontonan(tontonan);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tontonan ditambahkan')),
    );
  }

  @override
  void dispose() {
    _judulController.dispose();
    _genreController.dispose();
    _ratingController.dispose();
    _sinopsisController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Tontonan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _judulController,
              decoration: const InputDecoration(labelText: 'Judul'),
            ),
            TextField(
              controller: _genreController,
              decoration: const InputDecoration(labelText: 'Genre'),
            ),
            TextField(
              controller: _ratingController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Rating (OMDb)'),
            ),
            TextField(
              controller: _sinopsisController,
              decoration: const InputDecoration(labelText: 'Sinopsis'),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Sudah Ditonton'),
              value: _sudahDitonton,
              onChanged: (val) => setState(() => _sudahDitonton = val),
            ),
            const SizedBox(height: 12),
            const Text('Rating Pribadi (0–5):'),
            Slider(
              value: _ratingPribadi,
              onChanged: (val) => setState(() => _ratingPribadi = val),
              min: 0,
              max: 5,
              divisions: 5,
              label: _ratingPribadi.toStringAsFixed(1),
            ),
            TextField(
              controller: _catatanController,
              decoration: const InputDecoration(labelText: 'Catatan Pribadi'),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _simpanData,
              icon: const Icon(Icons.save),
              label: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
