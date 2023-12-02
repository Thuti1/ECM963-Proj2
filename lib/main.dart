// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/details_screen.dart';
import 'screens/search_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TMDb App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/search',
      routes: {
        '/': (context) => HomeScreen(),
        '/details': (context) => DetailsScreen(
          media: {}, 
          mediaType: '', 
        ),
        '/search': (context) => SearchScreen(),
      },
    );
  }
}

