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

class MoviesRepository {
  final RemoteProvider _remoteProvider;
  final LocalProvider _localProvider;
  final _logger = FimberLog((MoviesRepository).toString());

  MoviesRepository({required RemoteProvider remoteProvider, required LocalProvider localProvider})
    : _remoteProvider = remoteProvider, _localProvider = localProvider;

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

  // Associate the genre ids with the genre names
  _mapMovieGenres(List<Genre> genres, List<Movie> movies) {
    for (Movie movie in movies) {
      movie.genres = movie.genreIds?.map((genreId) =>
          genres.firstWhere((genre) => genre.id == genreId)
      ).toList();
    }
  }
}