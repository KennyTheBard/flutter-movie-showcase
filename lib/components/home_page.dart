import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_movie_showcase/models/movie.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';

import 'movie_grid_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Movie> _movies = <Movie>[];
  final int pageSize = 20;
  int pageIndex = 1;
  bool _isLoadingMovies = false;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    setState(() {
      _isLoadingMovies = true;
    });

    final Uri url = Uri(
        scheme: 'https',
        host: 'yts.mx',
        pathSegments: <String>['api', 'v2', 'list_movies.json'],
        queryParameters: <String, String>{'limit': pageSize.toString(), 'page': pageIndex.toString()});

    final Response response = await get(url);

    setState(() {
      for (final dynamic movieJson in jsonDecode(response.body)['data']['movies'] as List<dynamic>) {
        _movies.add(Movie.fromJson(movieJson as Map<String, dynamic>));
      }
      _isLoadingMovies = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        color: const Color.fromRGBO(20, 20, 20, 1),
        child: Center(
          child: NotificationListener<ScrollEndNotification>(
            onNotification: (ScrollEndNotification scrollEnd) {
              final ScrollMetrics metrics = scrollEnd.metrics;
              if (metrics.atEdge && metrics.pixels > 0) {
                setState(() {
                  pageIndex++;
                  _loadMovies();
                });
              }
              return true;
            },
            child: CustomScrollView(
              slivers: <Widget>[
                // This one is scrolled first
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, childAspectRatio: _isLoadingMovies ? 0.65 : 0.58),
                  delegate: SliverChildListDelegate(<Widget>[
                    GridView.builder(
                        itemCount: _movies.length,
                        padding: const EdgeInsets.all(5.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, mainAxisSpacing: 10.0, crossAxisSpacing: 5.0, childAspectRatio: 0.69),
                        itemBuilder: (BuildContext context, int index) {
                          return MovieGridItem(
                            index: index,
                            movieId: _movies[index].id,
                            title: _movies[index].titleEnglish,
                            imageUrl: _movies[index].coverImage,
                            // onTap: onTap
                          );
                        }),
                  ]),
                ),
                // Then this one becomes visible and start scrolling as well
                SliverList(
                  delegate: SliverChildListDelegate(<Widget>[
                    if (_isLoadingMovies)
                      const Align(
                        alignment: Alignment.bottomCenter,
                        child: SpinKitThreeBounce(
                          color: Colors.white,
                          size: 50.0,
                        ),
                      ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
