import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/presentation/bloc/tv_series_detail_cubit.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_series_detail_page_test.mocks.dart';

@GenerateNiceMocks([MockSpec<TvSeriesDetailCubit>()])

void main() {
  late MockTvSeriesDetailCubit mockCubit;

  TvSeriesDetailState loadedState({
    bool isAddedToWatchlist = false,
    String watchlistMessage = '',
    RequestState recommendationState = RequestState.Loaded,
    List<TvSeries> recommendations = const <TvSeries>[],
    String message = '',
  }) {
    return TvSeriesDetailState(
      tvSeries: testTvSeriesDetail,
      tvSeriesState: RequestState.Loaded,
      recommendationState: recommendationState,
      tvSeriesRecommendations: recommendations,
      isAddedToWatchlist: isAddedToWatchlist,
      watchlistMessage: watchlistMessage,
      message: message,
    );
  }

  setUp(() {
    mockCubit = MockTvSeriesDetailCubit();
    when(mockCubit.stream)
        .thenAnswer((_) => const Stream<TvSeriesDetailState>.empty());
    when(mockCubit.fetchTvSeriesDetail(100)).thenAnswer((_) async {});
    when(mockCubit.loadWatchlistStatus(100)).thenAnswer((_) async {});
    when(mockCubit.addWatchlist(testTvSeriesDetail)).thenAnswer((_) async {});
    when(mockCubit.removeFromWatchlist(testTvSeriesDetail))
        .thenAnswer((_) async {});
  });

  Widget makeTestableWidget(
    Widget body, {
    RouteFactory? onGenerateRoute,
  }) {
    return BlocProvider<TvSeriesDetailCubit>.value(
      value: mockCubit,
      child: MaterialApp(
        home: body,
        onGenerateRoute: onGenerateRoute,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when tv series not added',
      (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(loadedState(isAddedToWatchlist: false));

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 100)));

    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.textContaining('Seasons:'), findsOneWidget);
    expect(find.textContaining('S1: Season 1'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when tv series is added',
      (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(loadedState(isAddedToWatchlist: true));

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 100)));

    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('Page should display error text when state is Error',
      (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(
      const TvSeriesDetailState(
        tvSeriesState: RequestState.Error,
        message: 'Failed',
      ),
    );

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 100)));

    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets('Watchlist button should show snackbar when add succeeds',
      (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(
      loadedState(
        isAddedToWatchlist: false,
        watchlistMessage: TvSeriesDetailCubit.watchlistAddSuccessMessage,
      ),
    );

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 100)));

    await tester.tap(find.text('Watchlist'));
    await tester.pump();

    verify(mockCubit.addWatchlist(testTvSeriesDetail)).called(1);
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('Watchlist button should show dialog when operation fails',
      (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(
      loadedState(
        isAddedToWatchlist: true,
        watchlistMessage: 'Failed',
      ),
    );

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 100)));

    await tester.tap(find.text('Watchlist'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    verify(mockCubit.removeFromWatchlist(testTvSeriesDetail)).called(1);
    expect(find.byType(AlertDialog), findsOneWidget);
  });

  testWidgets(
      'Recommendations should show error message when recommendation fails',
      (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(
      loadedState(
        recommendationState: RequestState.Error,
        message: 'Rec failed',
      ),
    );

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 100)));

    expect(find.text('Rec failed'), findsOneWidget);
  });

  testWidgets('Tap recommendation should navigate to replacement route',
      (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(
      loadedState(
        recommendations: <TvSeries>[testWatchlistTvSeries],
      ),
    );

    await tester.pumpWidget(
      makeTestableWidget(
        const TvSeriesDetailPage(id: 100),
        onGenerateRoute: (settings) {
          if (settings.name == TvSeriesDetailPage.routeName) {
            return MaterialPageRoute<void>(
              builder: (_) => const Scaffold(body: Text('Replacement Page')),
            );
          }
          return null;
        },
      ),
    );

    final listViewFinder = find.byType(ListView);
    final recommendationInkWell = find.descendant(
      of: listViewFinder,
      matching: find.byType(InkWell),
    );

    tester.widget<InkWell>(recommendationInkWell.first).onTap!();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Replacement Page'), findsOneWidget);
  });

  testWidgets('Back button tap should trigger pop callback',
      (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(loadedState());

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 100)));

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();
  });

  testWidgets('Content should handle empty genres and empty seasons',
      (WidgetTester tester) async {
    final tvSeriesWithEmptyMetadata = TvSeriesDetail(
      adult: false,
      backdropPath: '/path.jpg',
      genres: const <Genre>[],
      id: 101,
      originalName: 'Original Name',
      overview: 'Overview',
      posterPath: '/poster.jpg',
      firstAirDate: '2024-01-01',
      name: 'Name',
      voteAverage: 8.0,
      voteCount: 100,
      seasons: const <Season>[],
      numberOfEpisodes: 0,
      numberOfSeasons: 0,
    );

    when(mockCubit.state).thenReturn(
      loadedState(
        watchlistMessage: TvSeriesDetailCubit.watchlistAddSuccessMessage,
      ),
    );

    await tester.pumpWidget(
      makeTestableWidget(
        TvSeriesDetailContent(
          tvSeries: tvSeriesWithEmptyMetadata,
          recommendations: const <TvSeries>[],
          isAddedWatchlist: false,
        ),
      ),
    );

    expect(find.textContaining('Seasons: 0 | Episodes: 0'), findsOneWidget);
    expect(find.text('-'), findsOneWidget);
  });
}
