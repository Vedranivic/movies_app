/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved. 
 * This file is part of movies_app Flutter application project.
 */

import '../../models/genre.dart';
import '../../models/movie.dart';
import '../../models/movie_detail.dart';

/// Interface for general Data provider
abstract class DataProvider {
  Future<List<Movie>?> getMovies(int page);
  Future<List<Genre>?> getGenres();
  Future<MovieDetail?> getMovieDetails(int id);
}