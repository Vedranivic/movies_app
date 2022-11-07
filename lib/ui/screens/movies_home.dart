/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/blocs/movies_bloc/movies_bloc.dart';
import 'package:movies_app/common/styles.dart';
import 'package:movies_app/ui/widgets/movies_list.dart';

class MoviesHome extends StatefulWidget {
  const MoviesHome({Key? key}) : super(key: key);

  @override
  State<MoviesHome> createState() => _MoviesHomeState();
}

class _MoviesHomeState extends State<MoviesHome> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MoviesBloc>(context).add(MoviesFetchRequested([]));
  }

  @override
  Widget build(BuildContext context) {
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
                  child: BlocConsumer<MoviesBloc, MoviesState>(
                    listener: (context, state) {
                      if(state is MoviesFetchFailure){
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                            )
                        );
                      }
                    },
                    builder: (context, state) {
                      if(state is MoviesInitial){
                        return const Center(
                          child: CircularProgressIndicator()
                        );
                      }
                      if(state is MoviesFetchSuccess){
                        return MoviesList(movies: state.movies, hasReachedMaxPage: state.hasReachedMaxPage,);
                      } else {
                        return const MoviesList(movies: [], hasReachedMaxPage: true,);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
