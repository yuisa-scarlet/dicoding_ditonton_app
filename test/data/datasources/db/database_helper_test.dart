import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/tv_series_table.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late DatabaseHelper helper;

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    final dbPath = '${await getDatabasesPath()}/ditonton.db';
    await deleteDatabase(dbPath);
    helper = DatabaseHelper();
  });

  test('should perform CRUD for movie and tv watchlist', () async {
    final movie = MovieTable(
      id: 1,
      title: 'Movie 1',
      posterPath: '/movie.jpg',
      overview: 'Movie overview',
    );
    final tvSeries = TvSeriesTable(
      id: 100,
      name: 'TV 1',
      posterPath: '/tv.jpg',
      overview: 'TV overview',
    );

    final insertedMovie = await helper.insertWatchlist(movie);
    expect(insertedMovie, greaterThan(0));
    final insertedTv = await helper.insertWatchlistTvSeries(tvSeries);
    expect(insertedTv, greaterThan(0));

    final movieMap = await helper.getMovieById(movie.id);
    expect(movieMap?['title'], 'Movie 1');
    final tvMap = await helper.getTvSeriesById(tvSeries.id);
    expect(tvMap?['name'], 'TV 1');

    final movieList = await helper.getWatchlistMovies();
    expect(movieList, isNotEmpty);
    final tvList = await helper.getWatchlistTvSeries();
    expect(tvList, isNotEmpty);

    final removedMovie = await helper.removeWatchlist(movie);
    expect(removedMovie, 1);
    final removedTv = await helper.removeWatchlistTvSeries(tvSeries);
    expect(removedTv, 1);
  });
}
