class Constant {
  static const String appName = "Redfin - TMDB";

  static String apiURL = "";
  static String imageURL = "";
  static const String stageURL = "https://api.themoviedb.org";
  static const String stageImageURL = "https://image.tmdb.org";
  static const String prodURL = "https://api.themoviedb.org";
  static const String prodImageURL = "https://image.tmdb.org";

  static const String apiKey = "60c3f8820e02fcc4739484f0e814d9cf";
  // https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg
}

class ConstantRoute{
  static const String index = "/";
  static const String genreMovieList = "genre-movie-list";
  static const String movieDetails = "movie-details";
  static const String movieSearch = "movie-search";
  static const String posterPageView = "poster-page-view";
}

enum SearchType { history, movie }
enum MovieType { genre, movie }
