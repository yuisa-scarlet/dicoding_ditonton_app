import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  testWidgets('TvSeriesCard should show tv series name and overview',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TvSeriesCard(testTvSeries),
        ),
      ),
    );

    expect(find.text('TV Name'), findsOneWidget);
    expect(find.text('TV overview'), findsOneWidget);
  });
}
