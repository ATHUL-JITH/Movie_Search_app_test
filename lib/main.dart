import 'package:flutter/material.dart';
import 'package:movie_app_test/features/presentation/pages/homepage.dart';
import 'package:provider/provider.dart';
import 'features/data/provider/movie_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MovieProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'movie Demo',
      home: HomeScreen(),
    );
  }
}
