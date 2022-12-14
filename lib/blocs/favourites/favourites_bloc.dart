/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:movies_app/domain/repositories/movies_repository.dart';

import '../../models/movie.dart';

part 'favourites_event.dart';
part 'favourites_state.dart';

/// BLoC component for Favourites View
class FavouritesBloc extends Bloc<FavouritesEvent, FavouritesState> {
  final MoviesRepository _moviesRepository;
  final _logger = FimberLog((FavouritesBloc).toString());

  FavouritesBloc({required MoviesRepository moviesRepository})
      : _moviesRepository = moviesRepository, super(FavouritesInitial()) {
    on<FavouritesFetchRequested>(_handleFavouritesFetch);
    on<FavouritesUpdate>(_toggleFavourite);
  }

  FutureOr<void> _handleFavouritesFetch(FavouritesFetchRequested event, Emitter<FavouritesState> emit) {
    try {
      emit(FavouritesFetchSuccess(_moviesRepository.getFavouritesStream()));
    } catch (e) {
      _logger.w("Error getting favourite movies");
      emit(const FavouritesFailure("Failed getting favourite movies"));
    }
  }

  FutureOr<void> _toggleFavourite(FavouritesUpdate event, Emitter<FavouritesState> emit) {
    try {
      _moviesRepository.toggleFavourite(event.movieId, event.isFavourite);
    } catch (e) {
      _logger.w("Error updating favourite");
      emit(FavouritesFailure("Failed ${event.isFavourite ? "adding" : "removing"} favourite"));
    }
  }
}
