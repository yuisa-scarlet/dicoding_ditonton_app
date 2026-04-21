import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/provider/tv_series_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_series_detail_page_test.mocks.dart';

@GenerateMocks([TvSeriesDetailNotifier])
void main() {
  late MockTvSeriesDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTvSeriesDetailNotifier();
    when(mockNotifier.fetchTvSeriesDetail(any)).thenAnswer((_) async {});
    when(mockNotifier.loadWatchlistStatus(any)).thenAnswer((_) async {});
    when(mockNotifier.addWatchlist(any)).thenAnswer((_) async {});
    when(mockNotifier.removeFromWatchlist(any)).thenAnswer((_) async {});
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeriesRecommendations).thenReturn(<TvSeries>[]);
    when(mockNotifier.watchlistMessage).thenReturn('');
    when(mockNotifier.message).thenReturn('');
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
  });

  Widget makeTestableWidget(
    Widget body, {
    RouteFactory? onGenerateRoute,
  }) {
    return ChangeNotifierProvider<TvSeriesDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
        onGenerateRoute: onGenerateRoute,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when tv series not added',
      (WidgetTester tester) async {
    when(mockNotifier.tvSeriesState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeries).thenReturn(testTvSeriesDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeriesRecommendations).thenReturn(<TvSeries>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 100)));

    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.textContaining('Seasons:'), findsOneWidget);
    expect(find.textContaining('S1: Season 1'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when tv series is added',
      (WidgetTester tester) async {
    when(mockNotifier.tvSeriesState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeries).thenReturn(testTvSeriesDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeriesRecommendations).thenReturn(<TvSeries>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(true);

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 100)));

    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('Page should display error text when state is Error',
      (WidgetTester tester) async {
    when(mockNotifier.tvSeriesState).thenReturn(RequestState.Error);
    when(mockNotifier.message).thenReturn('Failed');

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 100)));

    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets('Watchlist button should show snackbar when add succeeds',
      (WidgetTester tester) async {
    when(mockNotifier.tvSeriesState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeries).thenReturn(testTvSeriesDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeriesRecommendations).thenReturn(<TvSeries>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockNotifier.watchlistMessage)
        .thenReturn(TvSeriesDetailNotifier.watchlistAddSuccessMessage);

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 100)));

    await tester.tap(find.text('Watchlist'));
    await tester.pump();

    verify(mockNotifier.addWatchlist(testTvSeriesDetail)).called(1);
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('Watchlist button should show dialog when operation fails',
      (WidgetTester tester) async {
    when(mockNotifier.tvSeriesState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeries).thenReturn(testTvSeriesDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeriesRecommendations).thenReturn(<TvSeries>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(true);
    when(mockNotifier.watchlistMessage).thenReturn('Failed');

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 100)));

    await tester.tap(find.text('Watchlist'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    verify(mockNotifier.removeFromWatchlist(testTvSeriesDetail)).called(1);
    expect(find.byType(AlertDialog), findsOneWidget);
  });

  testWidgets(
      'Recommendations should show error message when recommendation fails',
      (WidgetTester tester) async {
    when(mockNotifier.tvSeriesState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeries).thenReturn(testTvSeriesDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Error);
    when(mockNotifier.message).thenReturn('Rec failed');
    when(mockNotifier.tvSeriesRecommendations).thenReturn(<TvSeries>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 100)));

    expect(find.text('Rec failed'), findsOneWidget);
  });

  testWidgets('Tap recommendation should navigate to replacement route',
      (WidgetTester tester) async {
    when(mockNotifier.tvSeriesState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeries).thenReturn(testTvSeriesDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeriesRecommendations)
        .thenReturn([testWatchlistTvSeries]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

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
    when(mockNotifier.tvSeriesState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeries).thenReturn(testTvSeriesDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvSeriesRecommendations).thenReturn(<TvSeries>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

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

    when(mockNotifier.watchlistMessage)
        .thenReturn(TvSeriesDetailNotifier.watchlistAddSuccessMessage);

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
