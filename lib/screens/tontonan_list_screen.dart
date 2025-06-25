// File: lib/screens/tontonan_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tontonan_provider.dart';
import 'add_tontonan_screen.dart';
import 'tontonan_detail_screen.dart';

class TontonanListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tontonanProvider = Provider.of<TontonanProvider>(context);
    final daftarTontonan = tontonanProvider.semuaTontonan;

    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Tontonan'),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.black),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => AddTontonanScreen()),
              );
            },
          ),
        ],
      ),
      body: daftarTontonan.isEmpty
          ? Center(child: Text('Belum ada tontonan.'))
          : ListView.builder(
              itemCount: daftarTontonan.length,
              itemBuilder: (context, index) {
                final t = daftarTontonan[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(t.judul),
                    subtitle: Text('${t.genre} • ${t.sudahDitonton ? 'Sudah Ditonton' : 'Belum Ditonton'}'),
                    trailing: Text('⭐ ${t.rating}'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TontonanDetailScreen(id: t.id),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
