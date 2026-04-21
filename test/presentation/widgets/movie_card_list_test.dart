import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  testWidgets('MovieCard should show movie title and overview', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MovieCard(testMovie),
        ),
      ),
    );

    expect(find.text('Spider-Man'), findsOneWidget);
    expect(find.textContaining('After being bitten'), findsOneWidget);
  });
}
