/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

/// BLoC component for Connectivity Monitoring using [Connectivity] plugin.
/// Provided at the top of the widget tree to be used where ever there is a need for connection status
class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  ConnectivityBloc() : super(ConnectivityInitial()) {
    on<ConnectivityStartedMonitoring>(_startMonitoring);
  }

  FutureOr<void> _startMonitoring(ConnectivityStartedMonitoring event, Emitter<ConnectivityState> emit) async {
    await emit.forEach(
        Connectivity().onConnectivityChanged,
        onData: (result) {
          if(result == ConnectivityResult.none){
            return ConnectivityDisConnected();
          } else if (result == ConnectivityResult.wifi || result == ConnectivityResult.mobile){
            return ConnectivityConnected();
          }
          return ConnectivityConnected();
        });
  }
}
