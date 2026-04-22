import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularMoviesState extends Equatable {
  const PopularMoviesState({
    this.state = RequestState.Empty,
    this.movies = const [],
    this.message = '',
  });

  final RequestState state;
  final List<Movie> movies;
  final String message;

  PopularMoviesState copyWith({
    RequestState? state,
    List<Movie>? movies,
    String? message,
  }) {
    return PopularMoviesState(
      state: state ?? this.state,
      movies: movies ?? this.movies,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, movies, message];
}

class PopularMoviesCubit extends Cubit<PopularMoviesState> {
  PopularMoviesCubit(this.getPopularMovies) : super(const PopularMoviesState());

  final GetPopularMovies getPopularMovies;

  Future<void> fetchPopularMovies() async {
    emit(state.copyWith(state: RequestState.Loading));
    final result = await getPopularMovies.execute();

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
