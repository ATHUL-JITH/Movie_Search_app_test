import 'package:flutter/material.dart';
import 'package:movie_app_test/core/utils/color_class.dart';
import 'package:movie_app_test/features/data/provider/movie_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final movieProvider = Provider.of<MovieProvider>(context, listen: false);
      movieProvider.fetchMovies();
    });

    _searchController.addListener(() {
      final query = _searchController.text;
      final movieProvider = Provider.of<MovieProvider>(context, listen: false);
      if (query.isNotEmpty) {
        movieProvider.searchMovies(query);
      } else {
        movieProvider.fetchMovies();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);
    return Scaffold(
      backgroundColor: ColorClass.background,
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
              color: ColorClass.primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                suffixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 100),
            movieProvider.isLoading
                ? const CircularProgressIndicator()
                : movieProvider.movies.isEmpty
                    ? const Center(child: Text('No results found'))
                    : Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          clipBehavior: Clip.none,
                          itemCount: movieProvider.movies.length,
                          itemBuilder: (context, index) {
                            final movie = movieProvider.movies[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10), 
                              child: Container(
                                height: 180,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Positioned(
                                      left: 60,
                                      child: Container(
                                        margin: EdgeInsets.symmetric(),
                                        height: 120,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                120,
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // Title
                                                Text(
                                                  movie['title'] ?? 'No Title',
                                                  style: const TextStyle(
                                                    color:
                                                        ColorClass.primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                // Genre
                                                Text(
                                                  movie['genre'] != null
                                                      ? (movie['genre'] is List
                                                          ? (movie['genre']
                                                                  as List<
                                                                      String>)
                                                              .join(' | ')
                                                          : movie['genre'])
                                                      : 'No Genre',
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: ColorClass.secondary,
                                                  ),
                                                ),
                                                // Rating
                                                Text(
                                                  'Rating: ${movie['rating']?.toString() ?? 'N/A'}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: (movie['rating'] !=
                                                                null &&
                                                            double.tryParse(movie[
                                                                        'rating']
                                                                    .toString()) !=
                                                                null &&
                                                            double.parse(movie[
                                                                        'rating']
                                                                    .toString()) >=
                                                                9.0)
                                                        ? ColorClass.rating1
                                                        : ColorClass.rating2,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Image positioned to the left
                                    Positioned(
                                      top: -62,
                                      left: 0,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: movie['image'] != null
                                            ? Image.network(
                                                movie['image'],
                                                width:
                                                    120, // Width for the image
                                                height:
                                                    180, // Height to align with the card
                                                fit: BoxFit.cover,
                                              )
                                            : Container(
                                                width: 120,
                                                height: 180,
                                                color: Colors.grey,
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
