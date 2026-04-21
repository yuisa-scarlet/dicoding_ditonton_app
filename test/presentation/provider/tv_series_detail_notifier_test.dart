import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import 'package:ditonton/presentation/provider/tv_series_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_series_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTvSeriesDetail,
  GetTvSeriesRecommendations,
  GetWatchlistTvSeriesStatus,
  SaveWatchlistTvSeries,
  RemoveWatchlistTvSeries,
])
void main() {
  late TvSeriesDetailNotifier provider;
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;
  late MockGetWatchlistTvSeriesStatus mockGetWatchlistTvSeriesStatus;
  late MockSaveWatchlistTvSeries mockSaveWatchlistTvSeries;
  late MockRemoveWatchlistTvSeries mockRemoveWatchlistTvSeries;

  setUp(() {
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    mockGetWatchlistTvSeriesStatus = MockGetWatchlistTvSeriesStatus();
    mockSaveWatchlistTvSeries = MockSaveWatchlistTvSeries();
    mockRemoveWatchlistTvSeries = MockRemoveWatchlistTvSeries();

    provider = TvSeriesDetailNotifier(
      getTvSeriesDetail: mockGetTvSeriesDetail,
      getTvSeriesRecommendations: mockGetTvSeriesRecommendations,
      getWatchlistTvSeriesStatus: mockGetWatchlistTvSeriesStatus,
      saveWatchlistTvSeries: mockSaveWatchlistTvSeries,
      removeWatchlistTvSeries: mockRemoveWatchlistTvSeries,
    );
  });

  const tId = 100;

  test('should change detail state to Loaded when data is gotten successfully',
      () async {
    when(mockGetTvSeriesDetail.execute(tId))
        .thenAnswer((_) async => Right(testTvSeriesDetail));
    when(mockGetTvSeriesRecommendations.execute(tId))
        .thenAnswer((_) async => Right(testTvSeriesList));

    await provider.fetchTvSeriesDetail(tId);

    expect(provider.tvSeriesState, RequestState.Loaded);
    expect(provider.tvSeries, testTvSeriesDetail);
    expect(provider.tvSeriesRecommendations, testTvSeriesList);
  });

  test('should return Error when detail request is unsuccessful', () async {
    when(mockGetTvSeriesDetail.execute(tId))
        .thenAnswer((_) async => Left(ServerFailure('Failed')));
    when(mockGetTvSeriesRecommendations.execute(tId))
        .thenAnswer((_) async => Right(testTvSeriesList));

    await provider.fetchTvSeriesDetail(tId);

    expect(provider.tvSeriesState, RequestState.Error);
    expect(provider.message, 'Failed');
  });

  test('should update watchlist status', () async {
    when(mockGetWatchlistTvSeriesStatus.execute(tId))
        .thenAnswer((_) async => true);

    await provider.loadWatchlistStatus(tId);

    expect(provider.isAddedToWatchlist, true);
  });

  test('should set recommendation state Error when recommendation call fails',
      () async {
    when(mockGetTvSeriesDetail.execute(tId))
        .thenAnswer((_) async => Right(testTvSeriesDetail));
    when(mockGetTvSeriesRecommendations.execute(tId))
        .thenAnswer((_) async => Left(ServerFailure('Failed recommendation')));

    await provider.fetchTvSeriesDetail(tId);

    expect(provider.recommendationState, RequestState.Error);
    expect(provider.message, 'Failed recommendation');
  });

  test('should set watchlist message when addWatchlist success', () async {
    when(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail))
        .thenAnswer((_) async => const Right('Added to Watchlist'));
    when(mockGetWatchlistTvSeriesStatus.execute(tId))
        .thenAnswer((_) async => true);

    await provider.addWatchlist(testTvSeriesDetail);

    expect(provider.watchlistMessage, 'Added to Watchlist');
    expect(provider.isAddedToWatchlist, true);
  });

  test('should set watchlist message when removeFromWatchlist failed',
      () async {
    when(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail))
        .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
    when(mockGetWatchlistTvSeriesStatus.execute(tId))
        .thenAnswer((_) async => false);

    await provider.removeFromWatchlist(testTvSeriesDetail);

    expect(provider.watchlistMessage, 'Failed');
    expect(provider.isAddedToWatchlist, false);
  });
}
