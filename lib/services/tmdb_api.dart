// lib/services/tmdb_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class TMDBApi {
  static const String apiKey = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxYmZmM2ViZDNiNzQ5MDg0OTViZWJjOTBkMDFmYzMwMCIsInN1YiI6IjY1NjhlOTcyNmY2YTk5MDIwNzI1MDAyZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Mujd0t1eeBsGGppOzrd-2C95PCN5JGOPWPZbUYgbm78';
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  Future<List<Map<String, dynamic>>> getTrending(String mediaType) async {
    final response = await http.get(
      Uri.parse('$baseUrl/trending/$mediaType/week?language=en-US'), headers: {'Authorization': 'Bearer $apiKey'}
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null) {
        return List<Map<String, dynamic>>.from(data['results']);
      } else {
        throw Exception('No results found for trending $mediaType');
      }
    } else {
      throw Exception('Failed to load trending $mediaType');
    }
  }

  Future<Map<String, dynamic>> searchMedia(String query, String mediaType) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search/$mediaType?query=$query&language=en-US'), headers: {'Authorization': 'Bearer $apiKey'}
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to perform search for $mediaType');
    }
  }

}
