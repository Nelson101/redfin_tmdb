import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/screens/base.dart';
import '/utils/constant.dart';
import '/models/movie.dart';
import '/services/movie.dart';

class PosterPageView extends ConsumerStatefulWidget {
  final int id;

  const PosterPageView({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<PosterPageView> createState() => _PosterPageViewState();
}

class _PosterPageViewState extends ConsumerState<PosterPageView> with Base {
  late FutureProvider<List<PosterModel>> posterProvider;

  @override
  void initState() {
    super.initState();

    posterProvider = FutureProvider<List<PosterModel>>(
      (ref) {
        return MovieService.getMoviePosters(widget.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var futurePoster = ref.watch(posterProvider);

    return Scaffold(
      body: futurePoster.when(
        skipLoadingOnRefresh: false,
        data: (data) {
          return RefreshIndicator(
            onRefresh: () async {
              // ignore: unused_result
              ref.refresh(posterProvider);
            },
            child: PageView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return networkImgWidget(
                  "${Constant.imageURL}/t/p/w500${data[index].filePath}",
                  fit: BoxFit.contain,
                );
              },
            ),
          );
        },
        error: (error, stackTrace) {
          return errorWidget(context, error);
        },
        loading: loadingWidget,
      ),
    );
  }
}
