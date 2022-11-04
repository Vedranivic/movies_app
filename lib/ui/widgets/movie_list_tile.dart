/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../common/colors.dart';

class MovieListTile extends StatefulWidget {
  const MovieListTile({Key? key}) : super(key: key);

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
            "https://images.pexels.com/photos/213780/pexels-photo-213780.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
            fit: BoxFit.cover,
            height: 100,
            width: 100,
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
                    "Green Book",
                    style: TextStyle(
                      fontSize: 15,
                      height: 20/15,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  SizedBox(height: 4,),
                  Row(
                    children: [
                      SvgPicture.asset("assets/images/star_black_24dp.svg"),
                      SizedBox(width: 4,),
                      Text(
                        "8.2 / 10 IMDb",
                        style: TextStyle(
                          height: 16/12,
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 12,),
                  Wrap(
                    direction: Axis.horizontal,
                    spacing: 4,
                    runSpacing: 4,
                    children: List.generate(3, ((index) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: primaryFaded,
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                      ),
                      child: Text(
                        "Genre",
                        style: TextStyle(
                            fontFamily: 'SFPro',
                            fontSize: 11,
                            height: 13/11
                        ),
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
