/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

part of 'favourites_bloc.dart';

abstract class FavouritesState extends Equatable {
  const FavouritesState();
}

class FavouritesInitial extends FavouritesState {
  @override
  List<Object> get props => [];
}

class FavouritesFetchSuccess extends FavouritesState {
  final Stream<List<Movie>> favourites;

  const FavouritesFetchSuccess(this.favourites);

  @override
  List<Object> get props => [favourites];
}

class FavouritesFailure extends FavouritesState {
  final String message;

  const FavouritesFailure(this.message);

  @override
  List<Object> get props => [message];
}