/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import '../../models/genre.dart';
import '../../models/movie.dart';
import 'data_provider.dart';

/// Local provider data specific interface
abstract class LocalProvider extends DataProvider {
  void storeGenres(List<Genre> genres);
  Future<void> storeMovies(List<Movie> movies);
  void toggleFavourite(int movieId, bool isFavourite);
  Stream<List<Movie>> getMoviesStream();
  Stream<List<Movie>> getFavouritesStream();
}