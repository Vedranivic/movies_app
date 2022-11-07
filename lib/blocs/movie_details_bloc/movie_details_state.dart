/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

part of 'movie_details_bloc.dart';

abstract class MovieDetailsState extends Equatable {
  const MovieDetailsState();
}

class MovieDetailsInitial extends MovieDetailsState {
  @override
  List<Object> get props => [];
}

class MovieDetailsFetched extends MovieDetailsState {
  final MovieDetail movie;

  const MovieDetailsFetched(this.movie);

  @override
  List<Object> get props => [movie];
}

class MovieDetailsFetchFailure extends MovieDetailsState {
  @override
  List<Object> get props => [];
}