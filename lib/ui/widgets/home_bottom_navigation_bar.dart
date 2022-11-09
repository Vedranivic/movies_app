/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'package:flutter/material.dart';

import '../../common/colors.dart';
import 'home_tab.dart';

/// Custom implementation of the [Scaffold.bottomNavigationBar] widget
class HomeBottomNavigationBar extends StatelessWidget {
  const HomeBottomNavigationBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: navigationBarColor,
      child: const TabBar(
        indicatorSize: TabBarIndicatorSize.label,
        indicator: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: appPrimaryColor,
              width: 2,
            ),
          ),
        ),
        unselectedLabelColor: appTextColor,
        labelColor: appPrimaryColor,
        tabs: [
          HomeTab(
            label: 'Movies',
            icon: Icon(Icons.movie_outlined),
          ),
          HomeTab(
            label: 'Favourites',
            icon: Icon(Icons.bookmark_added_outlined),
          ),
        ],
      ),
    );
  }
}