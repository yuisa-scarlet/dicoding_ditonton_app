import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularTvSeriesState extends Equatable {
  const PopularTvSeriesState({
    this.state = RequestState.Empty,
    this.tvSeries = const [],
    this.message = '',
  });

  final RequestState state;
  final List<TvSeries> tvSeries;
  final String message;

  PopularTvSeriesState copyWith({
    RequestState? state,
    List<TvSeries>? tvSeries,
    String? message,
  }) {
    return PopularTvSeriesState(
      state: state ?? this.state,
      tvSeries: tvSeries ?? this.tvSeries,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, tvSeries, message];
}

class PopularTvSeriesCubit extends Cubit<PopularTvSeriesState> {
  PopularTvSeriesCubit(this.getPopularTvSeries)
      : super(const PopularTvSeriesState());

  final GetPopularTvSeries getPopularTvSeries;

  Future<void> fetchPopularTvSeries() async {
    emit(state.copyWith(state: RequestState.Loading));
    final result = await getPopularTvSeries.execute();

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
