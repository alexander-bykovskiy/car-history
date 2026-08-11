import 'package:car_history/core/units.dart';
import 'package:car_history/features/fueling/presentation/pages/fueling_form_page.dart';
import 'package:car_history/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/in_memory_database.dart';
import '../../support/test_app_overrides.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('FuelingFormPage save with empty fields shows fuel type error',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final db = await openInMemoryDatabase();
    addTearDown(db.close);
    final carId = (await db.select(db.cars).getSingle()).id;

    await tester.pumpWidget(
      ProviderScope(
        overrides: testAppOverrides(db),
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: FuelingFormPage(
            carId: carId,
            volumeUnit: FuelVolumeUnit.liters,
            distanceUnit: DistanceUnit.kilometers,
            currencyCode: 'EUR',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Bootstrap may prefill the last fuel type; clear for empty-field path.
    final fuelTypeField = find.byType(TextField).first;
    await tester.enterText(fuelTypeField, '');
    await tester.pump();

    final save = find.text('Save');
    await tester.ensureVisible(save);
    await tester.pumpAndSettle();
    await tester.tap(save);
    await tester.pumpAndSettle();

    expect(find.text('Select or enter a fuel type'), findsOneWidget);
  });
}
