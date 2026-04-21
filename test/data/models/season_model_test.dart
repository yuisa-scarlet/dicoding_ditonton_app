import 'package:ditonton/data/models/season_model.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tSeasonModel = SeasonModel(
    airDate: '2024-01-01',
    episodeCount: 8,
    id: 101,
    name: 'Season 1',
    overview: 'Season overview',
    posterPath: '/season.jpg',
    seasonNumber: 1,
  );

  test('should be a subclass of Season entity', () {
    final result = tSeasonModel.toEntity();
    expect(result, isA<Season>());
  });

  test('toJson should return proper map data', () {
    final result = tSeasonModel.toJson();
    expect(result['id'], 101);
    expect(result['season_number'], 1);
  });

  test('fromJson should return valid model', () {
    final result = SeasonModel.fromJson({
      'air_date': '2024-01-01',
      'episode_count': 8,
      'id': 101,
      'name': 'Season 1',
      'overview': 'Season overview',
      'poster_path': '/season.jpg',
      'season_number': 1,
    });
    expect(result, tSeasonModel);
  });
}
