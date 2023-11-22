import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '/utils/constant.dart';
import '/models/movie.dart';
import '/screens/base.dart';
import '/services/movie.dart';

class MovieDetailsPage extends ConsumerStatefulWidget {
  final MovieModel movie;

  const MovieDetailsPage({
    required this.movie,
    super.key,
  });

  @override
  ConsumerState<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends ConsumerState<MovieDetailsPage> with Base {
  late FutureProvider<MovieModel> movieProvider;

  @override
  void initState() {
    super.initState();

    movieProvider = FutureProvider<MovieModel>(
      (ref) {
        return MovieService.getMovieDetails(widget.movie.id ?? 0);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var futureMovie = ref.watch(movieProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          // ignore: unused_result
          ref.refresh(movieProvider);
        },
        child: futureMovie.when(
          skipLoadingOnRefresh: false,
          loading: () => generateContent(widget.movie),
          data: generateContent,
          error: (error, stackTrace) {
            return errorWidget(context, error);
          },
        ),
      ),
    );
  }

  Widget generateContent(MovieModel movie) {
    var size = MediaQuery.of(context).size;
    return NestedScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: (size.height - kToolbarHeight - 24) * 0.45,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  image: (movie.posterPath.isNotEmpty)
                      ? DecorationImage(
                          image: NetworkImage(
                            "${Constant.imageURL}/t/p/w200${movie.posterPath}",
                          ),
                          fit: BoxFit.cover,
                        )
                      : const DecorationImage(
                          image: AssetImage("assets/images/not_found.jpg"),
                          fit: BoxFit.cover,
                        ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (movie.posterPath.isNotEmpty) {
                                  Navigator.pushNamed(
                                    context,
                                    ConstantRoute.posterPageView,
                                    arguments: {
                                      "id": movie.id,
                                    },
                                  );
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Stack(
                                  children: [
                                    Hero(
                                      tag: "poster_${movie.id}",
                                      child: networkImgWidget(
                                        "${Constant.imageURL}/t/p/w200${movie.posterPath}",
                                        height: 200,
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        color: Colors.black87,
                                        child: const Text(
                                          "click to view poster",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    movie.title,
                                    softWrap: true,
                                    maxLines: 3,
                                    overflow: TextOverflow.fade,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  if (movie.releaseDate != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        "Release Date: ${DateFormat("dd-MM-yyyy").format(
                                          movie.releaseDate ?? DateTime.now(),
                                        )}",
                                        overflow: TextOverflow.fade,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      "Rating: ${movie.voteAverage.toStringAsFixed(1)}",
                                      overflow: TextOverflow.fade,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      "Votes: ${movie.voteCount}",
                                      overflow: TextOverflow.fade,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      "Popularity: ${movie.popularity.toStringAsFixed(1)}",
                                      overflow: TextOverflow.fade,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                  if ((movie.genres ?? []).isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        "Genres: ${movie.genres?.map((e) => e.name).join(', ')}",
                                        overflow: TextOverflow.fade,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ];
      },
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Overview:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  movie.overview,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                "Production:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if ((movie.productionCompanies ?? []).isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(
                    "Companies: ${movie.productionCompanies!.map((e) => e.name).join(', ')}",
                  ),
                ),
              if ((movie.productionCountries ?? []).isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(
                    "Countries: ${movie.productionCountries!.map((e) => e.name).join(', ')}",
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  "Status: ${movie.status}",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
