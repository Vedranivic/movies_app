/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'package:movies_app/resources/providers/tmdb_api_provider.dart';

import '../../models/genre.dart';
import '../../models/movie.dart';

class MoviesRepository {
  TMDBApiProvider _tmdbApiProvider = TMDBApiProvider();

  Future<List<Genre>?> getGenres() async {
    Map? data = await _tmdbApiProvider.fetchGenres();
    if(data == null || data["genres"] == null){
      return null;
    }
    return (data["genres"] as List<dynamic>).map((item) => Genre.fromJson(item)).toList();
  }

  Future<List<Movie>?> getPopularMovies() async {
    Map? data = await _tmdbApiProvider.fetchPopularMovies();
    if(data == null || data["results"] == null){
      return null;
    }
    List<Genre>? genres = await getGenres();
    return (data["results"] as List<dynamic>).map((item) {
      Movie movie = Movie.fromJson(item);
      movie.genres = movie.genreIds!.map((id) => genres!.firstWhere((genre) => genre.id == id)).toList();
      return movie;
    }).toList();
  }
}