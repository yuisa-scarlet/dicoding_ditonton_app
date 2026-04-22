import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie_detail_cubit.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_page_test.mocks.dart';

@GenerateNiceMocks([MockSpec<MovieDetailCubit>()])

void main() {
  late MockMovieDetailCubit mockCubit;

  MovieDetailState loadedState({
    bool isAddedToWatchlist = false,
    String watchlistMessage = '',
    RequestState recommendationState = RequestState.Loaded,
    List<Movie> recommendations = const <Movie>[],
  }) {
    return MovieDetailState(
      movie: testMovieDetail,
      movieState: RequestState.Loaded,
      recommendationState: recommendationState,
      movieRecommendations: recommendations,
      isAddedToWatchlist: isAddedToWatchlist,
      watchlistMessage: watchlistMessage,
    );
  }

  setUp(() {
    mockCubit = MockMovieDetailCubit();
    when(mockCubit.stream)
        .thenAnswer((_) => const Stream<MovieDetailState>.empty());
    when(mockCubit.fetchMovieDetail(1)).thenAnswer((_) async {});
    when(mockCubit.loadWatchlistStatus(1)).thenAnswer((_) async {});
    when(mockCubit.addWatchlist(testMovieDetail)).thenAnswer((_) async {});
    when(mockCubit.removeFromWatchlist(testMovieDetail))
        .thenAnswer((_) async {});
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailCubit>.value(
      value: mockCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(loadedState(isAddedToWatchlist: false));

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(loadedState(isAddedToWatchlist: true));

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(
      loadedState(
        isAddedToWatchlist: false,
        watchlistMessage: MovieDetailCubit.watchlistAddSuccessMessage,
      ),
    );

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    verify(mockCubit.addWatchlist(testMovieDetail)).called(1);
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(
      loadedState(
        isAddedToWatchlist: false,
        watchlistMessage: 'Failed',
      ),
    );

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    verify(mockCubit.addWatchlist(testMovieDetail)).called(1);
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
