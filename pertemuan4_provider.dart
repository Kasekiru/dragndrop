import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:m04/State_Pertemuan4/movieDBStateTopRated.dart';
import 'package:m04/State_Pertemuan4/movieDBStateUpcoming.dart';
import 'package:m04/State_Pertemuan4/movieGenreState.dart';
import 'package:m04/http_helper.dart';
import 'package:m04/State_Pertemuan4/movieDBStateNowplaying.dart';

class ProviderPertemuan4 extends ChangeNotifier {
  late HttpHelper helper = HttpHelper();
  int numPage = 1;
  String selectedValue = 'Now Playing'; // Initially selected value

  List<String> dropdownItems = [
    'Now Playing',
    'Top Rated',
    'Popular',
    'Upcoming'
  ];

  // genre json
  late List<Genre> _listGenre = [];
  List<Genre> get listGenre => _listGenre;
  set listGenre(value) {
    _listGenre = value;
    notifyListeners();
  }

  Future<void> loadApiGenre() async {
    helper.getMovieGenre().then((value) {
      var tmp = jsonDecode(value)['genres'];
      _listGenre = List.generate(
        tmp.length,
        (index) => Genre(id: tmp[index]['id'], name: tmp[index]['name']),
      );
    });
  }

  // find genre
  String findGenre(int id) {
    for (var genre in listGenre) {
      if (genre.id == id) {
        return genre.name;
      }
    }
    return '';
  }

  // now playing json
  late MovieDbStateNowPlaying? _jsonResultNowPlaying = null;
  MovieDbStateNowPlaying? get jsonResultNowPlaying => _jsonResultNowPlaying;
  set jsonResultNowPlaying(value) {
    _jsonResultNowPlaying = value;
    notifyListeners();
  }

  Future<void> loadApiNowPlaying() async {
    helper.getMovieNowPlaying(numPage).then((value) {
      jsonResultNowPlaying = movieDbStateNowPlayingFromJson(value);
    });
  }

  late MovieDbStateTopRated? _jsonResultTopRated = null;
  MovieDbStateTopRated? get jsonResultTopRated => _jsonResultTopRated;
  set jsonResultTopRated(value) {
    _jsonResultTopRated = movieDbStateTopRatedFromJson(value);
    notifyListeners();
  }

  Future<void> loadApiTopRated() async {
    helper.getMovieTopRated(numPage).then((value) {
      jsonResultTopRated = value;
    });
  }

  // Future<void> loadApiLatest() async {
  //   helper.getMovieLatest().then((value) {
  //     jsonResult = value;
  //   });
  // }

  late MovieDbStateUpcoming? _jsonResultUpcoming = null;
  MovieDbStateUpcoming? get jsonResultUpcoming => _jsonResultUpcoming;
  set jsonResultUpcoming(value) {
    _jsonResultUpcoming = movieDbStateUpcomingFromJson(value);
    notifyListeners();
  }

  Future<void> loadApiPopular() async {
    helper.getMoviePopular(numPage).then((value) {
      jsonResultUpcoming = value;
    });
  }

  Future<void> loadApiUpcoming() async {
    helper.getMovieUpcoming(numPage).then((value) {
      jsonResultUpcoming = value;
    });
  }
}
