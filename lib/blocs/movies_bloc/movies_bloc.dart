/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/endpoints.dart';
import '../../models/movie.dart';
import '../../resources/repositories/movies_repository.dart';

part 'movies_event.dart';
part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final MoviesRepository _moviesRepository;
  final _logger = FimberLog((MoviesBloc).toString());
  int currentPage = 0;

  MoviesBloc({required MoviesRepository moviesRepository}) :
        _moviesRepository = moviesRepository,
        super(MoviesInitial()) {

    on<MoviesStarted>(_handleMoviesStarted);
    on<MoviesFetchRequested>(_handleMovieFetchRequested);
    on<MoviesRefresh>(_refreshMovieList);
  }

  Future<FutureOr<void>> _handleMoviesStarted(MoviesStarted event, Emitter<MoviesState> emit) async {
    // Subscribes to movie stream for data updates (favourites changes) and manages the subscription internally.
    await emit.forEach(
      // Skip initial data (the '.startWith' specified in the movieStream providing code)
      _moviesRepository.getMoviesStream().skipWhile((event) => currentPage < 1),
      onData: (movies) {
        _logger.d("Number of favs: ${movies.where((element) => element.isFavourite).length}");
        _logger.d("Current page: $currentPage");
        return MoviesFetchSuccess(movies.take(currentPage*apiBatchSize).toList(), movies.isEmpty);
      },
    );
  }

  FutureOr<void> _handleMovieFetchRequested(MoviesFetchRequested event, Emitter<MoviesState> emit) async {
    final MoviesState currentState = state;
    if(currentState is MoviesFetchSuccess){
      if(currentState.hasReachedMaxPage) {
        return;
      }
    }

    // Fetch popular movies with pagination
    List<Movie>? movies = await _moviesRepository.getPopularMovies(currentPage+1);
    if(movies != null){
      emit(MoviesFetchSuccess(List.of(event.currentMovieList)..addAll(movies), movies.isEmpty));
      //Increase page on successful fetch only
      currentPage++;
    } else {
      emit(const MoviesFetchFailure("Failed to fetch movie data"));
    }
  }

  // }

  FutureOr<void> _refreshMovieList(MoviesRefresh event, Emitter<MoviesState> emit) async {
    currentPage = 0;
    List<Movie>? movies = await _moviesRepository.getPopularMovies(currentPage+1);
    if(movies != null){
      emit(MoviesFetchSuccess(movies, movies.isEmpty));
      //Increase page on successful fetch only
      currentPage++;
    } else {
      emit(const MoviesFetchFailure("Failed to fetch movie data"));
    }
  }
}
