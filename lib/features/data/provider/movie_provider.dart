import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieProvider extends ChangeNotifier {
  List<dynamic> _movies = [];
  bool _isLoading = false;

  List<dynamic> get movies => _movies;
  bool get isLoading => _isLoading;

  Future<void> fetchMovies() async {
    final url = Uri.parse('https://imdb-top-100-movies.p.rapidapi.com/');
    final headers = {
      'x-rapidapi-key': 'db77586a48mshee6c4ac5b6c2c14p19bad5jsna69e908317e3',
      'x-rapidapi-host': 'imdb-top-100-movies.p.rapidapi.com',
    };

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        // Parse the response and include genre and rating
        final List<dynamic> movieList = json.decode(response.body);

        _movies = movieList.map((movie) {
          return {
            'title': movie['title'],
            'image': movie['image'],
            'genre': movie['genre'] is List ? movie['genre'].join(', ') : movie['genre'],
            'rating': movie['rating'] ?? 'N/A', // Handle rating
          };
        }).toList();
      } else {
        _movies = [];
      }
    } catch (e) {
      _movies = [];
      print('Error fetching data: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void searchMovies(String query) {
    if (query.isEmpty) {
      notifyListeners();
      return;
    }

    // Filter movies based on the query
    final filteredMovies = _movies.where((movie) {
      final title = movie['title']?.toLowerCase() ?? '';
      return title.contains(query.toLowerCase());
    }).toList();

    _movies = filteredMovies;
    notifyListeners();
  }
}
