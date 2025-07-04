import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tontonan_provider.dart';
import '../models/tontonan.dart';

class TontonanDetailScreen extends StatefulWidget {
  final String id;
  const TontonanDetailScreen({super.key, required this.id});

  @override
  State<TontonanDetailScreen> createState() => _TontonanDetailScreenState();
}

class _TontonanDetailScreenState extends State<TontonanDetailScreen> {
  late Future<Tontonan?> _futureTontonan;

  @override
  void initState() {
    super.initState();
    _futureTontonan = Provider.of<TontonanProvider>(context, listen: false).cariById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
        title: const Text('Detail Tontonan'),
      ),
      body: FutureBuilder<Tontonan?>(
        future: _futureTontonan,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text('Tontonan tidak ditemukan.', style: TextStyle(color: Colors.white)),
            );
          }

          final tontonan = snapshot.data!;

          return Center(
            child: Container(
              width: 320,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white12),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (tontonan.poster.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          tontonan.poster,
                          height: 300,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, error, stack) =>
                              const Icon(Icons.broken_image, size: 100, color: Colors.white30),
                        ),
                      ),
                    const SizedBox(height: 20),
                    Text(
                      tontonan.genre,
                      style: const TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '⭐ ${tontonan.rating.toStringAsFixed(1)}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      tontonan.sudahDitonton ? 'Sudah Ditonton' : 'Belum Ditonton',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      tontonan.ratingPribadi > 0
                          ? 'Rating Pribadi: ${tontonan.ratingPribadi.toStringAsFixed(1)}'
                          : 'Rating Pribadi: Belum dinilai',
                      style: const TextStyle(color: Colors.white60),
                    ),
                    const SizedBox(height: 20),
                    const Text('Sinopsis:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text(
                      tontonan.sinopsis,
                      style: const TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Text('Catatan Pribadi:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text(
                      tontonan.catatanPribadi.isNotEmpty
                          ? '"${tontonan.catatanPribadi}"'
                          : 'Tidak ada catatan.',
                      style: const TextStyle(color: Colors.white54, fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
