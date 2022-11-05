/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'package:dio/dio.dart';
import 'package:fimber/fimber.dart';

class TMDBApiProvider {
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

  Future<Map?> fetchPopularMovies() {
    return _getNetworkData(
        path: "/movie/popular",
        queryParams: {
          "page" : 1
        });
  }

  Future<Map?> fetchGenres() {
    return _getNetworkData(path: "/genre/movie/list");
  }

  Future<Map?> _getNetworkData({required String path, Map<String, dynamic>? queryParams}) async {
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