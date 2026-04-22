import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnTheAirTvSeriesState extends Equatable {
  const OnTheAirTvSeriesState({
    this.state = RequestState.Empty,
    this.tvSeries = const [],
    this.message = '',
  });

  final RequestState state;
  final List<TvSeries> tvSeries;
  final String message;

  OnTheAirTvSeriesState copyWith({
    RequestState? state,
    List<TvSeries>? tvSeries,
    String? message,
  }) {
    return OnTheAirTvSeriesState(
      state: state ?? this.state,
      tvSeries: tvSeries ?? this.tvSeries,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, tvSeries, message];
}

class OnTheAirTvSeriesCubit extends Cubit<OnTheAirTvSeriesState> {
  OnTheAirTvSeriesCubit(this.getOnTheAirTvSeries)
      : super(const OnTheAirTvSeriesState());

  final GetOnTheAirTvSeries getOnTheAirTvSeries;

  Future<void> fetchOnTheAirTvSeries() async {
    emit(state.copyWith(state: RequestState.Loading));
    final result = await getOnTheAirTvSeries.execute();

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
