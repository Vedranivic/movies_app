/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'package:flutter/material.dart';

/// Custom Page Route with [SlideTransition] transition animation
class AnimatedPageRoute<T> extends PageRouteBuilder<T> {
  AnimatedPageRoute({ required Widget Function(BuildContext) builder})
      : super(
      pageBuilder: ((context, animation, secondaryAnimation) => builder(context)
      ),
      transitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      }
  );
}