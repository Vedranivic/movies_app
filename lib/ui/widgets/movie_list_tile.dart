/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies_app/common/styles.dart';

import '../../common/colors.dart';
import '../../models/movie.dart';

class MovieListTile extends StatefulWidget {
  const MovieListTile(this.movie, {Key? key}) : super(key: key);
  final Movie movie;

  @override
  State<MovieListTile> createState() => _MovieListTileState();
}

class _MovieListTileState extends State<MovieListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            "https://image.tmdb.org/t/p/w500${widget.movie.posterPath ?? ""}",
            fit: BoxFit.cover,
            height: 100,
            width: 100,
            errorBuilder: ((context, error, stackTrace) => const SizedBox(
              height: 100,
              width: 100,
              child: Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: primaryFaded,
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
                    widget.movie.title!,
                    style: itemTitleTextStyle,
                  ),
                  SizedBox(height: 4,),
                  Row(
                    children: [
                      SvgPicture.asset("assets/images/star_black_24dp.svg"),
                      SizedBox(width: 4,),
                      Text(
                        "${widget.movie.voteAverage.toString()} / 10 IMDb",
                        style: ratingTextStyle,
                      )
                    ],
                  ),
                  SizedBox(height: 12,),
                  Wrap(
                    direction: Axis.horizontal,
                    spacing: 4,
                    runSpacing: 4,
                    children: List.generate(widget.movie.genreIds!.length, ((index) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: primaryFaded,
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                      ),
                      child: Text(
                        widget.movie.genres![index].name!,
                        style: tagTextStyle,
                      ),
                    ))
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
