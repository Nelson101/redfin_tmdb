import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './base.dart';
import '/models/genre.dart';
import '/utils/constant.dart';
import 'movie/_provider.dart';
import 'movie/widgets/horiz_movies.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with Base {
  @override
  void initState() {
    super.initState();

    ref.read(genreProvider.notifier).getGenre();

    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(genreProvider.notifier);
    final futureGenres = ref.watch(genreProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Constant.appName,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                ConstantRoute.movieSearch,
              );
            },
            icon: const Icon(
              Icons.search,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // ignore: unused_result
          ref.read(genreProvider.notifier).getGenre();
        },
        child: generateContent(
          futureGenres,
          isLoading: notifier.isLoading,
          error: notifier.onError,
        ),
      ),
    );
  }

  Widget generateContent(List<GenreModel> data,
      {bool isLoading = false, Object? error}) {
    if (isLoading) {
      return loadingWidget();
    } else if (error != null) {
      return errorWidget(context, error);
    } else {
      if (data.isNotEmpty) {
        return ListView.builder(
          addAutomaticKeepAlives: false,
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        data[index].name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.all(0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          ConstantRoute.genreMovieList,
                          arguments: {
                            "id": data[index].id,
                            "title": data[index].name,
                          },
                        );
                      },
                      child: const Text("More"),
                    ),
                  ],
                ),
                SizedBox(
                  height: 170,
                  child: HorizontalMovie(
                    key: Key("horiz_movie_${data[index].id}"),
                    id: data[index].id ?? 0,
                  ),
                ),
              ],
            );
          },
        );
      } else {
        return const Center(
          child: Text("No record..."),
        );
      }
    }
  }
}
