// lib/models/tv_show_model.dart
class TVShow {
  final int id;
  final String name;
  final String overview;
  final String firstAirDate;
  final String posterPath;

  TVShow({
    required this.id,
    required this.name,
    required this.overview,
    required this.firstAirDate,
    required this.posterPath,
  });
}
