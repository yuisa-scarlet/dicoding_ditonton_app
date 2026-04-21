import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/provider/top_rated_tv_series_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'top_rated_tv_series_notifier_test.mocks.dart';

@GenerateMocks([GetTopRatedTvSeries])
void main() {
  late TopRatedTvSeriesNotifier provider;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;

  setUp(() {
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    provider =
        TopRatedTvSeriesNotifier(getTopRatedTvSeries: mockGetTopRatedTvSeries);
  });

  test('should change state to loading when usecase is called', () {
    when(mockGetTopRatedTvSeries.execute())
        .thenAnswer((_) async => Right(testTvSeriesList));
    final result = provider.fetchTopRatedTvSeries();

    expect(provider.state, RequestState.Loading);
    expect(result, completion(isA<void>()));
  });

  test('should change tv series data when data is gotten successfully',
      () async {
    when(mockGetTopRatedTvSeries.execute())
        .thenAnswer((_) async => Right(testTvSeriesList));

    await provider.fetchTopRatedTvSeries();

    expect(provider.state, RequestState.Loaded);
    expect(provider.tvSeries, testTvSeriesList);
  });

  test('should return error when data is unsuccessful', () async {
    when(mockGetTopRatedTvSeries.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

    await provider.fetchTopRatedTvSeries();

    expect(provider.state, RequestState.Error);
    expect(provider.message, 'Server Failure');
  });
}
