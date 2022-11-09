/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/common/colors.dart';

import '../../../blocs/connectivity/connectivity_bloc.dart';
import '../../../blocs/movies_bloc/movies_bloc.dart';
import '../../widgets/home_bottom_navigation_bar.dart';
import '../../widgets/offline_notification_icon.dart';
import 'favourites/favourites_tab_view.dart';
import 'overview/movies_tab_view.dart';

class MoviesHome extends StatefulWidget {
  const MoviesHome({Key? key}) : super(key: key);

  @override
  State<MoviesHome> createState() => _MoviesHomeState();
}

class _MoviesHomeState extends State<MoviesHome> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MoviesBloc>(context)
      ..add(MoviesStarted())..add(const MoviesFetchRequested([]));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityBloc, ConnectivityState>(
      listener: (context, state) {
        if(state is ConnectivityDisConnected){
          _showOfflineNotification();
        }
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          bottomNavigationBar: const HomeBottomNavigationBar(),
          body: SafeArea(
            // top: false,
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          "assets/images/img-logo.png",
                          height: 28,
                          width: 28,
                        ),
                        const OfflineNotificationIcon()
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      // physics: NeverScrollableScrollPhysics(),
                      children: [
                        MoviesTabView(),
                        const FavouritesTabView(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showOfflineNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(
                Icons.wifi_off,
                color: appTextColor,
              ),
              SizedBox(width: 8,),
              Text("You are currently offline"),
            ],
          ),
        )
    );
  }
}
