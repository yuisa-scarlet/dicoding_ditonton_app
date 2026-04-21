import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/presentation/provider/popular_tv_series_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'popular_tv_series_notifier_test.mocks.dart';

@GenerateMocks([GetPopularTvSeries])
void main() {
  late PopularTvSeriesNotifier provider;
  late MockGetPopularTvSeries mockGetPopularTvSeries;

  setUp(() {
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    provider = PopularTvSeriesNotifier(mockGetPopularTvSeries);
  });

  test('should change state to loading when usecase is called', () {
    when(mockGetPopularTvSeries.execute())
        .thenAnswer((_) async => Right(testTvSeriesList));
    final result = provider.fetchPopularTvSeries();

    expect(provider.state, RequestState.Loading);
    expect(result, completion(isA<void>()));
  });

  test('should change tv series data when data is gotten successfully',
      () async {
    when(mockGetPopularTvSeries.execute())
        .thenAnswer((_) async => Right(testTvSeriesList));

    await provider.fetchPopularTvSeries();

    expect(provider.state, RequestState.Loaded);
    expect(provider.tvSeries, testTvSeriesList);
  });

  test('should return error when data is unsuccessful', () async {
    when(mockGetPopularTvSeries.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

    await provider.fetchPopularTvSeries();

    expect(provider.state, RequestState.Error);
    expect(provider.message, 'Server Failure');
  });
}
