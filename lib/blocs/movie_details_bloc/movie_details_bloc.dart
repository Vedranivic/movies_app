/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movies_app/domain/repositories/movies_repository.dart';

import '../../models/movie_detail.dart';

part 'movie_details_event.dart';
part 'movie_details_state.dart';

/// BLoC component for Movie details view
class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final MoviesRepository _moviesRepository;

  MovieDetailsBloc(this._moviesRepository) : super(MovieDetailsInitial()) {
    on<MovieDetailsStarted>(_getMovieDetails);
  }

  FutureOr<void> _getMovieDetails(MovieDetailsStarted event, Emitter<MovieDetailsState> emit) async {
    MovieDetail? movieDetail = await _moviesRepository.getMovieDetails(event.movieId);
    if(movieDetail != null) {
      emit(MovieDetailsFetched(movieDetail));
    } else {
      emit(MovieDetailsFetchFailure());
    }
  }
}
