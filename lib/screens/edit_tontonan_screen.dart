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
    final tontonan = Provider.of<TontonanProvider>(context, listen: false).cariById(widget.id);
    if (tontonan != null) {
      _sudahDitonton = tontonan.sudahDitonton;
      _ratingPribadi = tontonan.ratingPribadi.toDouble(); // ✅ pakai double
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
      ratingPribadi: _ratingPribadi.toDouble(), // ✅ jaga konsistensi
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
      appBar: AppBar(title: const Text('Edit Tontonan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            SwitchListTile(
              title: const Text('Sudah Ditonton?'),
              value: _sudahDitonton,
              onChanged: (val) => setState(() => _sudahDitonton = val),
            ),
            const SizedBox(height: 16),
            const Text('Rating Pribadi (0–5):'),
            Slider(
              value: _ratingPribadi,
              onChanged: (val) => setState(() => _ratingPribadi = val),
              min: 0,
              max: 5,
              divisions: 5,
              label: _ratingPribadi.toStringAsFixed(1),
            ),
            const SizedBox(height: 16),
            const Text('Catatan Pribadi:'),
            TextField(
              controller: _catatanController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Masukkan catatan pribadi...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _simpanPerubahan,
              icon: const Icon(Icons.save),
              label: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
