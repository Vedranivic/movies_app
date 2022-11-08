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
