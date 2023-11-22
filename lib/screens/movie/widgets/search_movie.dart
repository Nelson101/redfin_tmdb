import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../_provider.dart';
import '/screens/base.dart';
import 'grid_movies.dart';

class SearchMoviesWidget extends ConsumerStatefulWidget {
  const SearchMoviesWidget({
    super.key,
  });

  @override
  ConsumerState<SearchMoviesWidget> createState() => _SearchMoviesWidget();
}

class _SearchMoviesWidget extends ConsumerState<SearchMoviesWidget> with Base {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      var tmp = ref.read(searchMovieProvider.notifier);
      tmp.getSearchMovieList(
        tmp.name,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(searchMovieProvider.notifier);
    final futureMovie = ref.watch(searchMovieProvider);

    return GridMoviesWidget(
      movies: futureMovie,
      scrollController: _scrollController,
      isLoading: notifier.isLoading,
      error: notifier.error,
    );
  }
}
