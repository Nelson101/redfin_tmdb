import 'package:redfin_tmdb/models/movie.dart';

import '/utils/parser_util.dart';

class GenreModel {
  int? id;
  String name;
  MoviesModel? movies;

  GenreModel({
    this.id,
    this.name = "",
    this.movies,
  });

  factory GenreModel.fromJson(Map<String, dynamic> data) {
    

    return GenreModel(
      id: ParserUtil.parseInt(data['id']),
      name: ParserUtil.parseString(data['name']) ?? "",
    );
  }
}
