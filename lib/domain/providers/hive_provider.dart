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

/// Local source provider - [DB] database using [Hive] package
class HiveProvider implements LocalProvider {
  // Box for storing movies
  final Box<Movie> _moviesBox = Hive.box('movies');
  // Box for storing genres
  final Box<Genre> _genresBox = Hive.box('genres');
  final _logger = FimberLog((HiveProvider).toString());

  @override
  Future<List<Genre>?> getGenres() async {
    _logger.d("Retrieving local genres");
    return _genresBox.values.toList();
  }

  /// Fetch movies by pagination (in batches of endpoint API's [apiBatchSize])
  /// The movies are sorted by popularity to reflect on the Popular movies overview
  @override
  Future<List<Movie>?> getMovies(int page) async {
    _logger.d("Retrieving local movies");
    return _getAllMoviesSorted().skip((page - 1)*apiBatchSize).take(apiBatchSize).toList();
  }

  /// Stream of [List<Movie>] data from local database that returns all movies on a BoxEvent, i.e. a change in the DB,
  /// starting with the initial list of all movies from DB.
  /// To prevent unnecessary triggering of Box Events and stream events on storing multiple movies, a [throttleTime]
  /// has been added to filter single DB events only
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

  /// Stream of all favourite movies ([Movie.isFavourite] == true) from local DB
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

  /// Store movies into DB using [Movie.id] as key to keep the same movie in the DB and simply update its values
  /// on new data storing (not creating new one with e.g. autoincrement keys from Hive)
  /// When storing/updating value from network, the [Movie.isFavourite] gets overriden hence it is preserved explicitly
  @override
  Future<void> storeMovies(List<Movie> movies) async {
    _logger.d("Storing local movies ${movies.length}");
    // Preserving favourite state
    movies = movies.map((movie) => movie..isFavourite = _moviesBox.get(movie.id)?.isFavourite ?? movie.isFavourite).toList();
    // Put into box using movie.id as key
    await _moviesBox.putAll({ for (Movie movie in movies) movie.id : movie});
    _logger.d("Total movies in storage: ${_moviesBox.length}");
  }

  /// Toggle [Movie.isFavourite] field used to get Favourite movies list
  @override
  void toggleFavourite(int movieId, bool isFavourite) {
    _moviesBox.get(movieId)
        ?..isFavourite = isFavourite
        ..save();
  }

  /// Gets all movies from DB sorted by popularity [Movie.popularity]
  List<Movie> _getAllMoviesSorted(){
    List<Movie> movies = _moviesBox.values.toList();
    movies.sort((a, b) => b.popularity!.compareTo(a.popularity!));
    _logger.v("Total local movies: ${movies.length}");
    return movies;
  }

}