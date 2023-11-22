import '/utils/constant.dart';
import '/network/dio_network.dart';
import '/models/genre.dart';
import '/models/movie.dart';

class MovieService {
  static final Map<String, dynamic> _apiKey = {"api_key": Constant.apiKey};
  static const String _genreApi = '/3/genre/movie/list';
  static const String _moviesByGenreApi = '/3/discover/movie';
  static const String _moviesDetailsApi = '/3/movie/{id}';
  static const String _moviesPosterApi = '/3/movie/{id}/images';
  static const String _searchMoviesApi = '/3/search/movie';

  static Future<List<GenreModel>> getGenres() async {
    var hr = await DioNetwork.get(
      _genreApi,
      queryData: {
        ..._apiKey,
      },
    );

    if (hr.success && hr.data != null) {
      return (hr.data["genres"] as List)
          .map((e) => GenreModel.fromJson(e))
          .toList();
    } else {
      throw Exception(hr.msg);
    }
  }

  static Future<MoviesModel> getGenreMovies(
    Map<String, dynamic> data,
  ) async {
    var hr = await DioNetwork.get(
      _moviesByGenreApi,
      queryData: {
        ...data,
        ..._apiKey,
      },
    );

    if (hr.success && hr.data != null) {
      return MoviesModel.fromJson(hr.data);
    } else {
      throw Exception(hr.msg);
    }
  }

  static Future<MoviesModel> searchMovie(
    Map<String, dynamic> data,
  ) async {
    var hr = await DioNetwork.get(
      _searchMoviesApi,
      queryData: {
        ...data,
        ..._apiKey,
      },
    );

    if (hr.success && hr.data != null) {
      return MoviesModel.fromJson(hr.data);
    } else {
      throw Exception(hr.msg);
    }
  }

  static Future<MovieModel> getMovieDetails(int id) async {
    var hr = await DioNetwork.get(
      _moviesDetailsApi.replaceAll(
        "{id}",
        id.toString(),
      ),
      queryData: {
        ..._apiKey,
      },
    );

    if (hr.success && hr.data != null) {
      return MovieModel.fromJson(hr.data);
    } else {
      throw Exception(hr.msg);
    }
  }

  static Future<List<PosterModel>> getMoviePosters(int id) async {
    var hr = await DioNetwork.get(
      _moviesPosterApi.replaceAll(
        "{id}",
        id.toString(),
      ),
      queryData: {
        ..._apiKey,
      },
    );

    if (hr.success && hr.data != null) {
      return (hr.data["posters"] as List)
          .map((e) => PosterModel.fromJson(e))
          .toList();
    } else {
      throw Exception(hr.msg);
    }
  }
}
