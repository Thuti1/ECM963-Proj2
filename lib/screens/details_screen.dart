// lib/screens/details_screen.dart
import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final dynamic media;
  final String mediaType;

  DetailsScreen({required this.media, required this.mediaType});

  @override
  Widget build(BuildContext context) {
    String title = '';
    String overview = '';
    String backdropPath = '';
    String releaseDate = '';
    double voteAverage = 0.0;

    // Configuração de informações com base no tipo de mídia
    if (mediaType == 'movie') {
      title = media['title'] ?? '';
      overview = media['overview'] ?? '';
      backdropPath = media['backdrop_path'] ?? '';
      releaseDate = _formatReleaseDate(media['release_date']);
      voteAverage = media['vote_average'] != null ? media['vote_average'].toDouble() : 0.0;
    } else if (mediaType == 'tv') {
      title = media['name'] ?? '';
      overview = media['overview'] ?? '';
      backdropPath = media['backdrop_path'] ?? '';
      releaseDate = _formatReleaseDate(media['first_air_date']);
      voteAverage = media['vote_average'] != null ? media['vote_average'].toDouble() : 0.0;
    } else if (mediaType == 'person') {
      title = media['name'] ?? '';
      overview = 'Known for: ${media['known_for_department']}';
      backdropPath = media['profile_path'] ?? ''; // Utiliza profile_path como backdrop para pessoas
      // Não há release_date ou vote_average para pessoas
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        backgroundColor: Colors.indigo,
      ),
      body: _buildBody(title, overview, backdropPath, releaseDate, voteAverage, mediaType),
    );
  }

  String _formatReleaseDate(String rawDate) {
    if (rawDate.isNotEmpty) {
      final DateTime dateTime = DateTime.parse(rawDate);
      final formattedDate = "${dateTime.month}/${dateTime.day}/${dateTime.year}";
      return formattedDate;
    } else {
      return 'N/A';
    }
  }

  Widget _buildBody(
      String title, String overview, String backdropPath, String releaseDate, double voteAverage, String mediaType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 200, // Altura da imagem em landscape
          decoration: BoxDecoration(
            image: backdropPath.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage('https://image.tmdb.org/t/p/w780/$backdropPath'),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              if (mediaType != 'person') ...[
                SizedBox(height: 8),
                Text(
                  'Release Date: $releaseDate',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Description',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
              ],
              Text(
                overview,
                style: TextStyle(fontSize: 16),
              ),
              if (mediaType == 'movie' || mediaType == 'tv') ...[
                SizedBox(height: 8),
                Text(
                  'Vote Average: $voteAverage',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
