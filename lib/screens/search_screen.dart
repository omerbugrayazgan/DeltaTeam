import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:deltamovies/class/movies.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // add search word default is hobbit nd input from search bar.
  // fetch url on every search
  String searchWord = "hobbit";

  // setSearchState
  void setSearchState(String searchWord){
    // if null then set default 'hobbit'
    setState(() {
      // check if searchWord is null
      if(searchWord == ""){
        this.searchWord = "hobbit";
      }
      this.searchWord = searchWord;
    });
  }

  // fetch data from url
  Future<MovieCall> fetchMovieCall() async {
    final response = await http.get(Uri.parse("https://www.omdbapi.com/?i=tt3896198&apikey=f87e8a51&s=$searchWord&type=movie"));
    if (response.statusCode == 200) {
      return MovieCall.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  // return view of (Topbar, Searchbar(setSearchState), MiddlePart(fetchMovieCall))
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),
            SearchPart(setSearchState),
            SizedBox(height: 10),
            ResultPart(fetchMovieCall),
          ],
        ),
      ),
    );
  }
}

class SearchPart extends StatefulWidget {
  final Function(String) setSearchState;
  const SearchPart(this.setSearchState, {Key? key}) : super(key: key);

  // simple searchbox with icon for filter (margin top )
  @override
  _SearchPartState createState() => _SearchPartState();
}

class _SearchPartState extends State<SearchPart> {
  // search word
  String searchWord = "";

  // set search word
  void setSearchWord(String searchWord){
    setState(() {
      this.searchWord = searchWord;
    });
  }

  // set search word and call setSearchState
  void setSearchWordAndCallSetSearchState(String searchWord){
    setSearchWord(searchWord);
    widget.setSearchState(searchWord);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1F2937),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: TextField(
              onChanged: (value) => setSearchWordAndCallSetSearchState(value),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
            ),
          ),
          const Padding(
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

class ResultPart extends StatefulWidget {
  final Future<MovieCall> Function() fetchMovieCall;
  const ResultPart(this.fetchMovieCall, {Key? key}) : super(key: key);

  @override
  _ResultPartState createState() => _ResultPartState();
}

class _ResultPartState extends State<ResultPart> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<MovieCall>(
        future: widget.fetchMovieCall(),
        builder: (context, snapshot) {
          try {
            if (snapshot.hasData && snapshot.data!.search!.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.search!.length,
                itemBuilder: (context, index) {
                  // check snapshot.data!.search!.length if null show not found text
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
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
                              image: NetworkImage(
                                  snapshot.data!.search![index].poster!),
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
            } else {
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            }
          } catch (e) {
            return const Center(
              child: Text(
                'Not Found',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
        },

      ),
    );

  }
}