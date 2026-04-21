import 'dart:convert';

import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tMovieDetailModel = MovieDetailResponse.fromJson(
    json.decode(readJson('dummy_data/movie_detail.json')),
  );

  test('should be a subclass of MovieDetail entity', () {
    final result = tMovieDetailModel.toEntity();
    expect(result, isA<MovieDetail>());
  });

  test('toJson should contain proper map data', () {
    final result = tMovieDetailModel.toJson();
    expect(result['id'], 1);
    expect(result['title'], 'Title');
    expect(result['genres'], isNotEmpty);
  });
}
