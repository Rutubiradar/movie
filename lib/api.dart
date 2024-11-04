import 'dart:convert';
import 'package:http/http.dart' as http;

class TMDBApiService {
  final String apiKey = '3793cb166132aafb6c70ad4a639b8665';
  final String baseUrl = 'https://api.themoviedb.org/3';

  Future<List<dynamic>> searchMovies(String query) async {
    final url = Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['results']; // Returns the list of movies
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<dynamic>> getPopularMovies() async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/popular?api_key=3793cb166132aafb6c70ad4a639b8665'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load popular movies');
    }
  }
}
