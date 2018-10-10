import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_catalog/models/movie.dart';
import 'package:movie_catalog/screens/movie_details_screen.dart';
import 'package:movie_catalog/screens/movie_details_screen_design.dart';
import 'package:movie_catalog/services/movie_service.dart';
import 'package:movie_catalog/services/storage_service.dart';

import 'package:http/http.dart' as http;

import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:movie_catalog/colors.dart';

class MovieCardGrid extends StatelessWidget {
  Movie movie;
  MovieService _movieService;
  StorageService storageService = new StorageService();

  MovieCardGrid({this.movie}) {
    _movieService = new MovieService();
    if (movie.torrents.length == 0) {
      addMovieDetails(movie.id)
          .then((Movie updated) => movie.torrents = updated.torrents);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              maintainState: true,
              builder: (context) => MovieDetailsDesign(
                    movie: movie,
                  ),
            ),
          ),
      child: _buildCard(context: context),
    );
  }

  Widget _buildCard({BuildContext context}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
      child: Card(
        elevation: 5.0,
        color: Theme.of(context).primaryColorLight,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: FadeInImage.assetNetwork(
                  fadeInDuration: Duration(milliseconds: 750),
                  image: movie.coverImageMedium ??
                      movie.coverImageLarge ??
                      'assets/images/cover_placeholder.jpg',
                  placeholder: 'assets/images/cover_placeholder.jpg',
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(7.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      movie.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 2.0),
                    ),
                    Text(
                      movie.year.toString(),
                      style: TextStyle(
                        color: kIconColor,
                        fontSize: 13.0,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildLabels() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildYearLabel(),
          _buildTitleLabel(),
          _buildRating(),
          _buildCategoriesLabel(),
        ],
      ),
    );
  }

  Widget _buildYearLabel() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0),
      child: Text(
        movie.year.toString().toUpperCase(),
        style: TextStyle(
            color: Colors.grey[500],
            fontSize: 15.0,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildTitleLabel() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.0),
      child: Text(
        movie.title.toString(),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
            color: Colors.white, fontSize: 19.0, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildCategoriesLabel() {
    final String genreString = 'Genres:'.toUpperCase();
    String genres = '';

    String formattedGenres = '';
    if (movie.genres.length > 0) {
      movie.genres.forEach((genre) {
        genres += (genre + ', ');
      });
      formattedGenres = genres.substring(0, genres.length - 2);
    } else {
      formattedGenres = 'No genres';
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        formattedGenres,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: TextStyle(
            color: Colors.grey[500],
            fontSize: 15.0,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.2),
      ),
    );
  }

  Widget _buildRating() {
    double amountOfStars = movie.rating / 2;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3.0),
            child: SmoothStarRating(
                allowHalfRating: true,
                starCount: 5,
                rating: amountOfStars,
                size: 17.0,
                color: kAccentColor,
                borderColor: Colors.grey[600]),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 7.0,
            ),
            alignment: Alignment.center,
            height: 20.0,
            child: Text(
              movie.rating.toString(),
              style: TextStyle(color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }


  Future<Movie> addMovieDetails(int id) async {
    Movie movie = await _movieService.fetchMovieById(http.Client(), id);
    return movie;
  }
}