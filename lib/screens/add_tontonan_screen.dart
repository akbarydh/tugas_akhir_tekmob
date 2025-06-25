// File: lib/screens/add_tontonan_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tontonan.dart';
import '../providers/tontonan_provider.dart';
import 'package:uuid/uuid.dart';

class AddTontonanScreen extends StatefulWidget {
  @override
  _AddTontonanScreenState createState() => _AddTontonanScreenState();
}

class _AddTontonanScreenState extends State<AddTontonanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _catatanController = TextEditingController();
  String _genre = 'Action';
  bool _sudahDitonton = false;
  double _rating = 3;

  void _simpanForm() {
    if (_formKey.currentState!.validate()) {
      final newTontonan = Tontonan(
        id: const Uuid().v4(),
        judul: _judulController.text,
        genre: _genre,
        sudahDitonton: _sudahDitonton,
        rating: _rating.toInt(),
        catatan: _catatanController.text,
      );

      Provider.of<TontonanProvider>(context, listen: false)
          .tambahTontonan(newTontonan);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Tontonan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _judulController,
                decoration: InputDecoration(labelText: 'Judul'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _genre,
                decoration: InputDecoration(labelText: 'Genre'),
                items: ['Action', 'Drama', 'Horror', 'Comedy', 'Romance']
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _genre = value!;
                  });
                },
              ),
              SwitchListTile(
                title: Text('Sudah Ditonton?'),
                value: _sudahDitonton,
                onChanged: (value) {
                  setState(() {
                    _sudahDitonton = value;
                  });
                },
              ),
              Text('Rating: ${_rating.toInt()}'),
              Slider(
                value: _rating,
                min: 1,
                max: 5,
                divisions: 4,
                label: _rating.toInt().toString(),
                onChanged: (value) {
                  setState(() {
                    _rating = value;
                  });
                },
              ),
              TextFormField(
                controller: _catatanController,
                decoration: InputDecoration(labelText: 'Catatan (Opsional)'),
                maxLines: 2,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _simpanForm,
                child: Text('Simpan'),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _judulController.dispose();
    _catatanController.dispose();
    super.dispose();
  }
}