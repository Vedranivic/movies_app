/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

part of 'connectivity_bloc.dart';

abstract class ConnectivityState extends Equatable {
  const ConnectivityState();
}

class ConnectivityInitial extends ConnectivityState {
  @override
  List<Object> get props => [];
}

class ConnectivityConnected extends ConnectivityState {
  @override
  List<Object> get props => [];
}

class ConnectivityDisConnected extends ConnectivityState {
  @override
  List<Object> get props => [];
}