/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/resources/repositories/movies_repository.dart';

import '../../models/movie.dart';

part 'movies_event.dart';
part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final MoviesRepository _moviesRepository;

  MoviesBloc({required MoviesRepository moviesRepository}) :
        _moviesRepository = moviesRepository,
        super(MoviesInitial()) {

    on<MoviesStarted>(_getPopularMovies);
  }

  FutureOr<void> _getPopularMovies(MoviesStarted event, Emitter<MoviesState> emit) async {
    emit(MoviesFetchInProgress());
    List<Movie>? movies = await _moviesRepository.getPopularMovies();
    if(movies != null && movies.length > 0){
      await Future.delayed(Duration(seconds: 1));
      emit(MoviesFetchSuccess(movies));
    } else {
      emit(MoviesFetchFailure("Failed to fetch movie data"));
    }
  }
}
