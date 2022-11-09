/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:fimber/fimber.dart';
import 'package:movies_app/common/endpoints.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/genre.dart';
import '../../models/movie.dart';
import '../../models/movie_detail.dart';
import '../interfaces/remote_provider.dart';

/// Remote source provider - The Movie DB API
class TMDBApiProvider implements RemoteProvider {
  final _logger = FimberLog((TMDBApiProvider).toString());
  late Dio _dio;

  TMDBApiProvider(){
    _initDioClient();
    _initCacheStore();
  }

  /// Initialize Dio client with endpoint/connection values and interceptors
  void _initDioClient() {
    _dio  = Dio(
      BaseOptions(
        baseUrl: tmdbApiBaseUrl,
        queryParameters: {
          // "api_key" : tmdbApiKey,
          "language" : "en_US"
        },
        connectTimeout: 2000,
        followRedirects: false,
        // custom validate status to trigger DioErrors properly
        validateStatus: (status) => status != null && (status >= 200 && status < 300 || status == 304),
      ),
    )..interceptors.add(
        InterceptorsWrapper(
            onRequest: ((options, handler)
              => handler.next(options..headers["Authorization"] = "Bearer $tmdbBearerToken"))
        )
    );
  }

  /// Adds [DioCacheInterceptor] for optimizing network performance
  void _initCacheStore() async {
    var cacheStore = HiveCacheStore(
        (await getTemporaryDirectory()).path,
        hiveBoxName: 'cache',
    );
    _dio.interceptors.add(DioCacheInterceptor(
        options: CacheOptions(
          store: cacheStore,
          policy: CachePolicy.forceCache,
          priority: CachePriority.high,
          // Withing [maxStale] minutes - fetch network data from temporary cache
          maxStale: const Duration(minutes: 1),
          allowPostMethod: false,
          keyBuilder: (request) {
            return request.uri.toString();
          },
        )
    ));
  }

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

  @override
  Future<MovieDetail?> getMovieDetails(int id) async {
    _logger.d("Fetching movie details, id: $id");
    return fetchMovieDetails(id);
  }

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

  Future<MovieDetail?> fetchMovieDetails(int id) async {
    Map? data = await _getNetworkData(path: "/movie/$id");
    if(data != null){
      return MovieDetail.fromJson(data as Map<String, dynamic>);
    }
    return null;
  }

  /// General network request reused
  Future<Map?> _getNetworkData({required String path, Map<String, dynamic>? queryParams}) async {
    // await Future.delayed(Duration(seconds: 2));
    try {
      Response response = await _dio.get(
          path,
          queryParameters: queryParams
      );
      _logger.d("Response statusCode: ${response.statusCode}");
      _logger.d("Response raw data: ${response.data}");
      return response.data;
    } on DioError catch (e) {
      _logger.w("Network request was not successful");
      _logger.d("Error: ${e.type}");
      return null;
    } catch (e, st) {
      _logger.e("Error while fetching data", ex: e, stacktrace: st);
      return null;
    }
  }

}