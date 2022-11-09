/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'package:flutter/material.dart';

import '../../common/styles.dart';

/// Customization of the [Tab] widget
class HomeTab extends StatelessWidget {
  final String label;
  final Icon icon;
  const HomeTab({required this.label, required this.icon, Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: SizedBox(
        width: 110,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: 10,),
            Text(
              label,
              style: tabLabelTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}