import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_series_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_series_notifier_test.mocks.dart';

@GenerateMocks([GetWatchlistTvSeries])
void main() {
  late WatchlistTvSeriesNotifier provider;
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;

  setUp(() {
    mockGetWatchlistTvSeries = MockGetWatchlistTvSeries();
    provider = WatchlistTvSeriesNotifier(
        getWatchlistTvSeries: mockGetWatchlistTvSeries);
  });

  test('should change data when data is gotten successfully', () async {
    when(mockGetWatchlistTvSeries.execute())
        .thenAnswer((_) async => Right(testTvSeriesList));

    await provider.fetchWatchlistTvSeries();

    expect(provider.watchlistState, RequestState.Loaded);
    expect(provider.watchlistTvSeries, testTvSeriesList);
  });

  test('should return error when data is unsuccessful', () async {
    when(mockGetWatchlistTvSeries.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

    await provider.fetchWatchlistTvSeries();

    expect(provider.watchlistState, RequestState.Error);
    expect(provider.message, 'Server Failure');
  });
}
