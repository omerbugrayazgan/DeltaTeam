// omdb api key f87e8a51
// example url: https://www.omdbapi.com/?i=tt3896198&apikey=f87e8a51&s=best films&type=movie
// example url: https://www.omdbapi.com/?i=tt3896198&apikey=f87e8a51&s=best films&type=series


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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: SafeArea(
        child: Column(
          children: [
            const TopBar(),
            // padding
            const SizedBox(height: 20),
            const SearchPart(),
            const SizedBox(height: 20),
            const MiddlePart(),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1F2937),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.star,
              color: Colors.white,
            ),
          ),
          Text(
            'DeltaMovies',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.filter_alt,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class SearchPart extends StatelessWidget {
  const SearchPart({Key? key}) : super(key: key);

  // simple searchbox with icon for filter (margin top )
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF1F2937),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2937),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.filter_list,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class MiddlePart extends StatefulWidget {
  const MiddlePart({Key? key}) : super(key: key);

  @override
  _MiddlePartState createState() => _MiddlePartState();
}

class _MiddlePartState extends State<MiddlePart> {

  // url "https://www.omdbapi.com/?i=tt3896198&apikey=f87e8a51&s=best films&type=movie
  final String url = "https://www.omdbapi.com/?i=tt3896198&apikey=f87e8a51&s=hobbit&type=movie";
  late Future<MovieCall> futureMovieCall ;

  // fetch data from url
  Future<MovieCall> fetchMovieCall() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return MovieCall.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Album bulunamadi');
    }
  }


  @override
  void initState() {
    super.initState();
    futureMovieCall = fetchMovieCall();
  }

  @override
  Widget build(BuildContext context) {
    // expandable listview
    return Expanded(
      child: FutureBuilder<MovieCall>(
        future: futureMovieCall,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.search!.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F2937),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(snapshot.data!.search![index].poster!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data!.search![index].title!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              snapshot.data!.search![index].year!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
    }

}

class BottomNavigationBarItem {
  const BottomNavigationBarItem({
    required this.icon,
    required this.label,
  });

  final Icon icon;
  final String label;
}

class BottomNavigationBar extends StatelessWidget {
  const BottomNavigationBar({Key? key, required List<BottomNavigationBarItem> items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Color(0xFF0D1117),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // onClick highlight the icon and text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // home, search, profile
            children: const [
              Icon(
                Icons.home,
                color: Colors.white,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Home',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),

            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // home, search, profile
            children: const [
              Icon(
                Icons.search,
                color: Colors.white,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Search',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // home, search, profile
            children: const [
              Icon(
                Icons.person,
                color: Colors.white,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}