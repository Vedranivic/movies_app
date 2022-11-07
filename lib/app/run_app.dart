/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movies_app/blocs/movies_bloc/movies_bloc.dart';
import 'package:movies_app/common/colors.dart';
import 'package:movies_app/models/genre.dart';
import 'package:movies_app/models/movie.dart';
import 'package:movies_app/resources/providers/hive_provider.dart';
import 'package:movies_app/resources/providers/tmdb_api_provider.dart';
import 'package:movies_app/resources/repositories/movies_repository.dart';
import 'package:movies_app/ui/screens/movies_home.dart';

import 'app_bloc_observer.dart';
import 'app_format_tree.dart';

/// runApp with app customizations
void runMoviesApp() async {
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  // Global logging setup
  Fimber.plantTree(AppFormatTree());
  // Setting global BLoC observer
  Bloc.observer = AppBlocObserver();
  // Setup of Hive DB
  await _initializeHiveDB();
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

Future _initializeHiveDB() async {
  // Initialize Hive DB to a valid directory
  await Hive.initFlutter();
  // Register Type Adapters
  Hive.registerAdapter(MovieAdapter());
  Hive.registerAdapter(GenreAdapter());
  // Opening Data Boxes
  await Hive.openBox<Genre>('genres');
  await Hive.openBox<Movie>('movies');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Movies App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: appScaffoldBackgroundColor,
            primaryColor: appPrimaryColor,
            textTheme: Theme.of(context).textTheme.apply(
              bodyColor: appTextColor,
              displayColor: appTextColor,
              fontFamily: 'SFProDisplay',
            )
        ),
        home: RepositoryProvider(
          create: (context) => MoviesRepository(
            remoteProvider: TMDBApiProvider(),
            localProvider: HiveProvider()
          ),
          child: BlocProvider(
            create: (BuildContext context) => MoviesBloc(
                moviesRepository: RepositoryProvider.of<MoviesRepository>(context)
            ),
            child: const MoviesHome(),
          ),
        )
    );
  }
}