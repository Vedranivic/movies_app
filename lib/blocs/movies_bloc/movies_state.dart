/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

part of 'movies_bloc.dart';

abstract class MoviesState extends Equatable {
  const MoviesState();
}

class MoviesInitial extends MoviesState {
  @override
  List<Object> get props => [];
}

class MoviesFetchInProgress extends MoviesState {
  @override
  List<Object> get props => [];
}

class MoviesFetchSuccess extends MoviesState {
  final List<Movie> movies;
  final bool hasReachedMaxPage;

  const MoviesFetchSuccess(this.movies, this.hasReachedMaxPage);

  @override
  List<Object> get props => [movies, hasReachedMaxPage];
}

class MoviesFetchFailure extends MoviesState {
  final String message;

  const MoviesFetchFailure(this.message);

  @override
  List<Object> get props => [message];
}

// class MoviesScrollToTop extends MoviesState {
//   @override
//   List<Object> get props => [];
// }


