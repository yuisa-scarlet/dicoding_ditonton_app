import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/tv_series_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testTvSeries = TvSeries(
  adult: false,
  backdropPath: '/path.jpg',
  genreIds: [18],
  id: 100,
  originalName: 'Original TV Name',
  overview: 'TV overview',
  popularity: 55.1,
  posterPath: '/poster.jpg',
  firstAirDate: '2024-01-01',
  name: 'TV Name',
  voteAverage: 8.1,
  voteCount: 120,
);

final testTvSeriesList = [testTvSeries];

final testTvSeriesDetail = TvSeriesDetail(
  adult: false,
  backdropPath: '/path.jpg',
  genres: [Genre(id: 1, name: 'Drama')],
  id: 100,
  originalName: 'Original TV Name',
  overview: 'TV overview',
  posterPath: '/poster.jpg',
  firstAirDate: '2024-01-01',
  name: 'TV Name',
  voteAverage: 8.1,
  voteCount: 120,
  seasons: const [
    Season(
      airDate: '2024-01-01',
      episodeCount: 8,
      id: 101,
      name: 'Season 1',
      overview: 'Season overview',
      posterPath: '/season.jpg',
      seasonNumber: 1,
    )
  ],
  numberOfEpisodes: 8,
  numberOfSeasons: 1,
);

final testWatchlistTvSeries = TvSeries.watchlist(
  id: 100,
  name: 'TV Name',
  posterPath: '/poster.jpg',
  overview: 'TV overview',
);

final testTvSeriesTable = TvSeriesTable(
  id: 100,
  name: 'TV Name',
  posterPath: '/poster.jpg',
  overview: 'TV overview',
);

final testTvSeriesMap = {
  'id': 100,
  'overview': 'TV overview',
  'posterPath': '/poster.jpg',
  'name': 'TV Name',
};
