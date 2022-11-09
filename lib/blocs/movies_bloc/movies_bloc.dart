/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/endpoints.dart';
import '../../domain/repositories/movies_repository.dart';
import '../../models/movie.dart';

part 'movies_event.dart';
part 'movies_state.dart';

/// BLoC component for Movies Overview
class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  /// Main app repository for handling movie-related data
  final MoviesRepository _moviesRepository;
  final _logger = FimberLog((MoviesBloc).toString());
  /// Current page number - used for proper pagination and to keep the data updates in sync
  int currentPage = 0;

  MoviesBloc({required MoviesRepository moviesRepository}) :
        _moviesRepository = moviesRepository,
        super(MoviesInitial()) {

    on<MoviesStarted>(_handleMoviesStarted);
    on<MoviesFetchRequested>(_handleMovieFetchRequested);
    on<MoviesRefresh>(_refreshMovieList);
  }

  /// Initially the bloc is subscribed to the stream of Movies from repository to listen for changes of the data
  /// This is used for [Movie.isFavourite] updating (adding and removing Favourites)
  /// The actual list of movie data is retrieved using pagination and [MovieFetchRequested] event
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

  /// Handles the [MovieFetchRequested] event to retrieve batch of movie data for the requested page. If the call is
  /// successful the [currentPage] is increased and [MovieFetchSuccess] with concatenated movie data is emitted
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

  /// Handles the [MovieRefresh] event to retrieve the first (initial) data and reset the [currentPage].
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
