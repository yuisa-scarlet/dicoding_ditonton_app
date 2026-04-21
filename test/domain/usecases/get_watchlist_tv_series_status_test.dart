import 'package:ditonton/domain/usecases/get_watchlist_tv_series_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistTvSeriesStatus usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetWatchlistTvSeriesStatus(mockTvSeriesRepository);
  });

  const tId = 100;

  test('should get watchlist tv series status from repository', () async {
    when(mockTvSeriesRepository.isAddedToWatchlistTvSeries(tId))
        .thenAnswer((_) async => true);

    final result = await usecase.execute(tId);

    expect(result, true);
  });
}
