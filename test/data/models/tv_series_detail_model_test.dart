import 'dart:convert';

import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTvSeriesDetailModel = TvSeriesDetailResponse.fromJson(
    json.decode(readJson('dummy_data/tv_series_detail.json')),
  );

  test('should be a subclass of TvSeriesDetail entity', () {
    final result = tTvSeriesDetailModel.toEntity();
    expect(result, isA<TvSeriesDetail>());
    expect(result.seasons, isNotEmpty);
  });

  test('toJson should contain proper map data', () {
    final result = tTvSeriesDetailModel.toJson();
    expect(result['id'], 100);
    expect(result['name'], 'TV Name');
    expect(result['seasons'], isNotEmpty);
  });
}
