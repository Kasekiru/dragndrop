import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'Movies.dart';

class HttpHelper {
  final String _urlKey = "?api_key=fdbce446784119fbe5f15f52ab3d29d7";
  final String _urlBase = "https://api.themoviedb.org";

  Future<List<Movie>> getMovies(String category) async {
    var url = Uri.parse(_urlBase + '/3/movie/$category' + _urlKey);
    http.Response result = await http.get(url);
    if (result.statusCode == HttpStatus.ok) {
      List<Movie> movies = parseMovies(result.body);
      return movies;
    }
    throw Exception('Failed to fetch movies');
  }

  List<Movie> parseMovies(String responseBody) {
    final Map<String, dynamic> data = json.decode(responseBody);
    final List<dynamic> results = data['results'];

    return results.map<Movie>((json) => Movie.fromJson(json)).toList();
  }

  Future<List<Movie>> getLatestMovies() async {
    return await getMovies('latest');
  }

  Future<List<Movie>> getNowPlayingMovies() async {
    return await getMovies('now_playing');
  }

  Future<List<Movie>> getPopularMovies() async {
    return await getMovies('popular');
  }

  Future<List<Movie>> getUpcomingMovies() async {
    return await getMovies('upcoming');
  }

  Future<List<Movie>> getTopRatedMovies() async {
    return await getMovies('top_rated');
  }
}
