/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movies_app/blocs/movie_details_bloc/movie_details_bloc.dart';
import 'package:movies_app/common/endpoints.dart';

import '../../../blocs/favourites/favourites_bloc.dart';
import '../../../common/colors.dart';
import '../../../common/styles.dart';
import '../../../models/movie.dart';
import '../../widgets/movie_rating.dart';

/// Movie Details View for displaying [MovieDetails] data model
class MovieDetails extends StatefulWidget {
  const MovieDetails(this.movie, {Key? key}) : super(key: key);
  final Movie movie;

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MovieDetailsBloc>(context).add(MovieDetailsStarted(widget.movie.id!));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MovieDetailsBloc, MovieDetailsState>(
      listener: (context, state) {
        if(state is MovieDetailsFetchFailure){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to get movie details"),
            )
          );
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        if(state is MovieDetailsFetched){
          return Scaffold(
            bottomSheet: Container(
              padding: const EdgeInsets.only(top: 28, bottom: 43, left: 20, right: 20),
              decoration: const BoxDecoration(
                color: appScaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          state.movie.title!,
                          style: detailsTitleTextStyle,
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: IconButton(
                          splashColor: favouriteSplashColor,
                          highlightColor: favouriteSplashColor,
                          splashRadius: 24,
                          icon: Icon(
                            widget.movie.isFavourite ? Icons.bookmark_added : Icons.bookmark_outline,
                            color: widget.movie.isFavourite ? appPrimaryColor : appTextColor,
                          ),
                          onPressed: (){
                            BlocProvider.of<FavouritesBloc>(context).add(
                                FavouritesUpdate(widget.movie.id!, !widget.movie.isFavourite)
                            );
                            setState(() {
                              widget.movie.isFavourite = !widget.movie.isFavourite;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8,),
                  MovieRating(state.movie.voteAverage!),
                  const SizedBox(height: 16,),
                  Wrap(
                    direction: Axis.horizontal,
                    spacing: 4,
                    runSpacing: 4,
                    children: state.movie.genres!.map((genre) =>
                        Container(
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: primaryFaded,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 12,
                          ),
                          child: Text(
                            genre.name!,
                            style: tagDetailsTextStyle,
                          ),
                        )).toList(),
                  ),
                  const SizedBox(height: 40,),
                  const Text(
                    "Description",
                    style: descLabelTextStyle,
                  ),
                  const SizedBox(height: 8,),
                  Text(
                    _convertToParagraphedDescription(state.movie.overview!),
                    style: descriptionTextStyle,
                  ),
                ],
              ),
            ),
            body: Stack(
              children: [
                Image.network(
                  "$tmdbImageBaseUrl${state.movie.posterPath ?? ""}",
                  fit: BoxFit.cover,
                  errorBuilder: ((context, error, stackTrace) =>
                  const SizedBox.expand(
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: primaryFaded,
                      ),
                    ),
                  )),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 28,
                        horizontal: 20
                    ),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: SvgPicture.asset(
                        "assets/images/arrow_right_alt_black_24dp.svg",
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        } else if (state is MovieDetailsInitial){
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Container();
        }
      },
    );
  }

  // Separate sentences into paragraphs
  String _convertToParagraphedDescription(String description) {
    return description.splitMapJoin(".",
        onMatch: (m) => m.end != m.input.length ? "${m[0]}\n\n" : "${m[0]}",
        onNonMatch: (s) => s.trim()
    );
  }
}

