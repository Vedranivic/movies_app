/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'package:fimber/fimber.dart';

/// Custom format implementation for [Fimber] logger
class AppFormatTree extends CustomFormatTree {
  AppFormatTree(){
    super.logFormat = "${CustomFormatTree.levelToken} ${CustomFormatTree.tagToken}: ${CustomFormatTree.messageToken}";
  }
}