class Tontonan {
  final String id;
  final String judul;
  final String genre;
  final double rating;
  final String sinopsis;
  final String poster; // ✅ TAMBAHKAN INI
  final bool sudahDitonton;
  final double ratingPribadi;
  final String catatanPribadi;

  Tontonan({
    required this.id,
    required this.judul,
    required this.genre,
    required this.rating,
    required this.sinopsis,
    this.poster = '', // ✅ TAMBAHKAN DEFAULT VALUE
    this.sudahDitonton = false,
    this.ratingPribadi = 0.0,
    this.catatanPribadi = '',
  });
}
