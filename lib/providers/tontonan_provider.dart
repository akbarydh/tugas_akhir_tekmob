import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/tontonan.dart';
import 'package:collection/collection.dart';

class TontonanProvider with ChangeNotifier {
  final List<Tontonan> _daftar = [];

  List<Tontonan> get semuaTontonan => [..._daftar];

  void tambahTontonan(Tontonan t) {
    final tontonanBaru = Tontonan(
      id: const Uuid().v4(),
      judul: t.judul,
      genre: t.genre,
      rating: t.rating,
      sinopsis: t.sinopsis,
      sudahDitonton: false,
      ratingPribadi: t.ratingPribadi,
      catatanPribadi: t.catatanPribadi,
    );
    _daftar.add(tontonanBaru);
    notifyListeners();
  }

  void updateTontonan(
    String id, {
    bool? sudahDitonton,
    double? ratingPribadi, // ✅ perbaikan tipe
    String? catatanPribadi,
  }) {
    final index = _daftar.indexWhere((t) => t.id == id);
    if (index != -1) {
      final t = _daftar[index];
      _daftar[index] = Tontonan(
        id: t.id,
        judul: t.judul,
        genre: t.genre,
        rating: t.rating,
        sinopsis: t.sinopsis,
        sudahDitonton: sudahDitonton ?? t.sudahDitonton,
        ratingPribadi: ratingPribadi ?? t.ratingPribadi,
        catatanPribadi: catatanPribadi ?? t.catatanPribadi,
      );
      notifyListeners();
    }
  }

  void hapusTontonan(String id) {
    _daftar.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  Tontonan? cariById(String id) {
    return _daftar.firstWhereOrNull((t) => t.id == id);
  }

  List<Tontonan> cariByJudul(String keyword) {
    return _daftar
        .where((t) => t.judul.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }
}
