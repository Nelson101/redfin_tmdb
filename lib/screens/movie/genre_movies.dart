import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/models/movie.dart';
import '/providers/genre_movie.dart';
import '/screens/base.dart';
import 'widgets/grid_movies.dart';

class GenreMoviesPage extends ConsumerStatefulWidget {
  final int id;
  final String title;

  const GenreMoviesPage({
    required this.id,
    required this.title,
    super.key,
  });

  @override
  ConsumerState<GenreMoviesPage> createState() => _GenreMoviesPageState();
}

class _GenreMoviesPageState extends ConsumerState<GenreMoviesPage> with Base {
  late ScrollController _scrollController;
  final genreMoviesProvider =
      StateNotifierProvider<GenreMoviesNotifier, List<MovieModel>>(
    (ref) => GenreMoviesNotifier(),
  );

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    ref.read(genreMoviesProvider.notifier).getGenreMovies(widget.id);
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(genreMoviesProvider.notifier).getGenreMovies(widget.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(genreMoviesProvider.notifier);
    final futureGenreMovies = ref.watch(genreMoviesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // ignore: unused_result

          ref.read(genreMoviesProvider.notifier).getGenreMovies(
                widget.id,
                isRefresh: true,
              );
        },
        child: GridMoviesWidget(
          movies: futureGenreMovies,
          scrollController: _scrollController,
          isLoading: notifier.isLoading,
          error: notifier.error,
        ),
      ),
    );
  }
}
