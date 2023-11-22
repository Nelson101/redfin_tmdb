import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/services/movie.dart';
import '/models/genre.dart';

class GenreNotifier extends StateNotifier<List<GenreModel>> {
  GenreNotifier() : super([]);

  bool isLoading = false;

  Object? error;

  Future<void> getGenre() async {
    isLoading = true;

    try {
      final genres = await MovieService.getGenres();
      state = genres;
    } catch (err) {
      error = err;
    } finally {
      isLoading = false;
      state = [...state];
    }
  }

  void clear() {
    isLoading = false;
    state = [];
    error = null;
  }
}
