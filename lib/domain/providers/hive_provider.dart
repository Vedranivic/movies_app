/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'package:fimber/fimber.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';

import '../../common/endpoints.dart';
import '../../models/genre.dart';
import '../../models/movie.dart';
import '../../models/movie_detail.dart';
import '../interfaces/local_provider.dart';

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
        // Prevent unnecessary stream updates (e.g. putAll((N)elements) triggers (N) BoxEvents)
        .throttleTime(const Duration(milliseconds: 1))
        // Emit starting value using RxDart (there is none with Hive watch by default)
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
  void toggleFavourite(int movieId, bool isFavourite) {
    _moviesBox.get(movieId)
        ?..isFavourite = isFavourite
        ..save();
  }

  List<Movie> _getAllMoviesSorted(){
    List<Movie> movies = _moviesBox.values.toList();
    movies.sort((a, b) => b.popularity!.compareTo(a.popularity!));
    _logger.v("Total local movies: ${movies.length}");
    return movies;
  }

}