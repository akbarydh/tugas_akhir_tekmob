// File: lib/models/tontonan.dart

class Tontonan {
  final String id;
  final String judul;
  final String genre;
  final double rating;
  final String sinopsis;
  final String poster; // ✅ Tambahan untuk gambar poster
  final bool sudahDitonton;
  final double ratingPribadi;
  final String catatanPribadi;

  Tontonan({
    required this.id,
    required this.judul,
    required this.genre,
    required this.rating,
    required this.sinopsis,
    this.poster = '', // ✅ Nilai default untuk poster
    this.sudahDitonton = false,
    this.ratingPribadi = 0.0,
    this.catatanPribadi = '',
  });

  // ✅ Factory constructor untuk membuat instance dari data Firestore
  factory Tontonan.fromFirestore(Map<String, dynamic> data, String id) {
    return Tontonan(
      id: id,
      judul: data['judul'] ?? '',
      genre: data['genre'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      sinopsis: data['sinopsis'] ?? '',
      poster: data['poster'] ?? '',
      sudahDitonton: data['sudahDitonton'] ?? false,
      ratingPribadi: (data['ratingPribadi'] ?? 0).toDouble(),
      catatanPribadi: data['catatanPribadi'] ?? '',
    );
  }

  // ✅ Konversi ke Map untuk disimpan ke Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'judul': judul,
      'genre': genre,
      'rating': rating,
      'sinopsis': sinopsis,
      'poster': poster,
      'sudahDitonton': sudahDitonton,
      'ratingPribadi': ratingPribadi,
      'catatanPribadi': catatanPribadi,
    };
  }
}
