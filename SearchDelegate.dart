import 'package:flutter/material.dart';
import 'Movies.dart';
import 'detail.dart';

class MovieSearchDelegate extends SearchDelegate<String> {
  final List<Movie> movies;

  MovieSearchDelegate(this.movies);

  @override
  String get searchFieldLabel => 'Cari Film...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<Movie> filteredMovies = movies
        .where(
            (movie) => movie.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredMovies.length,
      itemBuilder: (BuildContext context, int position) {
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(filteredMovies[position]),
              ),
            );
          },
          title: Text(filteredMovies[position].title ?? ''),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Movie> suggestionMovies = movies
        .where(
            (movie) => movie.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestionMovies.length,
      itemBuilder: (BuildContext context, int position) {
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(suggestionMovies[position]),
              ),
            );
          },
          title: Text(suggestionMovies[position].title ?? ''),
        );
      },
    );
  }
}
