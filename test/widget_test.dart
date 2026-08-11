import 'package:car_history/shared/data/db/database_seed_texts.dart';
import 'package:car_history/shell/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('DatabaseSeedTexts.english matches catalog defaults', () {
    expect(DatabaseSeedTexts.english.fuelTypePetrol95, 'Petrol 95');
    expect(DatabaseSeedTexts.english.fuelTypeDiesel, 'Diesel');
    expect(DatabaseSeedTexts.english.seedCarBrand, 'Brand');
    expect(DatabaseSeedTexts.english.defaultCarColorArgb, 0xFF000000);
  });

  testWidgets('SplashPage renders', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SplashPage()));
    expect(find.byType(SplashPage), findsOneWidget);
  });
}
