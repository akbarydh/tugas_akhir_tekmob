// File: lib/helpers/film_search_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class FilmInfo {
  final String judul;
  final String genre;
  final double rating;
  final String sinopsis;

  FilmInfo({
    required this.judul,
    required this.genre,
    required this.rating,
    required this.sinopsis,
  });
}

class FilmSearchService {
  static const String _apiKey = '30ec435e'; // Ganti dengan API key kamu
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
