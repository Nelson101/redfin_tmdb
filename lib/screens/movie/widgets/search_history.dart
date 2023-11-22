import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../_provider.dart';
import '/utils/constant.dart';
import '/utils/dialog_util.dart';
import '../movie_search.dart';

class SearchHistoriesWidget extends ConsumerWidget {
  const SearchHistoriesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shProvider = ref.watch(searchHistoryProvider);

    if (shProvider.isNotEmpty) {
      return ListView.builder(
        itemCount: shProvider.length,
        itemBuilder: (context, index) {
          String item = shProvider[index];
          return ListTile(
            title: Text(item),
            leading: const Icon(Icons.history),
            onTap: () {
              // Remove cursor from TextFormField
              FocusScope.of(context).unfocus();

              // add selected data into history
              ref.read(searchHistoryProvider.notifier).addSearchHistory(item);
              searchCtrl?.text = item;

              // change to movie page
              ref.read(searchTypeProvider.notifier).state = SearchType.movie;
              ref.read(searchMovieProvider.notifier).getSearchMovieList(
                    item,
                    isRefresh: true,
                  );
            },
            onLongPress: () async {
              // Remove cursor from TextFormField
              FocusScope.of(context).unfocus();

              // To confirm data removal
              bool isConfirmed = await DialogUtil.showConfirmationDialogBox(
                    context,
                    "Remove from search history?",
                    titleTxt: item,
                  ) ??
                  false;

              if (isConfirmed) {
                // remove data from history
                ref
                    .read(searchHistoryProvider.notifier)
                    .removeSearchHistory(item);
              }
            },
          );
        },
      );
    } else {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: const Center(
          child: Text("No history..."),
        ),
      );
    }
  }
}
