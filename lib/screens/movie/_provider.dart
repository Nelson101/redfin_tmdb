import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/genre.dart';
import '../../providers/genre.dart';
import '/utils/constant.dart';
import '/models/movie.dart';
import '/providers/search.dart';

final searchTypeProvider =
    StateProvider<SearchType>((ref) => SearchType.history);
final searchHistoryProvider =
    StateNotifierProvider<SearchHistoryNotifier, List<String>>((ref) {
  return SearchHistoryNotifier();
});
final searchMovieProvider =
    StateNotifierProvider<SearchMovieNotifier, List<MovieModel>>((ref) {
  return SearchMovieNotifier();
});

final genreProvider = StateNotifierProvider<GenreNotifier, List<GenreModel>>(
  (ref) {
    return GenreNotifier();
  },
);
