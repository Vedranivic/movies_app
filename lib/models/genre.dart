/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'genre.g.dart';

@HiveType(typeId: 1)
class Genre with EquatableMixin, HiveObjectMixin {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;

  Genre({this.id, this.name});

  Genre.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }

  @override
  List<Object> get props => [id!, name!];
}