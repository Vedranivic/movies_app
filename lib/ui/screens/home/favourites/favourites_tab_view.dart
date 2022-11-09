/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/blocs/favourites/favourites_bloc.dart';

import '../../../../common/styles.dart';
import '../../../../models/movie.dart';
import '../../../widgets/movies_list.dart';

class FavouritesTabView extends StatefulWidget {
  const FavouritesTabView({Key? key,}) : super(key: key);

  @override
  State<FavouritesTabView> createState() => _FavouritesTabViewState();
}

class _FavouritesTabViewState extends State<FavouritesTabView> {
  
  @override
  void initState() {
    super.initState();
    BlocProvider.of<FavouritesBloc>(context).add(FavouritesFetchRequested());
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        const Text(
          "Favourites",
          style: titleTextStyle,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: BlocConsumer<FavouritesBloc, FavouritesState>(
              listener: (context, state) {
                if(state is FavouritesFailure){
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                      )
                  );
                }
              },
              builder: (context, state) {
                if(state is FavouritesInitial){
                  return const Center(
                      child: CircularProgressIndicator()
                  );
                }
                if(state is FavouritesFetchSuccess){
                  return StreamBuilder<List<Movie>>(
                    stream: state.favourites,
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.active
                          || snapshot.connectionState == ConnectionState.done){
                        if(snapshot.hasData){
                          return MoviesList(movies: snapshot.data!);
                        } else {
                          return Container();
                        }
                      } else if (snapshot.connectionState == ConnectionState.waiting){
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Container();
                      }
                    }
                  );
                } else {
                  return const MoviesList(movies: []);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}