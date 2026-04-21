import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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

  test('should be a subclass of TvSeries entity', () {
    final result = tTvSeriesModel.toEntity();
    expect(result, isA<TvSeries>());
  });
}
