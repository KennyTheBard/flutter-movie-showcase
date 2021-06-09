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
        primarySwatch: Colors.blue,
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
    print(jsonDecode(response.body)['data']['movies'][1]);

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
        body: Center(
          child: GridView.builder(
              itemCount: _movies.length,
              padding: const EdgeInsets.all(5.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 5.0, crossAxisSpacing: 5.0),
              itemBuilder: (BuildContext context, int index) {
                return Item(
                  index: index,
                  imageUrl: _movies[index].coverImage,
                  // onTap: onTap
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _loadMovies();
          },
          tooltip: 'Check',
          child: const Icon(Icons.auto_awesome),
        ));
  }
}

typedef OnTap = void Function(int);

class Item extends StatelessWidget {
  const Item({
    Key? key,
    required this.index,
    required this.imageUrl,
    // required this.onTap
  }) : super(key: key);

  final int index;
  final String imageUrl;

  // final OnTap onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        // onTap: () {
        //   onTap(index);
        // },
        child: Container(child: Text('$index')));
  }
}
