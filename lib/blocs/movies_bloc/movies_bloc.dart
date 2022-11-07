/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/resources/repositories/movies_repository.dart';

import '../../models/genre.dart';
import '../../models/movie.dart';

part 'movies_event.dart';
part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final MoviesRepository _moviesRepository;
  int currentPage = 0;

  MoviesBloc({required MoviesRepository moviesRepository}) :
        _moviesRepository = moviesRepository,
        super(MoviesInitial()) {

    on<MoviesFetchRequested>(_handleMovieFetchRequested);
    // on<MoviesScrollToTopPressed>(_onScrollToTop);
  }

  FutureOr<void> _handleMovieFetchRequested(MoviesFetchRequested event, Emitter<MoviesState> emit) async {
    final MoviesState currentState = state;
    if(currentState is MoviesFetchSuccess){
      if(currentState.hasReachedMaxPage) {
        return;
      }
    }
    // emit(MoviesFetchInProgress());
    List<Movie>? movies = await _moviesRepository.getPopularMovies(currentPage + 1);
    if(movies != null){
      // await Future.delayed(Duration(seconds: 2));
      emit(currentState is MoviesFetchSuccess ?
          MoviesFetchSuccess(List.of(currentState.movies)..addAll(movies), movies.isEmpty)
          : MoviesFetchSuccess(movies, false));
      currentPage++;
    } else {
      emit(MoviesFetchFailure("Failed to fetch movie data"));
    }
  }

  // FutureOr<void> _onScrollToTop(MoviesScrollToTopPressed event, Emitter<MoviesState> emit) {
  //   emit(MoviesScrollToTop());
  // }
}
