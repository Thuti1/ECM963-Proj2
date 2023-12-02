// lib/models/movie_model.dart
class Movie {
  final int id;
  final String title;
  final String overview;
  final String releaseDate;
  final String posterPath;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.releaseDate,
    required this.posterPath,
  });
}
