/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../common/styles.dart';

class MovieRating extends StatelessWidget {
  const MovieRating(this.rating, {Key? key,}) : super(key: key);
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset("assets/images/star_black_24dp.svg"),
        SizedBox(width: 4,),
        Text(
          "${rating.toString()} / 10 IMDb",
          style: ratingTextStyle,
        )
      ],
    );
  }
}