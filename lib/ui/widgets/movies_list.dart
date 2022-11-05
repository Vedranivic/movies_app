/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'package:flutter/material.dart';
import 'package:movies_app/ui/widgets/movie_list_tile.dart';

import '../../models/movie.dart';

class MoviesList extends StatefulWidget {
  const MoviesList(this.movies, {Key? key}) : super(key: key);
  final List<Movie> movies;

  @override
  State<MoviesList> createState() => _MoviesListState();
}

class _MoviesListState extends State<MoviesList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: widget.movies.length,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index){
            return MovieListTile(widget.movies[index]);
          }
      ),
    );
  }
}
