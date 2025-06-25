import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/tontonan_provider.dart';
import 'add_tontonan_screen.dart';
import 'tontonan_detail_screen.dart';
import 'edit_tontonan_screen.dart';

class TontonanListScreen extends StatefulWidget {
  @override
  State<TontonanListScreen> createState() => _TontonanListScreenState();
}

class _TontonanListScreenState extends State<TontonanListScreen> {
  String _searchKeyword = '';

  // widget bintang 1-5
  Widget _buildStars(int rating) {
    return Row(
      children: List.generate(
        5,
        (i) => Icon(
          i < rating ? Icons.star : Icons.star_border,
          size: 16,
          color: Colors.amber,
        ),
      ),
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
            onPressed: () =>
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddTontonanScreen())),
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔍 search bar
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
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
              onChanged: (v) => setState(() => _searchKeyword = v.trim()),
            ),
          ),

          // 📋 daftar tontonan
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
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          title: Text(
                            t.judul,
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${t.genre} • ${t.sudahDitonton ? 'Sudah Ditonton' : 'Belum Ditonton'}',
                                style: const TextStyle(color: Colors.white60, fontSize: 13),
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
                                icon: const Icon(Icons.edit, size: 20, color: Colors.blueAccent),
                                onPressed: () => Navigator.of(ctx).push(
                                  MaterialPageRoute(builder: (_) => EditTontonanScreen(id: t.id)),
                                ),
                              ),
                              IconButton(
                                tooltip: 'Hapus',
                                icon: const Icon(Icons.delete, size: 20, color: Colors.redAccent),
                                onPressed: () => _konfirmasiHapus(t.id, t.judul),
                              ),
                            ],
                          ),
                          onTap: () => Navigator.of(ctx).push(
                            MaterialPageRoute(builder: (_) => TontonanDetailScreen(id: t.id)),
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
