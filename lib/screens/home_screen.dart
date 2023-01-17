import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:deltamovies/class/movies.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // fetch data from url
  Future<MovieCall> fetchBestMoviesCall() async {
    final response = await http.get(Uri.parse("https://www.omdbapi.com/?i=tt3896198&apikey=f87e8a51&s=godfather&type=movie"));
    if (response.statusCode == 200) {
      return MovieCall.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            const Text(
              "Classic Movies",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black,
                    offset: Offset(5.0, 5.0),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            HomeMovies(fetchBestMoviesCall),
          ],
        ),
      ),
    );
  }
}

class HomeMovies extends StatefulWidget {
  final Future<MovieCall> Function() fetchMovieCall;
  const HomeMovies(this.fetchMovieCall, {Key? key}) : super(key: key);

  @override
  _HomeMoviesState createState() => _HomeMoviesState();
}

class _HomeMoviesState extends State<HomeMovies> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MovieCall>(
      future: widget.fetchMovieCall(),
      builder: (context, snapshot) {
        try {
          if (snapshot.hasData && snapshot.data!.search!.isNotEmpty) {
            // gridview builder with scroll
            return Expanded(
              child: GridView.builder(
                itemCount: snapshot.data!.search!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    child: Column(
                      children: [
                        // image and title on image caption
                        Expanded(
                          flex: 3,
                          child: Stack(
                            children: [
                              // image
                              Image.network(
                                snapshot.data!.search![index].poster!,
                                fit: BoxFit.cover,
                                // full width image
                                width: double.infinity,
                              ),
                              // title on image caption
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  color: Colors.black54,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10,
                                  ),
                                  child: Text(
                                    snapshot.data!.search![index].title!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      // align text to center
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
          else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          else {
            return const Center(child: CircularProgressIndicator());
          }
        } catch (e) {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
