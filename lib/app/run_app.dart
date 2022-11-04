/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/common/colors.dart';
import 'package:movies_app/ui/screens/movies_home.dart';

import 'app_bloc_observer.dart';
import 'app_format_tree.dart';

/// runApp with app customizations
void runMoviesApp(){
  // Global logging setup
  Fimber.plantTree(AppFormatTree());
  // Setting global BLoC observer
  Bloc.observer = AppBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies App',
      theme: ThemeData(
        scaffoldBackgroundColor: appScaffoldBackgroundColor,
        primaryColor: appPrimaryColor,
          textTheme: Theme.of(context).textTheme.apply(
            bodyColor: appTextColor,
            displayColor: appTextColor,
            fontFamily: 'SFProDisplay',
          )
      ),
      home: const MoviesHome()
    );
  }
}