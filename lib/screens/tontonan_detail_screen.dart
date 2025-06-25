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
        appBar: AppBar(title: Text('Detail Tontonan')),
        body: Center(child: Text('Tontonan tidak ditemukan.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(tontonan.judul)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Genre: ${tontonan.genre}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Status: ${tontonan.sudahDitonton ? "Sudah Ditonton" : "Belum Ditonton"}'),
            SizedBox(height: 10),
            Text('Rating: ⭐ ${tontonan.rating}'),
            SizedBox(height: 10),
            if (tontonan.catatan.isNotEmpty)
              Text('Catatan: ${tontonan.catatan}'),
          ],
        ),
      ),
    );
  }
}
