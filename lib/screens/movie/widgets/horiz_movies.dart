import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../_provider.dart';
import '/models/movie.dart';
import '/services/movie.dart';
import '/utils/constant.dart';
import '/screens/base.dart';

class HorizontalMovie extends ConsumerStatefulWidget {
  final int id;
  const HorizontalMovie({
    required this.id,
    super.key,
  });

  @override
  ConsumerState<HorizontalMovie> createState() => _HorizontalMovieState();
}

class _HorizontalMovieState extends ConsumerState<HorizontalMovie> with Base {
  late FutureProvider<MoviesModel> moviesProvider;

  @override
  void initState() {
    super.initState();

    moviesProvider = FutureProvider<MoviesModel>(
      (ref) async {
        var futureGenres = ref.watch(genreProvider);
        MoviesModel? tmpMovies;

        if (futureGenres.isNotEmpty) {
          final index = futureGenres.indexWhere(
            (genre) => genre.id == widget.id,
          );

          if (index != -1) {
            final foundGenre = futureGenres[index];
            if (foundGenre.movies == null) {
              tmpMovies = await MovieService.getGenreMovies({
                "with_genres": widget.id,
                "sort_by": "primary_release_date.desc",
              });
              foundGenre.movies = tmpMovies;
            } else {
              tmpMovies = foundGenre.movies;
            }
          }
        }

        return Future.value(tmpMovies);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var futurePoster = ref.watch(moviesProvider);

    return futurePoster.when(
      data: (data) {
        var tmpResults = data.results.take(10).toList();

        if (data.results.isNotEmpty) {
          return ListView.builder(
            itemCount: tmpResults.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemBuilder: (context, index) {
              var movie = tmpResults[index];

              return Container(
                key: Key("tmp_movie_${movie.id}"),
                margin: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ConstantRoute.movieDetails,
                            arguments: {"movie": movie},
                          );
                        },
                        child: Container(
                          height: 150,
                          color: Colors.black,
                          child: networkImgWidget(
                            "${Constant.imageURL}/t/p/w200${movie.posterPath}",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return const Center(
            child: Text("No record..."),
          );
        }
      },
      error: (error, stackTrace) {
        return errorWidget(context, error);
      },
      loading: () {
        return ListView.builder(
          itemCount: 10,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: Colors.black,
                      height: 150,
                      width: 100,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
