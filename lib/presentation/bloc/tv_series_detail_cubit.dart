import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TvSeriesDetailState extends Equatable {
  const TvSeriesDetailState({
    this.tvSeries,
    this.tvSeriesState = RequestState.Empty,
    this.tvSeriesRecommendations = const [],
    this.recommendationState = RequestState.Empty,
    this.message = '',
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
  });

  final TvSeriesDetail? tvSeries;
  final RequestState tvSeriesState;
  final List<TvSeries> tvSeriesRecommendations;
  final RequestState recommendationState;
  final String message;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  TvSeriesDetailState copyWith({
    TvSeriesDetail? tvSeries,
    bool updateTvSeries = false,
    RequestState? tvSeriesState,
    List<TvSeries>? tvSeriesRecommendations,
    RequestState? recommendationState,
    String? message,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return TvSeriesDetailState(
      tvSeries: updateTvSeries ? tvSeries : this.tvSeries,
      tvSeriesState: tvSeriesState ?? this.tvSeriesState,
      tvSeriesRecommendations:
          tvSeriesRecommendations ?? this.tvSeriesRecommendations,
      recommendationState: recommendationState ?? this.recommendationState,
      message: message ?? this.message,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
        tvSeries,
        tvSeriesState,
        tvSeriesRecommendations,
        recommendationState,
        message,
        isAddedToWatchlist,
        watchlistMessage,
      ];
}

class TvSeriesDetailCubit extends Cubit<TvSeriesDetailState> {
  TvSeriesDetailCubit({
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendations,
    required this.getWatchlistTvSeriesStatus,
    required this.saveWatchlistTvSeries,
    required this.removeWatchlistTvSeries,
  }) : super(const TvSeriesDetailState());

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;
  final GetWatchlistTvSeriesStatus getWatchlistTvSeriesStatus;
  final SaveWatchlistTvSeries saveWatchlistTvSeries;
  final RemoveWatchlistTvSeries removeWatchlistTvSeries;

  Future<void> fetchTvSeriesDetail(int id) async {
    emit(
      state.copyWith(
        tvSeriesState: RequestState.Loading,
        recommendationState: RequestState.Empty,
        message: '',
      ),
    );

    final detailResult = await getTvSeriesDetail.execute(id);
    final recommendationResult = await getTvSeriesRecommendations.execute(id);

    detailResult.fold(
      (failure) => emit(
        state.copyWith(
          tvSeriesState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (tvSeries) {
        emit(
          state.copyWith(
            updateTvSeries: true,
            tvSeries: tvSeries,
            recommendationState: RequestState.Loading,
            message: '',
          ),
        );

        recommendationResult.fold(
          (failure) => emit(
            state.copyWith(
              tvSeriesState: RequestState.Loaded,
              recommendationState: RequestState.Error,
              message: failure.message,
            ),
          ),
          (tvSeriesData) => emit(
            state.copyWith(
              tvSeriesState: RequestState.Loaded,
              recommendationState: RequestState.Loaded,
              tvSeriesRecommendations: tvSeriesData,
              message: '',
            ),
          ),
        );
      },
    );
  }

  Future<void> addWatchlist(TvSeriesDetail tvSeries) async {
    final result = await saveWatchlistTvSeries.execute(tvSeries);
    final watchlistMessage = result.fold(
      (failure) => failure.message,
      (successMessage) => successMessage,
    );
    emit(state.copyWith(watchlistMessage: watchlistMessage));
    await loadWatchlistStatus(tvSeries.id);
  }

  Future<void> removeFromWatchlist(TvSeriesDetail tvSeries) async {
    final result = await removeWatchlistTvSeries.execute(tvSeries);
    final watchlistMessage = result.fold(
      (failure) => failure.message,
      (successMessage) => successMessage,
    );
    emit(state.copyWith(watchlistMessage: watchlistMessage));
    await loadWatchlistStatus(tvSeries.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchlistTvSeriesStatus.execute(id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }
}
