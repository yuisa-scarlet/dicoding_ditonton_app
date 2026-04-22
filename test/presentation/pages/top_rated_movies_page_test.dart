import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/top_rated_movies_cubit.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_movies_page_test.mocks.dart';

@GenerateNiceMocks([MockSpec<TopRatedMoviesCubit>()])

void main() {
  late MockTopRatedMoviesCubit mockCubit;

  setUp(() {
    mockCubit = MockTopRatedMoviesCubit();
    when(mockCubit.stream)
        .thenAnswer((_) => const Stream<TopRatedMoviesState>.empty());
    when(mockCubit.fetchTopRatedMovies()).thenAnswer((_) async {});
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMoviesCubit>.value(
      value: mockCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(mockCubit.state)
        .thenReturn(const TopRatedMoviesState(state: RequestState.Loading));

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(find.byType(Center), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(
      const TopRatedMoviesState(
        state: RequestState.Loaded,
        movies: <Movie>[],
      ),
    );

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockCubit.state).thenReturn(
      const TopRatedMoviesState(
        state: RequestState.Error,
        message: 'Error message',
      ),
    );

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(find.byKey(Key('error_message')), findsOneWidget);
  });
}
