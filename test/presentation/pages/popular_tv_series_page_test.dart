import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/popular_tv_series_cubit.dart';
import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'popular_tv_series_page_test.mocks.dart';

@GenerateNiceMocks([MockSpec<PopularTvSeriesCubit>()])

void main() {
  late MockPopularTvSeriesCubit mockCubit;

  setUp(() {
    mockCubit = MockPopularTvSeriesCubit();
    when(mockCubit.stream)
        .thenAnswer((_) => const Stream<PopularTvSeriesState>.empty());
    when(mockCubit.fetchPopularTvSeries()).thenAnswer((_) async {});
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvSeriesCubit>.value(
      value: mockCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(mockCubit.state)
        .thenReturn(const PopularTvSeriesState(state: RequestState.Loading));

    await tester.pumpWidget(makeTestableWidget(const PopularTvSeriesPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(
      PopularTvSeriesState(
        state: RequestState.Loaded,
        tvSeries: testTvSeriesList,
      ),
    );

    await tester.pumpWidget(makeTestableWidget(const PopularTvSeriesPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(
      const PopularTvSeriesState(
        state: RequestState.Error,
        message: 'Error message',
      ),
    );

    await tester.pumpWidget(makeTestableWidget(const PopularTvSeriesPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });
}
