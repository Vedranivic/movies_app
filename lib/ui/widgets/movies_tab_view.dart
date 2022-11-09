/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/movies_bloc/movies_bloc.dart';
import '../../common/styles.dart';
import 'movies_list.dart';

class MoviesTabView extends StatelessWidget {
  MoviesTabView({Key? key,}) : super(key: key);
  final _logger = FimberLog((MoviesTabView).toString());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        const Text(
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
              buildWhen: (previous, current) => current is MoviesFetchSuccess,
              builder: (context, state) {
                if(state is MoviesInitial){
                  return const Center(
                      child: CircularProgressIndicator()
                  );
                } else if (state is MoviesFetchSuccess){
                  _logger.d("View movies: ${state.movies.length}");
                  return MoviesList(
                    movies: state.movies,
                    hasReachedMaxPage: state.hasReachedMaxPage,
                    pullToRefresh: true,
                  );
                }
                return const MoviesList(movies: [], pullToRefresh: true,);
              },
            ),
          ),
        ),
      ],
    );
  }
}