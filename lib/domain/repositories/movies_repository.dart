/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'package:fimber/fimber.dart';
import 'package:movies_app/models/movie_detail.dart';

import '../../models/genre.dart';
import '../../models/movie.dart';
import '../interfaces/local_provider.dart';
import '../interfaces/remote_provider.dart';

/// Domain repository for handling movie-related data
class MoviesRepository {
  /// Abstracting remote provider of the data
  final RemoteProvider _remoteProvider;
  /// Abstracting local provider of the data
  final LocalProvider _localProvider;
  final _logger = FimberLog((MoviesRepository).toString());

  MoviesRepository({required RemoteProvider remoteProvider, required LocalProvider localProvider})
    : _remoteProvider = remoteProvider, _localProvider = localProvider;

  /// Returns a batch of movies List<Movie> for specific page. By default it fetches remote network data and if
  /// successful updates the cached (local database) movies. It then returns the updated list of cached movies
  /// as a result. For remote movie data the [Movie.genres] are mapped with [MovieRepository.getGenres()]
  Future<List<Movie>?> getPopularMovies(int page) async {
    List<Movie>? movies = await _remoteProvider.getMovies(page);
    if(movies != null){
      List<Genre>? genres = await getGenres();
      if(genres != null){
        _mapMovieGenres(genres, movies);
      }
      await _localProvider.storeMovies(movies);
    }
    movies = await _localProvider.getMovies(page);
    // _logger.d("Movies: ${movies?.map((e) => e.title)}");
    _logger.d("Movies: ${movies?.length}");
    return movies;
  }

  /// Gets a cached list of genres from local provider. If none is stored, it fetches the data from remote provider
  /// and stores it in local database for future calls.
  Future<List<Genre>?> getGenres() async {
    List<Genre>? genres = await _localProvider.getGenres();
    if(genres == null || genres.isEmpty){
      genres = await _remoteProvider.getGenres();
      if(genres != null){
        _localProvider.storeGenres(genres);
      }
    }
    // _logger.d("Genres: $genres");
    return genres;
  }

  /// Gets [MovieDetail] for a movie using remote provider by default. If it fails it will return the cached movie data
  /// from local provider as [MovieDetails.fromMovie]
  Future<MovieDetail?> getMovieDetails(int id) async {
    MovieDetail? movie = await _remoteProvider.getMovieDetails(id);
    movie ??= await _localProvider.getMovieDetails(id);
    return movie;
  }

  void toggleFavourite(int movieId, bool isFavourite) {
    _localProvider.toggleFavourite(movieId, isFavourite);
  }

  Stream<List<Movie>> getMoviesStream(){
    return _localProvider.getMoviesStream();
  }

  Stream<List<Movie>> getFavouritesStream(){
    return _localProvider.getFavouritesStream();
  }

  /// Associate the genre ids with the genre names
  _mapMovieGenres(List<Genre> genres, List<Movie> movies) {
    for (Movie movie in movies) {
      movie.genres = movie.genreIds?.map((genreId) =>
          genres.firstWhere((genre) => genre.id == genreId)
      ).toList();
    }
  }
}