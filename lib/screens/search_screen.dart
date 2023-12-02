// lib/screens/search_screen.dart
import 'package:flutter/material.dart';
import '../widgets/search_bar.dart';
import '../services/tmdb_api.dart';
import 'details_screen.dart'; 

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TMDBApi _tmdbApi = TMDBApi();
  String _searchOption = 'movie';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          CustomSearchBar(
            controller: _searchController,
            onChanged: (String value) {
              // Lógica para reagir a alterações no texto de pesquisa
            },
            onSubmitted: () {
              _performSearch();
            },
          ),
          // Adiciona opções para selecionar o tipo de pesquisa
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSearchOption('Movies', 'movie'),
              _buildSearchOption('TV Shows', 'tv'),
              _buildSearchOption('People', 'person'),
            ],
          ),
          // Lista de resultados da pesquisa
          Expanded(
            child: FutureBuilder(
              future: _tmdbApi.searchMedia(_searchController.text, _searchOption),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || (snapshot.data as Map<String, dynamic>)['results'] == null) {
                  return Center(child: Text('No results found.'));
                }

                final List<dynamic> searchResults = (snapshot.data as Map<String, dynamic>)['results'];
                return ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final result = searchResults[index];
                    final title = result['title'] ?? result['name'] ?? result['original_name'] ?? '';
                    final imagePath = result['poster_path'] ?? result['profile_path'] ?? '';

                    return _buildMediaCard(
                      title: title,
                      imagePath: imagePath,
                      result: result, // Passa as informações do resultado
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchOption(String label, String option) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _searchOption = option;
        });
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: _searchOption == option ? Colors.indigo : Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          label,
          style: TextStyle(color: _searchOption == option ? Colors.indigo : Colors.black),
        ),
      ),
    );
  }

  Widget _buildMediaCard({required String title, required String imagePath, required dynamic result}) {
  return GestureDetector(
    onTap: () {
      _navigateToDetails(result); // Navega para a tela de detalhes existente
    },
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              width: 80,
              decoration: BoxDecoration(
                image: imagePath.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage('https://image.tmdb.org/t/p/w500/$imagePath'),
                        fit: BoxFit.cover,
                      )
                    : null,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


  void _performSearch() {
    // A pesquisa será realizada automaticamente no FutureBuilder ao definir o texto e pressionar Enter.
  }

  void _navigateToDetails(dynamic result) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(
          media: result,
          mediaType: _searchOption,
        ),
      ),
    );
  }
}

