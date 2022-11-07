/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies_app/blocs/movie_details_bloc/movie_details_bloc.dart';
import 'package:movies_app/blocs/movies_bloc/movies_bloc.dart';
import 'package:movies_app/common/endpoints.dart';
import 'package:movies_app/common/styles.dart';
import 'package:movies_app/resources/repositories/movies_repository.dart';
import 'package:movies_app/ui/widgets/movie_rating.dart';

import '../../common/colors.dart';
import '../../models/movie.dart';
import '../screens/movie_details.dart';

class MovieListTile extends StatefulWidget {
  const MovieListTile(this.movie, {Key? key}) : super(key: key);
  final Movie movie;

  @override
  State<MovieListTile> createState() => _MovieListTileState();
}

class _MovieListTileState extends State<MovieListTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showMovieDetails,
      child: Container(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              "$tmdbImageBaseUrl${widget.movie.posterPath ?? ""}",
              fit: BoxFit.cover,
              height: 100,
              width: 100,
              errorBuilder: ((context, error, stackTrace) => DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: primaryFaded)
                ),
                child: const SizedBox(
                  height: 100,
                  width: 100,
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: primaryFaded,
                    ),
                  ),
                ),
              )),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.movie.title! + " " + widget.movie.popularity!.toString(),
                      style: itemTitleTextStyle,
                    ),
                    const SizedBox(height: 4,),
                    MovieRating(widget.movie.voteAverage!),
                    const SizedBox(height: 12,),
                    Wrap(
                      direction: Axis.horizontal,
                      spacing: 4,
                      runSpacing: 4,
                      children: widget.movie.genres!.map((genre) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: primaryFaded,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        child: Text(
                          genre.name!,
                          style: tagTextStyle,
                        ),
                      )).toList(),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showMovieDetails() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: ((context) => BlocProvider<MovieDetailsBloc>(
              create: (context) => MovieDetailsBloc(
                RepositoryProvider.of<MoviesRepository>(this.context)
              ),
              child: MovieDetails(widget.movie),
          ))
      )
    );
  }
}
