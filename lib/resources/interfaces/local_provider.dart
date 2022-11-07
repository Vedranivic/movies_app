/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'package:movies_app/resources/interfaces/data_provider.dart';

import '../../models/genre.dart';
import '../../models/movie.dart';

abstract class LocalProvider extends DataProvider {
  void storeGenres(List<Genre> genres);
  void storeMovies(List<Movie> movies);
}