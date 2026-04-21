import 'dart:convert';

import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/data/models/tv_series_response.dart';
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

  final tTvSeriesResponseModel =
      TvSeriesResponse(tvSeriesList: [tTvSeriesModel]);

  final tTvSeriesMapString = '''
  {
    "results": [
      {
        "adult": false,
        "backdrop_path": "/path.jpg",
        "genre_ids": [18],
        "id": 100,
        "original_name": "Original TV Name",
        "overview": "TV overview",
        "popularity": 55.1,
        "poster_path": "/poster.jpg",
        "first_air_date": "2024-01-01",
        "name": "TV Name",
        "vote_average": 8.1,
        "vote_count": 120
      }
    ]
  }
  ''';

  test('fromJson should return valid model', () {
    final result = TvSeriesResponse.fromJson(json.decode(tTvSeriesMapString));
    expect(result, tTvSeriesResponseModel);
  });

  test('toJson should return proper map data', () {
    final result = tTvSeriesResponseModel.toJson();
    final expectedJsonMap = json.decode(tTvSeriesMapString);
    expect(result, expectedJsonMap);
  });
}
