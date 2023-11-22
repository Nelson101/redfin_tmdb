import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '_provider.dart';
import '/utils/constant.dart';
import '/screens/movie/widgets/search_history.dart';
import '/screens/movie/widgets/search_movie.dart';

TextEditingController? searchCtrl;

class MovieSearchPage extends ConsumerStatefulWidget {
  const MovieSearchPage({super.key});

  @override
  ConsumerState createState() => _MovieSearchPageState();
}

class _MovieSearchPageState extends ConsumerState<MovieSearchPage> {
  FocusNode searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    searchCtrl = TextEditingController();
    ref.read(searchHistoryProvider.notifier).getSearchHistory();
    searchFocus.requestFocus();
  }

  @override
  dispose() {
    searchFocus.dispose();
    searchCtrl?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder inputBorder = const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey,
        width: 1,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(50),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(
            right: 8.0,
          ),
          child: TextFormField(
            focusNode: searchFocus,
            cursorColor: Theme.of(context).iconTheme.color,
            controller: searchCtrl,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.search,
            style: const TextStyle(fontSize: 12),
            onChanged: (val) {
              // update filter
              ref.read(searchHistoryProvider.notifier).filterSearchHistory(val);
            },
            onTap: () {
              // change to history page
              ref.read(searchTypeProvider.notifier).state = SearchType.history;
            },
            onFieldSubmitted: (val) {
              // add search data into history
              ref.read(searchHistoryProvider.notifier).addSearchHistory(val);
              ref.read(searchMovieProvider.notifier).getSearchMovieList(
                    val,
                    isRefresh: true,
                  );

              // change to movie page
              ref.read(searchTypeProvider.notifier).state = SearchType.movie;
            },
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Search movie',
              enabledBorder: inputBorder,
              focusedBorder: inputBorder,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 16,
              ),
              suffixIconConstraints: const BoxConstraints(
                maxHeight: 32,
              ),
              suffixIconColor: Theme.of(context).iconTheme.color,
              suffixIcon: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.clear,
                ),
                onPressed: () {
                  searchCtrl?.clear();

                  // change to history page
                  ref.read(searchTypeProvider.notifier).state =
                      SearchType.history;

                  // remove filter
                  ref
                      .read(searchHistoryProvider.notifier)
                      .filterSearchHistory("");

                  searchFocus.requestFocus();
                },
              ),
            ),
          ),
        ),
      ),
      body: Builder(
        builder: (context) {
          final stProvider = ref.watch(searchTypeProvider);

          if (stProvider == SearchType.history) {
            return const SearchHistoriesWidget();
          } else {
            return const SearchMoviesWidget();
          }
        },
      ),
    );
  }
}
