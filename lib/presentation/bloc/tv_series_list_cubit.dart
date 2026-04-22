import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TvSeriesListState extends Equatable {
  const TvSeriesListState({
    this.onTheAirTvSeries = const [],
    this.onTheAirState = RequestState.Empty,
    this.popularTvSeries = const [],
    this.popularTvSeriesState = RequestState.Empty,
    this.topRatedTvSeries = const [],
    this.topRatedTvSeriesState = RequestState.Empty,
    this.message = '',
  });

  final List<TvSeries> onTheAirTvSeries;
  final RequestState onTheAirState;
  final List<TvSeries> popularTvSeries;
  final RequestState popularTvSeriesState;
  final List<TvSeries> topRatedTvSeries;
  final RequestState topRatedTvSeriesState;
  final String message;

  TvSeriesListState copyWith({
    List<TvSeries>? onTheAirTvSeries,
    RequestState? onTheAirState,
    List<TvSeries>? popularTvSeries,
    RequestState? popularTvSeriesState,
    List<TvSeries>? topRatedTvSeries,
    RequestState? topRatedTvSeriesState,
    String? message,
  }) {
    return TvSeriesListState(
      onTheAirTvSeries: onTheAirTvSeries ?? this.onTheAirTvSeries,
      onTheAirState: onTheAirState ?? this.onTheAirState,
      popularTvSeries: popularTvSeries ?? this.popularTvSeries,
      popularTvSeriesState: popularTvSeriesState ?? this.popularTvSeriesState,
      topRatedTvSeries: topRatedTvSeries ?? this.topRatedTvSeries,
      topRatedTvSeriesState:
          topRatedTvSeriesState ?? this.topRatedTvSeriesState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        onTheAirTvSeries,
        onTheAirState,
        popularTvSeries,
        popularTvSeriesState,
        topRatedTvSeries,
        topRatedTvSeriesState,
        message,
      ];
}

class TvSeriesListCubit extends Cubit<TvSeriesListState> {
  TvSeriesListCubit({
    required this.getOnTheAirTvSeries,
    required this.getPopularTvSeries,
    required this.getTopRatedTvSeries,
  }) : super(const TvSeriesListState());

  final GetOnTheAirTvSeries getOnTheAirTvSeries;
  final GetPopularTvSeries getPopularTvSeries;
  final GetTopRatedTvSeries getTopRatedTvSeries;

  Future<void> fetchOnTheAirTvSeries() async {
    emit(state.copyWith(onTheAirState: RequestState.Loading));
    final result = await getOnTheAirTvSeries.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(
          onTheAirState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (tvSeriesData) => emit(
        state.copyWith(
          onTheAirState: RequestState.Loaded,
          onTheAirTvSeries: tvSeriesData,
          message: '',
        ),
      ),
    );
  }

  Future<void> fetchPopularTvSeries() async {
    emit(state.copyWith(popularTvSeriesState: RequestState.Loading));
    final result = await getPopularTvSeries.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(
          popularTvSeriesState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (tvSeriesData) => emit(
        state.copyWith(
          popularTvSeriesState: RequestState.Loaded,
          popularTvSeries: tvSeriesData,
          message: '',
        ),
      ),
    );
  }

  Future<void> fetchTopRatedTvSeries() async {
    emit(state.copyWith(topRatedTvSeriesState: RequestState.Loading));
    final result = await getTopRatedTvSeries.execute();
    result.fold(
      (failure) => emit(
        state.copyWith(
          topRatedTvSeriesState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (tvSeriesData) => emit(
        state.copyWith(
          topRatedTvSeriesState: RequestState.Loaded,
          topRatedTvSeries: tvSeriesData,
          message: '',
        ),
      ),
    );
  }
}
