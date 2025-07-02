// File: lib/screens/tontonan_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tontonan_provider.dart';
import '../models/tontonan.dart';

class TontonanDetailScreen extends StatelessWidget {
  final String id;

  const TontonanDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final tontonan = Provider.of<TontonanProvider>(context).cariById(id);

    if (tontonan == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Tontonan')),
        body: const Center(child: Text('Tontonan tidak ditemukan.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(tontonan.judul)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Genre: ${tontonan.genre}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text('Rating (OMDb): ⭐ ${tontonan.rating.toStringAsFixed(1)}'),
              const SizedBox(height: 10),
              Text('Status: ${tontonan.sudahDitonton ? "Sudah Ditonton" : "Belum Ditonton"}'),
              const SizedBox(height: 10),
              Text('Rating Pribadi: ${tontonan.ratingPribadi > 0 ? tontonan.ratingPribadi.toStringAsFixed(1) : "Belum dinilai"}'),
              const SizedBox(height: 20),
              const Text('Sinopsis:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(tontonan.sinopsis),
              const SizedBox(height: 20),
              const Text('Catatan Pribadi:', style: TextStyle(fontWeight: FontWeight.bold)),
              tontonan.catatanPribadi.isEmpty
                  ? const Text('Tidak ada catatan.')
                  : Text(tontonan.catatanPribadi),
            ],
          ),
        ),
      ),
    );
  }
}
