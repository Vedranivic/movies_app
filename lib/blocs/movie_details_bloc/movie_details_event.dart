/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

part of 'movie_details_bloc.dart';

abstract class MovieDetailsEvent extends Equatable {
  const MovieDetailsEvent();
}

class MovieDetailsStarted extends MovieDetailsEvent {
  final int movieId;

  const MovieDetailsStarted(this.movieId);

  @override
  List<Object?> get props => [movieId];
}