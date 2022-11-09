/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import 'genre.dart';

part 'movie.g.dart';

/// Movie data model
@HiveType(typeId: 2)
class Movie with EquatableMixin, HiveObjectMixin{
  @HiveField(0)
  bool? adult;
  @HiveField(1)
  String? backdropPath;
  @HiveField(2)
  List<int>? genreIds;
  @HiveField(3)
  List<Genre>? genres;
  @HiveField(4)
  int? id;
  @HiveField(5)
  String? originalLanguage;
  @HiveField(6)
  String? originalTitle;
  @HiveField(7)
  String? overview;
  @HiveField(8)
  double? popularity;
  @HiveField(9)
  String? posterPath;
  @HiveField(10)
  String? releaseDate;
  @HiveField(11)
  String? title;
  @HiveField(12)
  bool? video;
  @HiveField(13)
  double? voteAverage;
  @HiveField(14)
  int? voteCount;
  @HiveField(15)
  bool isFavourite;

  Movie(
      {this.adult,
        this.backdropPath,
        this.genreIds,
        this.id,
        this.originalLanguage,
        this.originalTitle,
        this.overview,
        this.popularity,
        this.posterPath,
        this.releaseDate,
        this.title,
        this.video,
        this.voteAverage,
        this.voteCount,
        this.isFavourite = false});

  Movie.fromJson(Map<String, dynamic> json) : isFavourite = false {
    adult = json['adult'];
    backdropPath = json['backdrop_path'];
    genreIds = json['genre_ids'].cast<int>();
    id = json['id'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    overview = json['overview'];
    popularity = json['popularity'].toDouble();
    posterPath = json['poster_path'];
    releaseDate = json['release_date'];
    title = json['title'];
    video = json['video'];
    voteAverage = json['vote_average'].toDouble();
    voteCount = json['vote_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['adult'] = adult;
    data['backdrop_path'] = backdropPath;
    data['genre_ids'] = genreIds;
    data['id'] = id;
    data['original_language'] = originalLanguage;
    data['original_title'] = originalTitle;
    data['overview'] = overview;
    data['popularity'] = popularity;
    data['poster_path'] = posterPath;
    data['release_date'] = releaseDate;
    data['title'] = title;
    data['video'] = video;
    data['vote_average'] = voteAverage;
    data['vote_count'] = voteCount;
    return data;
  }

  @override
  List<Object> get props => [id!, title!, voteAverage!, isFavourite, genreIds!, genres!, posterPath!, overview!];
}
