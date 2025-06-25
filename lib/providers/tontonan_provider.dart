import 'package:flutter/material.dart';
import '../models/tontonan.dart';

class TontonanProvider with ChangeNotifier {
  final List<Tontonan> _daftarTontonan = [];

  List<Tontonan> get semuaTontonan => [..._daftarTontonan];

  void tambahTontonan(Tontonan tontonan) {
    _daftarTontonan.add(tontonan);
    notifyListeners();
  }

  void editTontonan(String id, Tontonan tontonanBaru) {
    final index = _daftarTontonan.indexWhere((t) => t.id == id);
    if (index >= 0) {
      _daftarTontonan[index] = tontonanBaru;
      notifyListeners();
    }
  }

  void hapusTontonan(String id) {
    _daftarTontonan.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  Tontonan? cariById(String id) =>
      _daftarTontonan.firstWhere((t) => t.id == id, orElse: () => Tontonan(id: '', judul: '', genre: ''));

  List<Tontonan> cariByJudul(String keyword) => _daftarTontonan
      .where((t) => t.judul.toLowerCase().contains(keyword.toLowerCase()))
      .toList();

  List<Tontonan> filterBy({String? genre, bool? sudahDitonton}) => _daftarTontonan
      .where((t) {
        final g = genre == null || t.genre == genre;
        final s = sudahDitonton == null || t.sudahDitonton == sudahDitonton;
        return g && s;
      })
      .toList();
}
