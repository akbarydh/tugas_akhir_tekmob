// File: lib/screens/tontonan_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../providers/tontonan_provider.dart';
import '../models/tontonan.dart';
import 'add_tontonan_screen.dart';
import 'tontonan_detail_screen.dart';
import 'edit_tontonan_screen.dart';
import '../helpers/film_search_service.dart';

class TontonanListScreen extends StatefulWidget {
  @override
  State<TontonanListScreen> createState() => _TontonanListScreenState();
}

class _TontonanListScreenState extends State<TontonanListScreen> {
  String _searchKeyword = '';

  Widget _buildStars(double rating) {
    return Row(
      children: List.generate(
        5,
        (i) => Icon(
          i < rating.round() ? Icons.star : Icons.star_border,
          size: 16,
          color: Colors.amber,
        ),
      ),
    );
  }

  Future<void> _cariFilmDanTambah(String judul) async {
    final hasil = await FilmSearchService.cariFilm(judul);
    if (hasil == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Film tidak ditemukan.')),
      );
      return;
    }

    final tontonanBaru = Tontonan(
      id: const Uuid().v4(),
      judul: hasil.judul,
      genre: hasil.genre,
      rating: hasil.rating,
      sinopsis: hasil.sinopsis,
      poster: hasil.poster, // ✅ TAMBAHKAN POSTER
      ratingPribadi: 0.0,
      catatanPribadi: '',
    );

    Provider.of<TontonanProvider>(context, listen: false)
        .tambahTontonan(tontonanBaru);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Film "${hasil.judul}" ditambahkan.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tontonanProv = context.watch<TontonanProvider>();
    final daftar = _searchKeyword.isEmpty
        ? tontonanProv.semuaTontonan
        : tontonanProv.cariByJudul(_searchKeyword);

    Future<void> _konfirmasiHapus(String id, String judul) async {
      final setuju = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.grey.shade900,
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
          contentTextStyle: const TextStyle(color: Colors.white70),
          title: const Text('Hapus Tontonan?'),
          content: Text('Yakin mau menghapus "$judul"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Hapus'),
            ),
          ],
        ),
      );

      if (setuju == true) {
        tontonanProv.hapusTontonan(id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('"$judul" dihapus')),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
        title: const Text('Daftar Tontonan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => AddTontonanScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final controller = TextEditingController();
              await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Cari Film'),
                  content: TextField(
                    controller: controller,
                    decoration: const InputDecoration(hintText: 'Masukkan judul film'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Batal'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _cariFilmDanTambah(controller.text);
                      },
                      child: const Text('Cari & Tambah'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Cari judul...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.grey.shade800,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
              onChanged: (v) => setState(() => _searchKeyword = v.trim()),
            ),
          ),
          Expanded(
            child: daftar.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak ada tontonan.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: daftar.length,
                    itemBuilder: (ctx, i) {
                      final t = daftar[i];
                      return Card(
                        color: Colors.grey.shade900,
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: t.poster.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.network(
                                    t.poster,
                                    width: 50,
                                    height: 75,
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, err, stack) =>
                                        const Icon(Icons.broken_image,
                                            color: Colors.white38),
                                  ),
                                )
                              : const Icon(Icons.movie, color: Colors.white38),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          title: Text(
                            t.judul,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${t.genre} • ${t.sudahDitonton ? 'Sudah Ditonton' : 'Belum Ditonton'}',
                                style: const TextStyle(
                                    color: Colors.white60, fontSize: 13),
                              ),
                              const SizedBox(height: 4),
                              _buildStars(t.rating),
                            ],
                          ),
                          trailing: Wrap(
                            spacing: 4,
                            children: [
                              IconButton(
                                tooltip: 'Edit',
                                icon: const Icon(Icons.edit,
                                    size: 20, color: Colors.blueAccent),
                                onPressed: () => Navigator.of(ctx).push(
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          EditTontonanScreen(id: t.id)),
                                ),
                              ),
                              IconButton(
                                tooltip: 'Hapus',
                                icon: const Icon(Icons.delete,
                                    size: 20, color: Colors.redAccent),
                                onPressed: () =>
                                    _konfirmasiHapus(t.id, t.judul),
                              ),
                            ],
                          ),
                          onTap: () => Navigator.of(ctx).push(
                            MaterialPageRoute(
                                builder: (_) =>
                                    TontonanDetailScreen(id: t.id)),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
