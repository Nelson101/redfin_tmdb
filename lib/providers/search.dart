import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/services/movie.dart';
import '/models/movie.dart';
import '/utils/shared_pref.dart';

class SearchMovieNotifier extends StateNotifier<List<MovieModel>> {
  SearchMovieNotifier() : super([]);

  int page = 1;
  String name = "";
  bool isLoading = false;

  Object? error;

  Future<void> getSearchMovieList(
    String name, {
    bool isRefresh = false,
  }) async {
    isLoading = true;
    if (isRefresh) {
      page = 1;
      this.name = "";
      state = [];
    }

    try {
      final movies = await MovieService.searchMovie({
        "page": page,
        "query": name,
      });
      state = [...state, ...movies.results];
      this.name = name;
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
    name = "";
    state = [];
    isLoading = false;
    error = null;
  }
}

class SearchHistoryNotifier extends StateNotifier<List<String>> {
  SearchHistoryNotifier() : super([]);

  List<String> _histories = [];

  getSearchHistory() {
    state.clear();
    _histories.clear();

    Future.delayed(Duration.zero, () {
      _histories = SharedPref.getList(
        SharedPref.xSearchHistory,
      );
      state = _histories;
    });
  }

  addSearchHistory(String val) {
    if (val.isNotEmpty) {
      if (_histories.contains(val)) {
        _histories.remove(val);
      }
      _histories = [val, ..._histories];
      state = _histories;
    }

    SharedPref.setList(
      SharedPref.xSearchHistory,
      state,
    );
  }

  filterSearchHistory(String val) {
    if (val.isNotEmpty) {
      state = _histories.where((e) => e.contains(val)).toList();
    } else {
      state = _histories;
    }
  }

  removeSearchHistory(String val) {
    if (val.isNotEmpty) {
      state = _histories.where((e) => e != val).toList();

      SharedPref.setList(
        SharedPref.xSearchHistory,
        state,
      );
    }
  }

  void clear() {
    _histories = [];
    state = [];
  }
}
