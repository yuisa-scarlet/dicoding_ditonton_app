import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/season_model.dart';
import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/data/repositories/tv_series_repository_impl.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesRepositoryImpl repository;
  late MockTvSeriesRemoteDataSource mockRemoteDataSource;
  late MockTvSeriesLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTvSeriesRemoteDataSource();
    mockLocalDataSource = MockTvSeriesLocalDataSource();
    repository = TvSeriesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tTvSeriesModel = TvSeriesModel(
    adult: false,
    backdropPath: '/path.jpg',
    genreIds: const [18],
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

  final tTvSeries = TvSeries(
    adult: false,
    backdropPath: '/path.jpg',
    genreIds: const [18],
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

  final tTvSeriesModelList = <TvSeriesModel>[tTvSeriesModel];
  final tTvSeriesList = <TvSeries>[tTvSeries];

  group('On The Air TV Series', () {
    test('should return remote data when call is successful', () async {
      when(mockRemoteDataSource.getOnTheAirTvSeries())
          .thenAnswer((_) async => tTvSeriesModelList);

      final result = await repository.getOnTheAirTvSeries();

      verify(mockRemoteDataSource.getOnTheAirTvSeries());
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test('should return server failure when call is unsuccessful', () async {
      when(mockRemoteDataSource.getOnTheAirTvSeries())
          .thenThrow(ServerException());

      final result = await repository.getOnTheAirTvSeries();

      expect(result, equals(Left(ServerFailure(''))));
    });

    test('should return connection failure when not connected', () async {
      when(mockRemoteDataSource.getOnTheAirTvSeries())
          .thenThrow(const SocketException('Failed to connect to the network'));

      final result = await repository.getOnTheAirTvSeries();

      expect(
        result,
        equals(Left(ConnectionFailure('Failed to connect to the network'))),
      );
    });
  });

  group('Get TV Series Detail', () {
    final tId = 100;
    final tTvSeriesDetailResponse = TvSeriesDetailResponse(
      adult: false,
      backdropPath: '/path.jpg',
      genres: [GenreModel(id: 1, name: 'Drama')],
      id: 100,
      originalName: 'Original TV Name',
      overview: 'TV overview',
      posterPath: '/poster.jpg',
      firstAirDate: '2024-01-01',
      name: 'TV Name',
      voteAverage: 8.1,
      voteCount: 120,
      seasons: const [
        SeasonModel(
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

    test('should return detail data when call is successful', () async {
      when(mockRemoteDataSource.getTvSeriesDetail(tId))
          .thenAnswer((_) async => tTvSeriesDetailResponse);

      final result = await repository.getTvSeriesDetail(tId);

      verify(mockRemoteDataSource.getTvSeriesDetail(tId));
      expect(result, equals(Right(testTvSeriesDetail)));
    });

    test('should return server failure when detail call is unsuccessful',
        () async {
      when(mockRemoteDataSource.getTvSeriesDetail(tId))
          .thenThrow(ServerException());

      final result = await repository.getTvSeriesDetail(tId);

      expect(result, equals(Left(ServerFailure(''))));
    });

    test('should return connection failure when detail call has no network',
        () async {
      when(mockRemoteDataSource.getTvSeriesDetail(tId))
          .thenThrow(const SocketException('Failed to connect to the network'));

      final result = await repository.getTvSeriesDetail(tId);

      expect(
        result,
        equals(Left(ConnectionFailure('Failed to connect to the network'))),
      );
    });
  });

  group('Popular TV Series', () {
    test('should return tv series list when call is successful', () async {
      when(mockRemoteDataSource.getPopularTvSeries())
          .thenAnswer((_) async => tTvSeriesModelList);

      final result = await repository.getPopularTvSeries();

      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test('should return server failure when call is unsuccessful', () async {
      when(mockRemoteDataSource.getPopularTvSeries())
          .thenThrow(ServerException());

      final result = await repository.getPopularTvSeries();

      expect(result, equals(Left(ServerFailure(''))));
    });

    test('should return connection failure when call has no network', () async {
      when(mockRemoteDataSource.getPopularTvSeries())
          .thenThrow(const SocketException('Failed to connect to the network'));

      final result = await repository.getPopularTvSeries();

      expect(
        result,
        equals(Left(ConnectionFailure('Failed to connect to the network'))),
      );
    });
  });

  group('Top Rated TV Series', () {
    test('should return tv series list when call is successful', () async {
      when(mockRemoteDataSource.getTopRatedTvSeries())
          .thenAnswer((_) async => tTvSeriesModelList);

      final result = await repository.getTopRatedTvSeries();

      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test('should return server failure when call is unsuccessful', () async {
      when(mockRemoteDataSource.getTopRatedTvSeries())
          .thenThrow(ServerException());

      final result = await repository.getTopRatedTvSeries();

      expect(result, equals(Left(ServerFailure(''))));
    });

    test('should return connection failure when call has no network', () async {
      when(mockRemoteDataSource.getTopRatedTvSeries())
          .thenThrow(const SocketException('Failed to connect to the network'));

      final result = await repository.getTopRatedTvSeries();

      expect(
        result,
        equals(Left(ConnectionFailure('Failed to connect to the network'))),
      );
    });
  });

  group('Recommendations', () {
    const tId = 100;

    test('should return recommendation data when call is successful', () async {
      when(mockRemoteDataSource.getTvSeriesRecommendations(tId))
          .thenAnswer((_) async => tTvSeriesModelList);

      final result = await repository.getTvSeriesRecommendations(tId);

      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test('should return server failure when call is unsuccessful', () async {
      when(mockRemoteDataSource.getTvSeriesRecommendations(tId))
          .thenThrow(ServerException());

      final result = await repository.getTvSeriesRecommendations(tId);

      expect(result, equals(Left(ServerFailure(''))));
    });

    test('should return connection failure when call has no network', () async {
      when(mockRemoteDataSource.getTvSeriesRecommendations(tId))
          .thenThrow(const SocketException('Failed to connect to the network'));

      final result = await repository.getTvSeriesRecommendations(tId);

      expect(
        result,
        equals(Left(ConnectionFailure('Failed to connect to the network'))),
      );
    });
  });

  group('Search', () {
    const tQuery = 'tv';

    test('should return search result when call is successful', () async {
      when(mockRemoteDataSource.searchTvSeries(tQuery))
          .thenAnswer((_) async => tTvSeriesModelList);

      final result = await repository.searchTvSeries(tQuery);

      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test('should return server failure when call is unsuccessful', () async {
      when(mockRemoteDataSource.searchTvSeries(tQuery))
          .thenThrow(ServerException());

      final result = await repository.searchTvSeries(tQuery);

      expect(result, equals(Left(ServerFailure(''))));
    });

    test('should return connection failure when call has no network', () async {
      when(mockRemoteDataSource.searchTvSeries(tQuery))
          .thenThrow(const SocketException('Failed to connect to the network'));

      final result = await repository.searchTvSeries(tQuery);

      expect(
        result,
        equals(Left(ConnectionFailure('Failed to connect to the network'))),
      );
    });
  });

  group('save watchlist tv series', () {
    test('should return success message when saving successful', () async {
      when(mockLocalDataSource.insertWatchlistTvSeries(testTvSeriesTable))
          .thenAnswer((_) async => 'Added to Watchlist');

      final result = await repository.saveWatchlistTvSeries(testTvSeriesDetail);

      expect(result, const Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      when(mockLocalDataSource.insertWatchlistTvSeries(testTvSeriesTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));

      final result = await repository.saveWatchlistTvSeries(testTvSeriesDetail);

      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist tv series', () {
    test('should return success message when remove successful', () async {
      when(mockLocalDataSource.removeWatchlistTvSeries(testTvSeriesTable))
          .thenAnswer((_) async => 'Removed from Watchlist');

      final result =
          await repository.removeWatchlistTvSeries(testTvSeriesDetail);

      expect(result, const Right('Removed from Watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      when(mockLocalDataSource.removeWatchlistTvSeries(testTvSeriesTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));

      final result =
          await repository.removeWatchlistTvSeries(testTvSeriesDetail);

      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist tv series status', () {
    test('should return status whether data is found', () async {
      const tId = 100;
      when(mockLocalDataSource.getTvSeriesById(tId))
          .thenAnswer((_) async => null);

      final result = await repository.isAddedToWatchlistTvSeries(tId);

      expect(result, false);
    });
  });

  group('get watchlist tv series', () {
    test('should return list of TvSeries', () async {
      when(mockLocalDataSource.getWatchlistTvSeries())
          .thenAnswer((_) async => [testTvSeriesTable]);

      final result = await repository.getWatchlistTvSeries();

      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTvSeries]);
    });
  });
}
