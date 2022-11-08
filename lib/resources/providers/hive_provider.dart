/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'package:fimber/fimber.dart';
import 'package:hive/hive.dart';
import 'package:movies_app/common/endpoints.dart';
import 'package:movies_app/models/movie_detail.dart';
import 'package:movies_app/resources/interfaces/local_provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/genre.dart';
import '../../models/movie.dart';

/// Local source provider - [DB] database
class HiveProvider implements LocalProvider {
  final Box<Movie> _moviesBox = Hive.box('movies');
  final Box<Genre> _genresBox = Hive.box('genres');
  final _logger = FimberLog((HiveProvider).toString());

  @override
  Future<List<Genre>?> getGenres() async {
    _logger.d("Retrieving local genres");
    return _genresBox.values.toList();
  }

  @override
  Future<List<Movie>?> getMovies(int page) async {
    _logger.d("Retrieving local movies");
    return _getAllMoviesSorted().skip((page - 1)*apiBatchSize).take(apiBatchSize).toList();
  }

  @override
  Stream<List<Movie>> getMoviesStream() {
    _logger.d("Getting movies stream");
    return _moviesBox
        .watch()
        .map((event) => _getAllMoviesSorted())
        .startWith(_getAllMoviesSorted().toList());
  }

  @override
  Stream<List<Movie>> getFavouritesStream() {
    return getMoviesStream().map((movieList) => movieList.where((movie) => movie.isFavourite).toList());
  }

  @override
  Future<MovieDetail?> getMovieDetails(int id) async {
    _logger.d("Retrieving local movie, id: $id");
    Movie? movie = _moviesBox.get(id);
    if(movie != null){
      return MovieDetail.fromMovie(movie);
    }
    return null;
  }

  @override
  void storeGenres(List<Genre> genres) {
    _genresBox.putAll({ for (Genre genre in genres) genre.id : genre});
  }

  @override
  Future<void> storeMovies(List<Movie> movies) async {
    _logger.d("Storing local movies ${movies.length}");
    // Preserving favourite state
    movies = movies.map((movie) => movie..isFavourite = _moviesBox.get(movie.id)?.isFavourite ?? movie.isFavourite).toList();
    // Put into box using movie.id as key
    await _moviesBox.putAll({ for (Movie movie in movies) movie.id : movie});
    _logger.d("Total movies in storage: ${_moviesBox.length}");
  }

  @override
  void addFavourite(int movieId) {
    _moviesBox.get(movieId)
        ?..isFavourite = true
        ..save();
  }

  @override
  void removeFavourite(int movieId) async {
    _moviesBox.get(movieId)
        ?..isFavourite = false
        ..save();
  }

  List<Movie> _getAllMoviesSorted(){
    List<Movie> movies = _moviesBox.values.toList();
    movies.sort((a, b) => b.popularity!.compareTo(a.popularity!));
    _logger.v("Total local movies: ${movies.length}");
    return movies;
  }

}