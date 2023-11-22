import 'package:flutter/material.dart';

import '/models/movie.dart';
import '/utils/constant.dart';
import '/screens/base.dart';

class GridMoviesWidget extends StatelessWidget with Base {
  final bool isLoading;
  final Object? error;
  final List<MovieModel> movies;
  final ScrollController scrollController;

  const GridMoviesWidget({
    super.key,
    required this.movies,
    required this.scrollController,
    this.isLoading = false,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loadingWidget();
    } else if (error != null) {
      return errorWidget(context, error);
    } else {
      if (movies.isEmpty) {
        return const Center(
          child: Text("No record..."),
        );
      }
      var size = MediaQuery.of(context).size;

      // get height without app bar
      final double itemHeight = (size.height - kToolbarHeight - 24) / 2.5;
      final double itemWidth = size.width / 2;

      return GridView.count(
        controller: scrollController,
        crossAxisCount: 2,
        childAspectRatio: (itemWidth / itemHeight),
        padding: const EdgeInsets.all(8.0),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: movies.map((movie) {
          return ClipRRect(
            key: Key(movie.id.toString()),
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
                color: Colors.black,
                child: Stack(
                  children: [
                    Hero(
                      tag: "poster_${movie.id}",
                      child: networkImgWidget(
                        "${Constant.imageURL}/t/p/w200${movie.posterPath}",
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "${movie.voteAverage.toStringAsFixed(1)} ",
                            ),
                            Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.yellow[800],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            color: Colors.black87,
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    movie.title,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      );
    }
  }
}
