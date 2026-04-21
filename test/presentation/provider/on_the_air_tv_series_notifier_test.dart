import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:ditonton/presentation/provider/on_the_air_tv_series_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'on_the_air_tv_series_notifier_test.mocks.dart';

@GenerateMocks([GetOnTheAirTvSeries])
void main() {
  late OnTheAirTvSeriesNotifier provider;
  late MockGetOnTheAirTvSeries mockGetOnTheAirTvSeries;

  setUp(() {
    mockGetOnTheAirTvSeries = MockGetOnTheAirTvSeries();
    provider = OnTheAirTvSeriesNotifier(mockGetOnTheAirTvSeries);
  });

  test('should change state to loading when usecase is called', () {
    when(mockGetOnTheAirTvSeries.execute())
        .thenAnswer((_) async => Right(testTvSeriesList));
    final result = provider.fetchOnTheAirTvSeries();

    expect(provider.state, RequestState.Loading);
    expect(result, completion(isA<void>()));
  });

  test('should change tv series data when data is gotten successfully',
      () async {
    when(mockGetOnTheAirTvSeries.execute())
        .thenAnswer((_) async => Right(testTvSeriesList));

    await provider.fetchOnTheAirTvSeries();

    expect(provider.state, RequestState.Loaded);
    expect(provider.tvSeries, testTvSeriesList);
  });

  test('should return error when data is unsuccessful', () async {
    when(mockGetOnTheAirTvSeries.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

    await provider.fetchOnTheAirTvSeries();

    expect(provider.state, RequestState.Error);
    expect(provider.message, 'Server Failure');
  });
}
