import 'package:flutter/material.dart';
import 'Movies.dart';
import 'detail.dart';
import 'http.dart';
import 'SearchDelegate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HttpHelper? helper;
  List<Movie>? movies;
  final String iconBase = 'https://image.tmdb.org/t/p/w92/';
  final String defaultImage =
      'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';

  String? selectedCategory = 'Now Playing';

  void updateCategory(String category) {
    setState(() {
      selectedCategory = category;
      initialize();
    });
  }

  @override
  void initState() {
    helper = HttpHelper();
    initialize();
    super.initState();
  }

  Future<void> initialize() async {
    switch (selectedCategory) {
      case 'Latest':
        movies = await helper?.getLatestMovies();
        break;
      case 'Now Playing':
        movies = await helper?.getNowPlayingMovies();
        break;
      case 'Popular':
        movies = await helper?.getPopularMovies();
        break;
      case 'Top Rated':
        movies = await helper?.getTopRatedMovies();
        break;
      case 'Upcoming':
        movies = await helper?.getUpcomingMovies();
        break;
      default:
        movies = await helper?.getNowPlayingMovies();
    }

    setState(() {
      movies = movies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies - $selectedCategory'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final String? result = await showSearch<String>(
                context: context,
                delegate: MovieSearchDelegate(movies!),
              );
              if (result != null && result.isNotEmpty) {
                // Proses hasil pencarian jika diperlukan
              }
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 16), // Tambahkan space antara AppBar dan Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                buildCategoryChip('Latest'),
                buildCategoryChip('Now Playing'),
                buildCategoryChip('Popular'),
                buildCategoryChip('Top Rated'),
                buildCategoryChip('Upcoming'),
              ],
            ),
          ),
          SizedBox(height: 16), // Tambahkan space antara Chips dan Cards
          Expanded(
            child: ListView.builder(
              itemCount: (movies?.length == null) ? 0 : movies?.length,
              itemBuilder: (BuildContext context, int position) {
                NetworkImage image;
                if (movies![position].posterPath != null) {
                  image =
                      NetworkImage(iconBase + movies![position].posterPath!);
                } else {
                  image = NetworkImage(defaultImage);
                }
                return Padding(
                  padding:
                      const EdgeInsets.all(8.0), // Tambahkan padding pada Card
                  child: Card(
                    color: Colors.white,
                    elevation: 2.0,
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailScreen(movies![position]),
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        backgroundImage: image,
                      ),
                      title: Text(movies![position].title ?? ''),
                      subtitle: Text(
                        'Released: ' +
                            (movies![position].releaseDate ?? '') +
                            ' - Vote: ' +
                            (movies![position].voteAverage?.toString() ?? ''),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryChip(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(category),
        selected: selectedCategory == category,
        onSelected: (isSelected) {
          if (isSelected) {
            updateCategory(category);
          }
        },
      ),
    );
  }
}
