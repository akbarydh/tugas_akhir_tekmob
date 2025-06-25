import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/tontonan.dart';
import '../providers/tontonan_provider.dart';

class EditTontonanScreen extends StatefulWidget {
  final String id;
  const EditTontonanScreen({super.key, required this.id});

  @override
  State<EditTontonanScreen> createState() => _EditTontonanScreenState();
}

class _EditTontonanScreenState extends State<EditTontonanScreen> {
  final _formKey = GlobalKey<FormState>();
  late Tontonan _tontonan;

  final List<String> _genreOptions = [
    'Action',
    'Drama',
    'Horror',
    'Comedy',
    'Romance',
  ];

  String _judul = '';
  String _genre = 'Action';
  bool _sudahDitonton = false;
  int _rating = 1;
  String _catatan = '';

  @override
  void initState() {
    super.initState();
    final tontonanProvider = Provider.of<TontonanProvider>(context, listen: false);
    final t = tontonanProvider.cariById(widget.id);
    if (t != null) {
      _tontonan = t;
      _judul = t.judul;
      _genre = t.genre;
      _sudahDitonton = t.sudahDitonton;
      _rating = t.rating;
      _catatan = t.catatan;
    }
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final tontonanBaru = Tontonan(
      id: _tontonan.id,
      judul: _judul,
      genre: _genre,
      sudahDitonton: _sudahDitonton,
      rating: _rating,
      catatan: _catatan,
    );

    Provider.of<TontonanProvider>(context, listen: false)
        .editTontonan(_tontonan.id, tontonanBaru);

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tontonan berhasil diedit')),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _simpan();
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _judul,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Judul'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Judul wajib diisi' : null,
                onSaved: (val) => _judul = val!.trim(),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _genre,
                dropdownColor: Colors.grey.shade900,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Genre'),
                items: _genreOptions
                    .map((g) =>
                        DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (val) => setState(() => _genre = val!),
                onSaved: (val) => _genre = val ?? 'Action',
              ),
              const SizedBox(height: 16),

              SwitchListTile(
                title: const Text('Sudah Ditonton',
                    style: TextStyle(color: Colors.white)),
                value: _sudahDitonton,
                onChanged: (v) => setState(() => _sudahDitonton = v),
                activeColor: Colors.deepPurple,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 8),

              Text('Rating: $_rating', style: const TextStyle(color: Colors.white)),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 20,
                  ),
                ),
              ),
              Slider(
                min: 1,
                max: 5,
                divisions: 4,
                value: _rating.toDouble(),
                activeColor: Colors.amber,
                label: _rating.toString(),
                onChanged: (val) => setState(() => _rating = val.round()),
              ),
              const SizedBox(height: 16),

              TextFormField(
                initialValue: _catatan,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Catatan (opsional)'),
                onSaved: (val) => _catatan = val ?? '',
              ),
              const SizedBox(height: 40),

              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _simpan();
                  }
                },
                icon: const Icon(Icons.check),
                label: const Text('Simpan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.grey.shade900,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade800),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.deepPurple),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
