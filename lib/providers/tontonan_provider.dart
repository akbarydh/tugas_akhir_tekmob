import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tontonan.dart';

class TontonanProvider with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _koleksi = 'tontonan';

  // ✅ Stream untuk sinkronisasi real-time
  Stream<List<Tontonan>> get semuaTontonanStream {
    return _firestore.collection(_koleksi).snapshots().map(
      (snapshot) {
        return snapshot.docs
            .map((doc) => Tontonan.fromFirestore(doc.data(), doc.id))
            .toList();
      },
    );
  }

  // ✅ Menambahkan data ke Firestore
  Future<void> tambahTontonan(Tontonan t) async {
    final id = const Uuid().v4();
    final tontonanBaru = Tontonan(
      id: id,
      judul: t.judul,
      genre: t.genre,
      rating: t.rating,
      sinopsis: t.sinopsis,
      poster: t.poster,
      sudahDitonton: t.sudahDitonton,
      ratingPribadi: t.ratingPribadi,
      catatanPribadi: t.catatanPribadi,
    );

    await _firestore
        .collection(_koleksi)
        .doc(id)
        .set(tontonanBaru.toFirestore());
  }

  // ✅ Update data di Firestore
  Future<void> updateTontonan(
    String id, {
    bool? sudahDitonton,
    double? ratingPribadi,
    String? catatanPribadi,
  }) async {
    final doc = await _firestore.collection(_koleksi).doc(id).get();
    if (!doc.exists) return;

    final dataLama = Tontonan.fromFirestore(doc.data()!, doc.id);

    final dataBaru = Tontonan(
      id: dataLama.id,
      judul: dataLama.judul,
      genre: dataLama.genre,
      rating: dataLama.rating,
      sinopsis: dataLama.sinopsis,
      poster: dataLama.poster,
      sudahDitonton: sudahDitonton ?? dataLama.sudahDitonton,
      ratingPribadi: ratingPribadi ?? dataLama.ratingPribadi,
      catatanPribadi: catatanPribadi ?? dataLama.catatanPribadi,
    );

    await _firestore
        .collection(_koleksi)
        .doc(id)
        .update(dataBaru.toFirestore());
  }

  // ✅ Hapus dari Firestore
  Future<void> hapusTontonan(String id) async {
    await _firestore.collection(_koleksi).doc(id).delete();
  }

  // ✅ Ambil satu data berdasarkan ID
  Future<Tontonan?> cariById(String id) async {
    final doc = await _firestore.collection(_koleksi).doc(id).get();
    if (doc.exists) {
      return Tontonan.fromFirestore(doc.data()!, doc.id);
    }
    return null;
  }
}
