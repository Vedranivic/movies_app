/*
 * Copyright (c) 2022 Vedran Ivić. All rights reserved.
 * This file is part of movies_app Flutter application project.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/common/colors.dart';
import 'package:movies_app/ui/widgets/bottom_loader.dart';
import 'package:movies_app/ui/widgets/movie_list_tile.dart';

import '../../blocs/movies_bloc/movies_bloc.dart';
import '../../models/movie.dart';

/// Custom List widget for displaying [List<Movie>] data with optional Pull-to-refresh feature
class MoviesList extends StatefulWidget {
  const MoviesList({required this.movies, this.hasReachedMaxPage = true, this.pullToRefresh = false, Key? key}) : super(key: key);
  final List<Movie> movies;
  /// Used to indicate whether [BottomLoader] should be in the list or not
  final bool hasReachedMaxPage;
  /// Optional pull to refresh feature using [RefreshIndicator]
  final bool pullToRefresh;

  @override
  State<MoviesList> createState() => _MoviesListState();
}

class _MoviesListState extends State<MoviesList> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  // final _logger = FimberLog((MoviesList).toString());

  bool _isFetchRequested = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void didUpdateWidget(covariant MoviesList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.movies.length > oldWidget.movies.length){
      _isFetchRequested = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      notificationPredicate: (_) => widget.pullToRefresh,
      onRefresh: _onListRefresh,
      color: appScaffoldBackgroundColor,
      backgroundColor: appPrimaryColor,
      child: widget.movies.isEmpty
        ? LayoutBuilder(
          builder: (context, constraints) {
            return ListView(
              children: [
                Container(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Center(
                    child: Text(
                      "No movies${widget.pullToRefresh ? ". Pull to refresh." : ""}"
                    ),
                  ),
                )
              ],
            );
          }
        )
        : ListView.builder(
          controller: _scrollController,
          // Additional list item for bottom loader in pagination
          itemCount: widget.hasReachedMaxPage
              ? widget.movies.length
              : widget.movies.length + 1,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index){
            return index < widget.movies.length
              ? MovieListTile(widget.movies[index])
              : const BottomLoader();
          }
      ),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom && !_isFetchRequested){
      _isFetchRequested = true;
      BlocProvider.of<MoviesBloc>(context).add(MoviesFetchRequested(widget.movies));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  // void _scrollToTop() {
  //   _scrollController.animateTo(
  //       _scrollController.position.minScrollExtent,
  //       duration: const Duration(milliseconds: 400),
  //       curve: Curves.fastOutSlowIn
  //   );
  // }

  Future<void> _onListRefresh() async {
    BlocProvider.of<MoviesBloc>(context).add(MoviesRefresh());
  }
}
