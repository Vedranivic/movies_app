/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';

/// Custom [BlocObserver] that observes all bloc and cubit state changes.
class AppBlocObserver extends BlocObserver {
  final _logger = FimberLog((AppBlocObserver).toString());

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    _logger.v("Created bloc: $bloc");
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    _logger.v(transition.toString());
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    _logger.v("Closing bloc: $bloc");
  }
}