import 'package:ditonton/data/models/movie_table.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  test('fromEntity should create valid MovieTable', () {
    final result = MovieTable.fromEntity(testMovieDetail);
    expect(result, testMovieTable);
  });

  test('toJson should return proper map data', () {
    final result = testMovieTable.toJson();
    expect(result, testMovieMap);
  });

  test('fromMap should return valid MovieTable', () {
    final result = MovieTable.fromMap(testMovieMap);
    expect(result, testMovieTable);
  });
}
