import 'package:ditonton/domain/repositories/tv_series_repository.dart';

class GetWatchlistTvSeriesStatus {
  final TvSeriesRepository repository;

  GetWatchlistTvSeriesStatus(this.repository);

  Future<bool> execute(int id) {
    return repository.isAddedToWatchlistTvSeries(id);
  }
}
