/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

part of 'connectivity_bloc.dart';

abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();
}

class ConnectivityStartedMonitoring extends ConnectivityEvent {

  @override
  List<Object?> get props => [];
}
