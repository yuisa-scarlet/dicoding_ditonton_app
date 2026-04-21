import 'package:dartz/dartz.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/provider/tv_series_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_series_list_notifier_test.mocks.dart';

@GenerateMocks([
  GetOnTheAirTvSeries,
  GetPopularTvSeries,
  GetTopRatedTvSeries,
])
void main() {
  late TvSeriesListNotifier provider;
  late MockGetOnTheAirTvSeries mockGetOnTheAirTvSeries;
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;

  setUp(() {
    mockGetOnTheAirTvSeries = MockGetOnTheAirTvSeries();
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    provider = TvSeriesListNotifier(
      getOnTheAirTvSeries: mockGetOnTheAirTvSeries,
      getPopularTvSeries: mockGetPopularTvSeries,
      getTopRatedTvSeries: mockGetTopRatedTvSeries,
    );
  });

  test('should change on-the-air state and data when success', () async {
    when(mockGetOnTheAirTvSeries.execute())
        .thenAnswer((_) async => Right(testTvSeriesList));

    await provider.fetchOnTheAirTvSeries();

    expect(provider.onTheAirState, RequestState.Loaded);
    expect(provider.onTheAirTvSeries, testTvSeriesList);
  });

  test('should return error state when on-the-air failed', () async {
    when(mockGetOnTheAirTvSeries.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

    await provider.fetchOnTheAirTvSeries();

    expect(provider.onTheAirState, RequestState.Error);
    expect(provider.message, 'Server Failure');
  });

  test('should change popular state and data when success', () async {
    when(mockGetPopularTvSeries.execute())
        .thenAnswer((_) async => Right(testTvSeriesList));

    await provider.fetchPopularTvSeries();

    expect(provider.popularTvSeriesState, RequestState.Loaded);
    expect(provider.popularTvSeries, testTvSeriesList);
  });

  test('should return error state when popular failed', () async {
    when(mockGetPopularTvSeries.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

    await provider.fetchPopularTvSeries();

    expect(provider.popularTvSeriesState, RequestState.Error);
    expect(provider.message, 'Server Failure');
  });

  test('should change top-rated state and data when success', () async {
    when(mockGetTopRatedTvSeries.execute())
        .thenAnswer((_) async => Right(testTvSeriesList));

    await provider.fetchTopRatedTvSeries();

    expect(provider.topRatedTvSeriesState, RequestState.Loaded);
    expect(provider.topRatedTvSeries, testTvSeriesList);
  });

  test('should return error state when top-rated failed', () async {
    when(mockGetTopRatedTvSeries.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

    await provider.fetchTopRatedTvSeries();

    expect(provider.topRatedTvSeriesState, RequestState.Error);
    expect(provider.message, 'Server Failure');
  });
}
