/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'package:fimber/fimber.dart';
import 'package:movies_app/resources/interfaces/local_provider.dart';
import 'package:movies_app/resources/interfaces/remote_provider.dart';

import '../../models/genre.dart';
import '../../models/movie.dart';

class MoviesRepository {
  final RemoteProvider _remoteProvider;
  final LocalProvider _localProvider;
  final _logger = FimberLog((MoviesRepository).toString());

  MoviesRepository({required RemoteProvider remoteProvider, required LocalProvider localProvider})
    : _remoteProvider = remoteProvider, _localProvider = localProvider;

  Future<List<Genre>?> getGenres() async {
    List<Genre>? genres = await _localProvider.getGenres();
    if(genres == null || genres.isEmpty){
      genres = await _remoteProvider.getGenres();
      if(genres != null){
        _localProvider.storeGenres(genres);
      }
    }
    _logger.d("Genres: $genres");
    return genres;
  }

  Future<List<Movie>?> getPopularMovies(int page) async {
    List<Movie>? movies; //= await _localProvider.getMovies(page);
    if(movies == null || movies.isEmpty){
      movies = await _remoteProvider.getMovies(page);
      if(movies != null){
        List<Genre>? genres = await getGenres();
        if(genres != null){
          _mapMovieGenres(genres, movies);
        }
        // _localProvider.storeMovies(movies);
      }
    }
    _logger.d("Movies: $movies");
    return movies;
  }

  _mapMovieGenres(List<Genre> genres, List<Movie> movies) {
    for (Movie movie in movies) {
      movie.genres = movie.genreIds?.map((genreId) =>
          genres.firstWhere((genre) => genre.id == genreId)
      ).toList();
    }
  }
}