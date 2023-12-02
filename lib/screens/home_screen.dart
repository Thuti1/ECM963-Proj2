// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../services/tmdb_api.dart';
import 'search_screen.dart'; 
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> trendingMovies = [];
  List<Map<String, dynamic>> trendingTVShows = [];
  List<Map<String, dynamic>> trendingPeople = [];

  @override
  void initState() {
    super.initState();
    _fetchTrendingMedia();
  }

  Future<void> _fetchTrendingMedia() async {
    try {
      final movies = await TMDBApi().getTrending('movie');
      final tvShows = await TMDBApi().getTrending('tv');
      final people = await TMDBApi().getTrending('person');

      setState(() {
        trendingMovies = List<Map<String, dynamic>>.from(movies);
        trendingTVShows = List<Map<String, dynamic>>.from(tvShows);
        trendingPeople = List<Map<String, dynamic>>.from(people);
        print(List<Map<String, dynamic>>.from(people));
      });
    } catch (e) {
      print('Error fetching trending media: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TMDb App'),
        backgroundColor: Colors.indigo,
      ),
      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Movies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'TV Shows',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'People',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
      ),
    );
  }

  Widget _getBody() {
    switch (_currentIndex) {
      case 0:
        return _getTrendingTab('movie', trendingMovies);
      case 1:
        return _getTrendingTab('tv', trendingTVShows);
      case 2:
        return _getTrendingTab('person', trendingPeople);
      case 3:
        // Navegação para a tela de busca quando a tab é selecionada
        return SearchScreen();
      default:
        return Container();
    }
  }

  Widget _getTrendingTab(
      String mediaType, List<Map<String, dynamic>> mediaList) {
    if (mediaList.isEmpty) {
      return Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
        itemCount: mediaList.length,
        itemBuilder: (context, index) {
          final media = mediaList[index];
          return _buildMediaCard(media, mediaType);
        },
      );
    }
  }

  Widget _buildMediaCard(Map<String, dynamic> media, String mediaType) {
    String title = '';
    String image = '';

    if (mediaType == 'movie') {
      title = media['title'];
      image = 'poster_path';
    } else if (mediaType == 'tv') {
      title = media['name'];
      image = 'poster_path';
    } else if (mediaType == 'person') {
      title = media['name'];
      image = 'profile_path';
    }

    return Card(
      elevation: 3,
      margin: EdgeInsets.all(8),
      child: ListTile(
        leading: Image.network(
          '${TMDBApi.imageBaseUrl}${media[image]}',
          width: 80,
          height: 120,
          fit: BoxFit.cover,
        ),
        title: Text(title, style: TextStyle(fontSize: 20)),
        onTap: () {
          _navigateToDetailsScreen(media, mediaType);
        },
      ),
    );
  }

  void _navigateToDetailsScreen(Map<String, dynamic> media, String mediaType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(media: media, mediaType: mediaType),
      ),
    );
  }
}
