import 'package:ditonton/data/models/tv_series_table.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  test('fromEntity should create valid TvSeriesTable', () {
    final result = TvSeriesTable.fromEntity(testTvSeriesDetail);
    expect(result, testTvSeriesTable);
  });

  test('toJson should return proper map data', () {
    final result = testTvSeriesTable.toJson();
    expect(result, testTvSeriesMap);
  });

  test('fromMap should return valid TvSeriesTable', () {
    final result = TvSeriesTable.fromMap(testTvSeriesMap);
    expect(result, testTvSeriesTable);
  });
}
