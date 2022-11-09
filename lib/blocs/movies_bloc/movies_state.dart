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

class MoviesFetchSuccess extends MoviesState {
  final List<Movie> movies;
  final bool hasReachedMaxPage;

  const MoviesFetchSuccess(this.movies, this.hasReachedMaxPage);

  // @override
  // bool? get stringify => true;

  @override
  List<Object> get props => [identityHashCode(movies), hasReachedMaxPage];
}

class MoviesFailure extends MoviesState {
  final String message;

  const MoviesFailure(this.message);

  @override
  List<Object> get props => [identityHashCode(this)];
}

class MoviesFetchFailure extends MoviesFailure {
  final List<Movie> movies;

  const MoviesFetchFailure(String message, this.movies): super(message);

  @override
  List<Object> get props => [identityHashCode(this)];
}

