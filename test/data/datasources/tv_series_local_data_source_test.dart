import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_series_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource =
        TvSeriesLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('save watchlist tv series', () {
    test('should return success message when insert to database succeeds',
        () async {
      when(mockDatabaseHelper.insertWatchlistTvSeries(testTvSeriesTable))
          .thenAnswer((_) async => 1);

      final result =
          await dataSource.insertWatchlistTvSeries(testTvSeriesTable);

      expect(result, 'Added to Watchlist');
    });

    test('should throw DatabaseException when insert fails', () async {
      when(mockDatabaseHelper.insertWatchlistTvSeries(testTvSeriesTable))
          .thenThrow(Exception('Failed to insert'));

      final call = dataSource.insertWatchlistTvSeries(testTvSeriesTable);

      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('remove watchlist tv series', () {
    test('should return success message when remove from database succeeds',
        () async {
      when(mockDatabaseHelper.removeWatchlistTvSeries(testTvSeriesTable))
          .thenAnswer((_) async => 1);

      final result =
          await dataSource.removeWatchlistTvSeries(testTvSeriesTable);

      expect(result, 'Removed from Watchlist');
    });

    test('should throw DatabaseException when remove fails', () async {
      when(mockDatabaseHelper.removeWatchlistTvSeries(testTvSeriesTable))
          .thenThrow(Exception('Failed to remove'));

      final call = dataSource.removeWatchlistTvSeries(testTvSeriesTable);

      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('Get TV Series by id', () {
    test('should return TvSeriesTable when data found', () async {
      when(mockDatabaseHelper.getTvSeriesById(100))
          .thenAnswer((_) async => testTvSeriesMap);

      final result = await dataSource.getTvSeriesById(100);

      expect(result, testTvSeriesTable);
    });

    test('should return null when data not found', () async {
      when(mockDatabaseHelper.getTvSeriesById(100))
          .thenAnswer((_) async => null);

      final result = await dataSource.getTvSeriesById(100);

      expect(result, null);
    });
  });

  group('get watchlist tv series', () {
    test('should return list of TvSeriesTable from database', () async {
      when(mockDatabaseHelper.getWatchlistTvSeries())
          .thenAnswer((_) async => [testTvSeriesMap]);

      final result = await dataSource.getWatchlistTvSeries();

      expect(result, [testTvSeriesTable]);
    });
  });
}
