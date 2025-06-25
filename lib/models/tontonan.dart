// File: lib/models/tontonan.dart

class Tontonan {
  final String id;
  String judul;
  String genre;
  bool sudahDitonton;
  int rating; // 1 - 5
  String catatan;

  Tontonan({
    required this.id,
    required this.judul,
    required this.genre,
    this.sudahDitonton = false,
    this.rating = 1,
    this.catatan = '',
  });
}
