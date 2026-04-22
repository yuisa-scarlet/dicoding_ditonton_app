import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedMoviesState extends Equatable {
  const TopRatedMoviesState({
    this.state = RequestState.Empty,
    this.movies = const [],
    this.message = '',
  });

  final RequestState state;
  final List<Movie> movies;
  final String message;

  TopRatedMoviesState copyWith({
    RequestState? state,
    List<Movie>? movies,
    String? message,
  }) {
    return TopRatedMoviesState(
      state: state ?? this.state,
      movies: movies ?? this.movies,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, movies, message];
}

class TopRatedMoviesCubit extends Cubit<TopRatedMoviesState> {
  TopRatedMoviesCubit({required this.getTopRatedMovies})
      : super(const TopRatedMoviesState());

  final GetTopRatedMovies getTopRatedMovies;

  Future<void> fetchTopRatedMovies() async {
    emit(state.copyWith(state: RequestState.Loading));
    final result = await getTopRatedMovies.execute();

    result.fold(
      (failure) => emit(
        state.copyWith(
          state: RequestState.Error,
          message: failure.message,
        ),
      ),
      (moviesData) => emit(
        state.copyWith(
          state: RequestState.Loaded,
          movies: moviesData,
          message: '',
        ),
      ),
    );
  }
}
