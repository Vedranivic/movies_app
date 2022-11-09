/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

part of 'favourites_bloc.dart';

abstract class FavouritesEvent extends Equatable {
  const FavouritesEvent();
}

class FavouritesFetchRequested extends FavouritesEvent {

  @override
  List<Object?> get props => [];
}

class FavouritesUpdate extends FavouritesEvent {
  final int movieId;
  final bool isFavourite;

  const FavouritesUpdate(this.movieId, this.isFavourite);

  @override
  List<Object?> get props => [movieId, isFavourite];
}