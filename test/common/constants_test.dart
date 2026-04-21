import 'package:ditonton/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('constants should be initialized with expected values', () {
    expect(BASE_IMAGE_URL, 'https://image.tmdb.org/t/p/w500');
    expect(kRichBlack, const Color(0xFF000814));
    expect(kOxfordBlue, const Color(0xFF001D3D));
    expect(kPrussianBlue, const Color(0xFF003566));
    expect(kMikadoYellow, const Color(0xFFffc300));
    expect(kDavysGrey, const Color(0xFF4B5358));
    expect(kGrey, const Color(0xFF303030));
    expect(kTextTheme.headlineMedium, isNotNull);
    expect(kDrawerTheme.backgroundColor, isNotNull);
    expect(kColorScheme.brightness, Brightness.dark);
  });
}
