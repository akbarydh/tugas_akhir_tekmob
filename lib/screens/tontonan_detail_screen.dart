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
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Detail Tontonan'),
          backgroundColor: Colors.grey.shade900,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text(
            'Tontonan tidak ditemukan.',
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(tontonan.judul),
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
                color: Colors.black.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✅ Poster Section
              if (tontonan.poster.isNotEmpty)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      tontonan.poster,
                      height: 300,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, error, stack) =>
                          const Icon(Icons.broken_image, size: 100),
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              // ✅ Genre
              Text(
                tontonan.genre,
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // ✅ Rating
              Text(
                '⭐ ${tontonan.rating.toStringAsFixed(1)}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // ✅ Status Tontonan
              Text(
                tontonan.sudahDitonton ? 'Sudah Ditonton' : 'Belum Ditonton',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // ✅ Rating Pribadi
              Text(
                tontonan.ratingPribadi > 0
                    ? 'Rating Pribadi: ${tontonan.ratingPribadi.toStringAsFixed(1)}'
                    : 'Rating Pribadi: Belum dinilai',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // ✅ Sinopsis
              const Text(
                'Sinopsis:',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                tontonan.sinopsis,
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // ✅ Catatan Pribadi
              const Text(
                'Catatan Pribadi:',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                tontonan.catatanPribadi.isNotEmpty
                    ? '"${tontonan.catatanPribadi}"'
                    : 'Tidak ada catatan.',
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
