import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/utils/constant.dart';
import '/utils/shared_pref.dart';
import '/screens/home.dart';
import '/screens/movie/genre_movies.dart';
import 'screens/movie/movie_search.dart';
import '/screens/movie/movie_details.dart';
import 'screens/movie/poster_page_view.dart';
import '/models/movie.dart';

void main() {
  // runZonedGuarded essentially provides better traceability for errors, exceptions and debugging
  runZonedGuarded(() async {
    String tmpEnv = 'staging';
    Constant.apiURL = Constant.stageURL;
    Constant.imageURL = Constant.stageImageURL;

    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    await SharedPref.init();

    String? flavor = await const MethodChannel("flavor").invokeMethod<String>(
      "getFlavor",
    );

    if (flavor == 'production') {
      tmpEnv = 'production';
      Constant.apiURL = Constant.prodURL;
      Constant.imageURL = Constant.prodImageURL;
    }

    await SharedPref.setString(SharedPref.xEnv, tmpEnv);

    runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    );
  }, (error, stack) {
    // handle your error
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constant.appName,
      theme: ThemeData.dark(),
      darkTheme: ThemeData.dark(),
      initialRoute: ConstantRoute.index,
      onGenerateRoute: (RouteSettings settings) {
        final data = settings.arguments as Map<String, dynamic>;
        var routes = <String, WidgetBuilder>{
          ConstantRoute.movieDetails: (ctx) {
            return MovieDetailsPage(
              movie: data["movie"] as MovieModel,
            );
          },
          ConstantRoute.genreMovieList: (ctx) {
            int id = data["id"] as int;
            String title = data["title"] as String;

            return GenreMoviesPage(
              id: id,
              title: title,
            );
          },
          ConstantRoute.posterPageView: (ctx) {
            int id = data["id"] as int;

            return PosterPageView(
              id: id,
            );
          }
        };

        WidgetBuilder? builder = routes[settings.name];
        if (builder != null) {
          return MaterialPageRoute(
            builder: (ctx) => builder(ctx),
          );
        }
        return null;
      },
      routes: {
        ConstantRoute.index: (context) => const HomePage(),
        ConstantRoute.movieSearch: (context) => const MovieSearchPage(),
      },
    );
  }
}
