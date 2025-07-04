import 'dart:convert';
import 'package:http/http.dart' as http;

class FilmInfo {
  final String judul;
  final String genre;
  final double rating;
  final String sinopsis;
  final String poster; 

  FilmInfo({
    required this.judul,
    required this.genre,
    required this.rating,
    required this.sinopsis,
    required this.poster,
  });
}

class FilmSearchService {
  static const String _apiKey = '30ec435e'; 
  static const String _baseUrl = 'https://www.omdbapi.com/';

  static Future<FilmInfo?> cariFilm(String judul) async {
    final url = Uri.parse('$_baseUrl?apikey=$_apiKey&t=$judul');

    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final data = json.decode(res.body);

        if (data['Response'] == 'True') {
          return FilmInfo(
            judul: data['Title'] ?? '',
            genre: data['Genre'] ?? '',
            rating: double.tryParse(data['imdbRating'] ?? '0') ?? 0.0,
            sinopsis: data['Plot'] ?? '',
            poster: data['Poster'] ?? '', // ✅ Ambil poster dari API
          );
        } else {
          print('Film tidak ditemukan: ${data['Error']}');
        }
      } else {
        print('Status code error: ${res.statusCode}');
      }
    } catch (e) {
      print('Gagal fetch film: $e');
    }
    return null;
  }
}
