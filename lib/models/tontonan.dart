// File: lib/models/tontonan.dart

class Tontonan {
  final String id;
  final String judul;
  final String genre;
  final double rating;         // Rating dari OMDb
  final String sinopsis;       // Sinopsis dari OMDb
  bool sudahDitonton;          // Status apakah sudah ditonton
  double ratingPribadi;        // 🔁 Rating dari user (0–5), ubah ke double
  String catatanPribadi;       // Catatan dari user

  Tontonan({
    required this.id,
    required this.judul,
    required this.genre,
    required this.rating,
    required this.sinopsis,
    this.sudahDitonton = false,
    this.ratingPribadi = 0.0,     // 🔁 default juga jadi 0.0
    this.catatanPribadi = '',
  });
}
