import 'dart:async';

import 'package:flutter/material.dart';

import 'package:movie_catalog/models/movie.dart';
import 'package:movie_catalog/services/movie_service.dart';
import 'package:movie_catalog/services/storage_service.dart';

import 'package:http/http.dart' as http;
import 'package:movie_catalog/widgets/movie_card_design.dart';

class MovieList extends StatefulWidget {
  StorageService _storageService;
  List<Movie> movies;
  final String type;
  // config used for passing the filter config
  dynamic config;

  MovieList(this.movies, this.type, [this.config]) {
    _storageService = new StorageService();
    if (type == 'liked') {
      print('old ${movies.length}');
      _fetchSavedMovies()
          .then((movies) => print(movies.length.toString() + '\n======'));
      print('moviegrid constructor is called $type');
      if (type == 'liked') {
        print('true');
        createState().mounted;
      }
    }
  }

  Future<List<Movie>> _fetchSavedMovies() async {
    List<Movie> movies = await _storageService.readFile();
    return movies;
  }

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList>
    with AutomaticKeepAliveClientMixin<MovieList> {
  List<Movie> movies;
  MovieService _movieService;
  ScrollController _scrollController;

  int currentPageLatest = 2;
  int currentPagePopular = 2;
  int currentPageConfig = 2;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    movies = widget.movies;
    _movieService = new MovieService();

    _scrollController = new ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void deactivate() {
    _scrollController.removeListener(() => _scrollController);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return movies.length > 0
        ? ListView.builder(
            padding: EdgeInsets.fromLTRB(0.0, 12.0, 2.0, 0.0),
            controller: _scrollController,
            // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //   crossAxisCount: 3,
            //   childAspectRatio: 0.545,
            // ),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return new Column(
                children: <Widget>[
                  MovieCardDesign(
                    movie: movies[index],
                  ),
                ],
              );
            },
          )
        : Center(
            child: widget.type != 'liked'
                ? Text('Your library is empty')
                : Text('Your shelf is empty'));
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (widget.type == 'latest') {
        _movieService
            .fetchLatestMovies(http.Client(), currentPageLatest)
            .then((newMovies) {
          setState(() {
            movies.addAll(newMovies);
          });
          currentPageLatest++;
        });
      }
      if (widget.type == 'popular') {
        _movieService
            .fetchPopularMovies(http.Client(), currentPagePopular)
            .then((newMovies) {
          setState(() {
            movies.addAll(newMovies);
          });
          currentPagePopular++;
        });
      }
      if (widget.type == 'config') {
        _movieService
            .fetchMoviesByConfig(
                http.Client(),
                currentPageConfig,
                widget.config['genre'],
                widget.config['quality'],
                widget.config['rating'])
            .then((newMovies) {
          setState(() {
            widget.movies.addAll(newMovies);
          });
          currentPageConfig++;
        });
      }
    }
  }
}