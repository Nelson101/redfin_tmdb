import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/services/movie.dart';
import '/models/movie.dart';

class GenreMoviesNotifier extends StateNotifier<List<MovieModel>> {
  GenreMoviesNotifier() : super([]);

  int page = 1;
  bool isLoading = false;

  Object? error;

  Future<void> getGenreMovies(
    int genreId, {
    bool isRefresh = false,
  }) async {
    isLoading = true;
    if (isRefresh) {
      page = 1;
      state = [];
    }

    try {
      final movies = await MovieService.getGenreMovies({
        "page": page,
        "with_genres": genreId,
        "sort_by": "primary_release_date.desc",
      });
      state = [...state, ...movies.results];
      page++;
    } catch (err) {
      error = err;
    } finally {
      isLoading = false;
      state = [...state];
    }
  }

  void clear() {
    page = 1;
    isLoading = false;
    state = [];
    error = null;
  }
}
