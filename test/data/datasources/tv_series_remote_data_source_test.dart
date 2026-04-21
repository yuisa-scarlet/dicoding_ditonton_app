import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_series_remote_data_source.dart';
import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:ditonton/data/models/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const apiKey = 'test_api_key';
  const apiKeyQuery = 'api_key=$apiKey';
  const baseUrl = 'https://api.themoviedb.org/3';

  late TvSeriesRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvSeriesRemoteDataSourceImpl(
      client: mockHttpClient,
      apiKey: apiKey,
    );
  });

  group('get On The Air TV Series', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/on_the_air_tv_series.json')),
    ).tvSeriesList;

    test('should return list of TvSeriesModel when response code is 200',
        () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKeyQuery')))
          .thenAnswer(
        (_) async => http.Response(
            readJson('dummy_data/on_the_air_tv_series.json'), 200),
      );

      final result = await dataSource.getOnTheAirTvSeries();

      expect(result, equals(tTvSeriesList));
    });

    test('should throw ServerException when response code is not 200',
        () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKeyQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getOnTheAirTvSeries();

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Popular TV Series', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/popular_tv_series.json')),
    ).tvSeriesList;

    test('should return list of tv series when response code is 200', () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKeyQuery')))
          .thenAnswer(
        (_) async =>
            http.Response(readJson('dummy_data/popular_tv_series.json'), 200),
      );

      final result = await dataSource.getPopularTvSeries();

      expect(result, tTvSeriesList);
    });

    test('should throw ServerException when response code is not 200',
        () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKeyQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getPopularTvSeries();

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Top Rated TV Series', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/top_rated_tv_series.json')),
    ).tvSeriesList;

    test('should return list of tv series when response code is 200', () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKeyQuery')))
          .thenAnswer(
        (_) async =>
            http.Response(readJson('dummy_data/top_rated_tv_series.json'), 200),
      );

      final result = await dataSource.getTopRatedTvSeries();

      expect(result, tTvSeriesList);
    });

    test('should throw ServerException when response code is not 200',
        () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKeyQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getTopRatedTvSeries();

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv series detail', () {
    final tId = 100;
    final tTvDetail = TvSeriesDetailResponse.fromJson(
      json.decode(readJson('dummy_data/tv_series_detail.json')),
    );

    test('should return detail when response code is 200', () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/$tId?$apiKeyQuery')))
          .thenAnswer(
        (_) async =>
            http.Response(readJson('dummy_data/tv_series_detail.json'), 200),
      );

      final result = await dataSource.getTvSeriesDetail(tId);

      expect(result, equals(tTvDetail));
    });

    test('should throw ServerException when response code is not 200',
        () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/$tId?$apiKeyQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getTvSeriesDetail(tId);

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv series recommendations', () {
    final tId = 100;
    final tTvSeriesList = TvSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/tv_series_recommendations.json')),
    ).tvSeriesList;

    test('should return list when response code is 200', () async {
      when(
        mockHttpClient.get(
          Uri.parse('$baseUrl/tv/$tId/recommendations?$apiKeyQuery'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          readJson('dummy_data/tv_series_recommendations.json'),
          200,
        ),
      );

      final result = await dataSource.getTvSeriesRecommendations(tId);

      expect(result, equals(tTvSeriesList));
    });

    test('should throw ServerException when response code is not 200',
        () async {
      when(
        mockHttpClient.get(
          Uri.parse('$baseUrl/tv/$tId/recommendations?$apiKeyQuery'),
        ),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getTvSeriesRecommendations(tId);

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search tv series', () {
    final tQuery = 'tv';
    final tTvSeriesList = TvSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/search_tv_series.json')),
    ).tvSeriesList;

    test('should return list when response code is 200', () async {
      when(
        mockHttpClient.get(
          Uri.parse('$baseUrl/search/tv?$apiKeyQuery&query=$tQuery'),
        ),
      ).thenAnswer(
        (_) async =>
            http.Response(readJson('dummy_data/search_tv_series.json'), 200),
      );

      final result = await dataSource.searchTvSeries(tQuery);

      expect(result, equals(tTvSeriesList));
    });

    test('should throw ServerException when response code is not 200',
        () async {
      when(
        mockHttpClient.get(
          Uri.parse('$baseUrl/search/tv?$apiKeyQuery&query=$tQuery'),
        ),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.searchTvSeries(tQuery);

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
