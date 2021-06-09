import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'models/movie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jolly Roger Cinema',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Jolly Roger Cinema'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Movie> _movies = <Movie>[];

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    final Uri url = Uri(scheme: 'https', host: 'yts.mx', pathSegments: <String>['api', 'v2', 'list_movies.json']);

    final Response response = await get(url);

    setState(() {
      for (final dynamic movieJson in jsonDecode(response.body)['data']['movies'] as List<dynamic>) {
        _movies.add(Movie.fromJson(movieJson as Map<String, dynamic>));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        color: Color.fromRGBO(20, 20, 20, 1),
        child: Center(
          child: GridView.builder(
              itemCount: _movies.length,
              padding: const EdgeInsets.all(5.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 10.0, crossAxisSpacing: 5.0, childAspectRatio: 0.69),
              itemBuilder: (BuildContext context, int index) {
                return Item(
                  index: index,
                  movieId: _movies[index].id,
                  imageUrl: _movies[index].coverImage,
                  // onTap: onTap
                );
              }),
        ),
      ),
    );
  }
}

typedef OnTap = void Function(int);

class Item extends StatelessWidget {
  const Item({
    Key? key,
    required this.index,
    required this.movieId,
    required this.imageUrl,
    // required this.onTap
  }) : super(key: key);

  final int index;
  final int movieId;
  final String imageUrl;

  // final OnTap onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        // onTap: () {
        //   onTap(index);
        // },
        child: Container(child: Image.network(imageUrl)));
  }
}
