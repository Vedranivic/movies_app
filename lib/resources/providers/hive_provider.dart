/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'package:fimber/fimber.dart';
import 'package:hive/hive.dart';
import 'package:movies_app/resources/interfaces/local_provider.dart';

import '../../models/genre.dart';
import '../../models/movie.dart';

/// Local source provider - [DB] database
class HiveProvider implements LocalProvider {
  final Box<Movie> _moviesBox = Hive.box('movies');
  final Box<Genre> _genresBox = Hive.box('genres');
  final _logger = FimberLog((HiveProvider).toString());

  // @override
  // Future getDetails() async {
  //   return;
  // }

  @override
  Future<List<Genre>?> getGenres() async {
    _logger.d("Retrieving local genres");
    return _genresBox.values.toList();
  }

  @override
  Future<List<Movie>?> getMovies(int page) async {
    _logger.d("Retrieving local movies");
    return _moviesBox.values.skip((page - 1)*20).take(20).toList();
  }

  @override
  void storeGenres(List<Genre> genres) {
    _genresBox.putAll({ for (Genre genre in genres) genre.id : genre});
  }

  @override
  void storeMovies(List<Movie> movies) {
    _moviesBox.putAll({ for (Movie movie in movies) movie.id : movie});
  }
}