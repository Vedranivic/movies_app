/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

part of 'movies_bloc.dart';

abstract class MoviesEvent extends Equatable {
  const MoviesEvent();
}

class MoviesFetchRequested extends MoviesEvent {

  @override
  List<Object?> get props => [];
}

// class MoviesScrollToTopPressed extends MoviesEvent {
//   @override
//   List<Object?> get props => [];
// }