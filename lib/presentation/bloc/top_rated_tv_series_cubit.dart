import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedTvSeriesState extends Equatable {
  const TopRatedTvSeriesState({
    this.state = RequestState.Empty,
    this.tvSeries = const [],
    this.message = '',
  });

  final RequestState state;
  final List<TvSeries> tvSeries;
  final String message;

  TopRatedTvSeriesState copyWith({
    RequestState? state,
    List<TvSeries>? tvSeries,
    String? message,
  }) {
    return TopRatedTvSeriesState(
      state: state ?? this.state,
      tvSeries: tvSeries ?? this.tvSeries,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, tvSeries, message];
}

class TopRatedTvSeriesCubit extends Cubit<TopRatedTvSeriesState> {
  TopRatedTvSeriesCubit({required this.getTopRatedTvSeries})
      : super(const TopRatedTvSeriesState());

  final GetTopRatedTvSeries getTopRatedTvSeries;

  Future<void> fetchTopRatedTvSeries() async {
    emit(state.copyWith(state: RequestState.Loading));
    final result = await getTopRatedTvSeries.execute();

    result.fold(
      (failure) => emit(
        state.copyWith(
          state: RequestState.Error,
          message: failure.message,
        ),
      ),
      (tvSeriesData) => emit(
        state.copyWith(
          state: RequestState.Loaded,
          tvSeries: tvSeriesData,
          message: '',
        ),
      ),
    );
  }
}
