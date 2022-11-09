/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/connectivity/connectivity_bloc.dart';
import '../../common/colors.dart';

/// Custom offline status (no connectivity) indicator widget
class OfflineNotificationIcon extends StatelessWidget {
  const OfflineNotificationIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      builder: (context, state) {
        if(state is ConnectivityDisConnected) {
          return const Icon(
            Icons.wifi_off,
            color: primaryFaded,
            size: 28,
          );
        }
        return const SizedBox();
      },
    );
  }
}