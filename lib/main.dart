import 'package:flutter/material.dart';
import 'package:newpractise/api.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MovieSearchApp(),
  ));
}

class MovieSearchApp extends StatefulWidget {
  @override
  _MovieSearchAppState createState() => _MovieSearchAppState();
}

class _MovieSearchAppState extends State<MovieSearchApp> {
  final TextEditingController _searchController = TextEditingController();
  final TMDBApiService _apiService = TMDBApiService();
  List<dynamic> _movies = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPopularMovies();
    setState(() {
      _searchMovies();
    });
  }

  void _fetchPopularMovies() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final movies =
          await _apiService.getPopularMovies(); // Fetch popular movies
      setState(() {
        _movies = movies;
      });
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _searchMovies() async {
    final query = _searchController.text;
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final movies = await _apiService.searchMovies(query);
      setState(() {
        _movies = movies;
      });
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              child: TextFormField(
                onChanged: (value) {
                  _searchMovies();
                },
                cursorHeight: 28,
                controller: _searchController,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  labelText: 'Search Movies',
                  labelStyle: TextStyle(color: Colors.black),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: _searchMovies,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Popular Movies',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: _movies.length,
                      itemBuilder: (context, index) {
                        final movie = _movies[index];
                        final posterPath = movie['poster_path'];
                        final title = movie['title'] ?? 'No Title';
                        final genres =
                            "Action | Future | Science"; // Replace with actual genres if available
                        final rating = (movie['vote_average'] as double?)
                                ?.toStringAsFixed(1) ??
                            'N/A';
                        return card(
                            posterPath: posterPath,
                            title: title,
                            genres: genres,
                            rating: rating);
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class card extends StatelessWidget {
  const card({
    super.key,
    required this.posterPath,
    required this.title,
    required this.genres,
    required this.rating,
  });

  final String? posterPath;
  final String title;
  final String genres;
  final String rating;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              child: Image.network(
                'https://image.tmdb.org/t/p/w500$posterPath',
                width: 100,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      genres,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: double.tryParse(rating) != null &&
                                double.parse(rating) >= 7
                            ? Color(0xFF5EC570) // Green if rating >= 7
                            : Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$rating IMDB',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'tmdb_api_service.dart'; // Import the API service file

// class MovieSearchApp extends StatefulWidget {
//   @override
//   _MovieSearchAppState createState() => _MovieSearchAppState();
// }

// class _MovieSearchAppState extends State<MovieSearchApp> {
//   final TextEditingController _searchController = TextEditingController();
//   final TMDBApiService _apiService = TMDBApiService();
//   List<dynamic> _movies = [];
//   bool _isLoading = false;

//   void _searchMovies() async {
//     final query = _searchController.text;
//     if (query.isEmpty) return;

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final movies = await _apiService.searchMovies(query);
//       setState(() {
//         _movies = movies;
//         print(movies);
//       });
//     } catch (e) {
//       print('Error: $e');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           title: Text(
//         'Home',
//         style: TextStyle(
//           fontFamily: 'Montserrat',
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//         ),
//       )),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Container(
//               child: TextFormField(
//                 controller: _searchController,
//                 decoration: InputDecoration(
//                   focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.black, width: 1.7)),
//                   // fillColor: Colors.black,
//                   hoverColor: Colors.black,
//                   // fillColor: Colors.black,
//                   focusColor: Colors.black,
//                   border: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.black, width: 1.7)),
//                   labelText: 'Search Movies',
//                   suffixIcon: IconButton(
//                     icon: Icon(Icons.search),
//                     onPressed: _searchMovies,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             // if(_isLoading==false)

//             _isLoading
//                 ? CircularProgressIndicator()
//                 : Expanded(
//                     child: ListView.builder(
//                       itemCount: _movies.length,
//                       itemBuilder: (context, index) {
//                         final movie = _movies[index];
//                         final posterPath = movie['poster_path'];
//                         final title = movie['title'] ?? 'No Title';
//                         final genres =
//                             "Action | Future | Science"; // Replace with actual genres if available
//                         // final rating =

//                         final rating = (movie['vote_average'] as double?)
//                                 ?.toStringAsFixed(1) ??
//                             'N/A';

//                         // movie['vote_average']?.toString() ?? 'N/A';

//                         return Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 8.0),
//                           child: Card(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             elevation: 4,
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.only(
//                                     topLeft: Radius.circular(10),
//                                     bottomLeft: Radius.circular(10),
//                                   ),
//                                   child:
//                                       //  CachedNetworkImage(
//                                       //   imageUrl:
//                                       //       'https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg',
//                                       // 'https://image.tmdb.org/t/p/w500$posterPath',
//                                       //   width: 100,
//                                       //   height: 150,
//                                       //   fit: BoxFit.cover,
//                                       //   // placeholder: (context, url) =>
//                                       //   //     CircularProgressIndicator(),
//                                       //   // errorWidget: (context, url, error) =>
//                                       //   // Icon(Icons.error),
//                                       // ),
//                                       Image.network(
//                                     width: 100,
//                                     height: 150,
//                                     fit: BoxFit.cover,
//                                     'https://image.tmdb.org/t/p/w500$posterPath',

//                                     // 'https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg',
//                                   ),
//                                 ),
//                                 SizedBox(width: 10),
//                                 Expanded(
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           title,
//                                           style: TextStyle(
//                                             fontFamily: 'Montserrat',
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         SizedBox(height: 5),
//                                         Text(
//                                           genres,
//                                           style: TextStyle(
//                                             fontFamily: 'Montserrat',
//                                             fontSize: 14,
//                                             color: Colors.grey,
//                                           ),
//                                         ),
//                                         SizedBox(height: 10),
//                                         Container(
//                                           padding: EdgeInsets.symmetric(
//                                               horizontal: 8, vertical: 4),
//                                           decoration: BoxDecoration(
//                                             color: double.tryParse(rating) !=
//                                                         null &&
//                                                     double.parse(rating) >= 7
//                                                 ? Color(
//                                                     0xFF5EC570) // Green if rating >= 7
//                                                 : Colors.blue,
//                                             borderRadius:
//                                                 BorderRadius.circular(12),
//                                           ),
//                                           child: Text(
//                                             '${rating} IMDB',
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 12,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }





// import 'package:flutter/material.dart';
// import 'tmdb_api_service.dart'; // Import the API service file

// class MovieSearchApp extends StatefulWidget {
//   @override
//   _MovieSearchAppState createState() => _MovieSearchAppState();
// }

// class _MovieSearchAppState extends State<MovieSearchApp> {
//   final TextEditingController _searchController = TextEditingController();
//   final TMDBApiService _apiService = TMDBApiService();
//   List<dynamic> _movies = [];
//   bool _isLoading = false;

//   void _searchMovies() async {
//     final query = _searchController.text;
//     if (query.isEmpty) return;

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final movies = await _apiService.searchMovies(query);
//       setState(() {
//         _movies = movies;
//         print(movies);
//       });
//     } catch (e) {
//       print('Error: $e');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Movie Search')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 labelText: 'Search Movies',
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.search),
//                   onPressed: _searchMovies,
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             _isLoading
//                 ? CircularProgressIndicator()
//                 : Expanded(
//                     child: ListView.builder(
//                       itemCount: _movies.length,
//                       itemBuilder: (context, index) {
//                         final movie = _movies[index];
//                         return Card(
//                           child: Column(
//                             children: [Image(image: movie['backdrop_path'])],
//                           ),
//                         );
//                         // ListTile(
//                         //   title: Text(movie['title'] ?? 'No Title'),
//                         //   subtitle: Text(movie['release_date'] ?? 'No Date'),
//                         // );
//                       },
//                     ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// class movieCard extends StatefulWidget {
//   const movieCard({super.key});

//   @override
//   State<movieCard> createState() => _movieCardState();
// }

// class _movieCardState extends State<movieCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Column(children: [

//         Image(image: movies)
//       ],),
//     );
//   }
// }