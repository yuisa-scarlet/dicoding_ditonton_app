import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailState extends Equatable {
  const MovieDetailState({
    this.movie,
    this.movieState = RequestState.Empty,
    this.movieRecommendations = const [],
    this.recommendationState = RequestState.Empty,
    this.message = '',
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
  });

  final MovieDetail? movie;
  final RequestState movieState;
  final List<Movie> movieRecommendations;
  final RequestState recommendationState;
  final String message;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  MovieDetailState copyWith({
    MovieDetail? movie,
    bool updateMovie = false,
    RequestState? movieState,
    List<Movie>? movieRecommendations,
    RequestState? recommendationState,
    String? message,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return MovieDetailState(
      movie: updateMovie ? movie : this.movie,
      movieState: movieState ?? this.movieState,
      movieRecommendations: movieRecommendations ?? this.movieRecommendations,
      recommendationState: recommendationState ?? this.recommendationState,
      message: message ?? this.message,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
        movie,
        movieState,
        movieRecommendations,
        recommendationState,
        message,
        isAddedToWatchlist,
        watchlistMessage,
      ];
}

class MovieDetailCubit extends Cubit<MovieDetailState> {
  MovieDetailCubit({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const MovieDetailState());

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  Future<void> fetchMovieDetail(int id) async {
    emit(
      state.copyWith(
        movieState: RequestState.Loading,
        recommendationState: RequestState.Empty,
        message: '',
      ),
    );

    final detailResult = await getMovieDetail.execute(id);
    final recommendationResult = await getMovieRecommendations.execute(id);

    detailResult.fold(
      (failure) => emit(
        state.copyWith(
          movieState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (movie) {
        emit(
          state.copyWith(
            updateMovie: true,
            movie: movie,
            recommendationState: RequestState.Loading,
            message: '',
          ),
        );

        recommendationResult.fold(
          (failure) => emit(
            state.copyWith(
              movieState: RequestState.Loaded,
              recommendationState: RequestState.Error,
              message: failure.message,
            ),
          ),
          (movies) => emit(
            state.copyWith(
              movieState: RequestState.Loaded,
              recommendationState: RequestState.Loaded,
              movieRecommendations: movies,
              message: '',
            ),
          ),
        );
      },
    );
  }

  Future<void> addWatchlist(MovieDetail movie) async {
    final result = await saveWatchlist.execute(movie);
    final watchlistMessage = result.fold(
      (failure) => failure.message,
      (successMessage) => successMessage,
    );

    emit(state.copyWith(watchlistMessage: watchlistMessage));
    await loadWatchlistStatus(movie.id);
  }

  Future<void> removeFromWatchlist(MovieDetail movie) async {
    final result = await removeWatchlist.execute(movie);
    final watchlistMessage = result.fold(
      (failure) => failure.message,
      (successMessage) => successMessage,
    );

    emit(state.copyWith(watchlistMessage: watchlistMessage));
    await loadWatchlistStatus(movie.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final isAdded = await getWatchListStatus.execute(id);
    emit(state.copyWith(isAddedToWatchlist: isAdded));
  }
}
