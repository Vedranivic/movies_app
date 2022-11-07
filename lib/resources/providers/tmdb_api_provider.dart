/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'package:dio/dio.dart';
import 'package:fimber/fimber.dart';

import '../../models/genre.dart';
import '../../models/movie.dart';
import '../interfaces/remote_provider.dart';

/// Remote source provider - The Movie DB API
class TMDBApiProvider implements RemoteProvider {
  final _logger = FimberLog((TMDBApiProvider).toString());

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://api.themoviedb.org/3",
      queryParameters: {
        "api_key" : "b8d7f76947904a011286dc732c55234e",
        "language" : "en_US"
      }
    )
  );

  @override
  Future<List<Genre>?> getGenres() {
    _logger.d("Fetching genres remotely");
    return fetchGenres();
  }

  @override
  Future<List<Movie>?> getMovies(int page) {
    _logger.d("Fetching movies remotely, page $page");
    return fetchPopularMovies(page);
  }

  // @override
  // Future getDetails() async {
  //   return;
  // }

  Future<List<Movie>?> fetchPopularMovies(int page) async {
    Map? data = await  _getNetworkData(
        path: "/movie/popular",
        queryParams: {
          "page" : page
        });
    if(data != null){
      return (data["results"] as List).map((item) {
        Movie movie = Movie.fromJson(item);
        return movie;
      }).toList();
    }
    return null;
  }

  Future<List<Genre>?> fetchGenres() async {
    Map? data = await _getNetworkData(path: "/genre/movie/list");
    if(data != null){
      return (data["genres"] as List).map((item) => Genre.fromJson(item)).toList();
    }
    return null;
  }

  Future<Map?> _getNetworkData({required String path, Map<String, dynamic>? queryParams}) async {
    // await Future.delayed(Duration(seconds: 2));

    try {
      Response response = await _dio.get(
          path,
          queryParameters: queryParams
      );
      _logger.d("Response statusCode: ${response.statusCode}");
      if(response.statusCode != null && response.statusCode! / 100 == 2){
        _logger.d("Response raw data: ${response.data}");
        return response.data;
      } else {
        _logger.w("Network request was not successful");
        return null;
      }
    } catch (e, st) {
      _logger.e("Error while fetching data", ex: e, stacktrace: st);
      return null;
    }
  }

}