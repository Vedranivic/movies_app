/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'package:flutter/material.dart';
import 'package:movies_app/common/colors.dart';
import 'package:movies_app/common/styles.dart';
import 'package:movies_app/ui/widgets/movies_list.dart';

class MoviesHome extends StatefulWidget {
  const MoviesHome({Key? key}) : super(key: key);

  @override
  State<MoviesHome> createState() => _MoviesHomeState();
}

class _MoviesHomeState extends State<MoviesHome> {
  @override
  Widget build(BuildContext context) {
    print(DefaultTextStyle.of(context).style.fontFamily);
    print(Theme.of(context).textTheme.headline5!.fontFamily);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 28
                ),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/img-logo.png",
                      height: 28,
                      width: 28,
                    )
                  ],
                ),
              ),
              Text(
                "Popular",
                style: titleTextStyle,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: MoviesList(List.generate(10, (index) => index + 1)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
