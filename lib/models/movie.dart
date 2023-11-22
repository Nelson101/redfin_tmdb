import '/models/genre.dart';
import '/utils/parser_util.dart';

class MoviesModel {
  int page;
  List<MovieModel> results;
  int totalPage;
  int totalResult;

  MoviesModel({
    this.page = 0,
    this.results = const [],
    this.totalPage = 0,
    this.totalResult = 0,
  });

  factory MoviesModel.fromJson(Map<String, dynamic> data) {
    List tmpMovies = [];

    try {
      tmpMovies = data["results"] as List;
    } catch (_) {}

    return MoviesModel(
      page: ParserUtil.parseInt(data['page']) ?? 0,
      results: tmpMovies.map((i) => MovieModel.fromJson(i)).toList(),
      totalPage: ParserUtil.parseInt(data['total_page']) ?? 0,
      totalResult: ParserUtil.parseInt(data['total_result']) ?? 0,
    );
  }
}

class MovieModel {
  int? id;
  String title;
  String posterPath;
  String overview;
  double popularity;
  double voteAverage;
  int voteCount;
  String status;
  DateTime? releaseDate;
  List<GenreModel>? genres;
  List<CompanyModel>? productionCompanies;
  List<CountryModel>? productionCountries;

  MovieModel({
    this.id,
    this.title = "",
    this.posterPath = "",
    this.overview = "",
    this.popularity = 0,
    this.voteAverage = 0,
    this.voteCount = 0,
    this.status = "",
    this.releaseDate,
    this.genres,
    this.productionCompanies,
    this.productionCountries,
  });

  factory MovieModel.fromJson(Map<String, dynamic> data) {
    List tmpGenre = [];
    List tmpCompany = [];
    List tmpCountry = [];

    try {
      tmpGenre = data["genres"] as List;
    } catch (_) {}
    try {
      tmpCompany = data["production_companies"] as List;
    } catch (_) {}
    try {
      tmpCountry = data["production_countries"] as List;
    } catch (_) {}

    return MovieModel(
      id: ParserUtil.parseInt(data['id']),
      title: ParserUtil.parseString(data['title']) ?? "",
      posterPath: ParserUtil.parseString(data['poster_path']) ?? "",
      overview: ParserUtil.parseString(data['overview']) ?? "",
      popularity: ParserUtil.parseDouble(data['popularity']) ?? 0,
      voteAverage: ParserUtil.parseDouble(data['vote_average']) ?? 0,
      voteCount: ParserUtil.parseInt(data['vote_count']) ?? 0,
      status: ParserUtil.parseString(data['status']) ?? "",
      releaseDate: ParserUtil.parseDateTime(data['release_date']),
      genres: tmpGenre.map((e) => GenreModel.fromJson(e)).toList(),
      productionCompanies: tmpCompany.map((e) => CompanyModel.fromJson(e)).toList(),
      productionCountries: tmpCountry.map((e) => CountryModel.fromJson(e)).toList(),
    );
  }
}

class PosterModel{
  String filePath;
  double height;
  double width;

  PosterModel({
    this.filePath = "",
    this.height = 0,
    this.width = 0,
  });

  factory PosterModel.fromJson(Map<String, dynamic> data) {
    return PosterModel(
      filePath: ParserUtil.parseString(data['file_path']) ?? "",
      height: ParserUtil.parseDouble(data['height']) ?? 0,
      width: ParserUtil.parseDouble(data['width']) ?? 0,
    );
  }
}

class CountryModel {
  String iso_3166_1;
  String name;

  CountryModel({
    this.iso_3166_1 = "",
    this.name = "",
  });

  factory CountryModel.fromJson(Map<String, dynamic> data) {
    return CountryModel(
      iso_3166_1: ParserUtil.parseString(data['iso_3166_1']) ?? "",
      name: ParserUtil.parseString(data['name']) ?? "",
    );
  }
}

class CompanyModel {
  int id;
  String name;

  CompanyModel({
    this.id = 0,
    this.name = "",
  });

  factory CompanyModel.fromJson(Map<String, dynamic> data) {
    return CompanyModel(
      id: ParserUtil.parseInt(data['id']) ?? 0,
      name: ParserUtil.parseString(data['name']) ?? "",
    );
  }
}
