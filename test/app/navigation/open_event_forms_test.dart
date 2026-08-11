import 'package:car_history/app/navigation/open_event_forms.dart';
import 'package:car_history/core/units.dart';
import 'package:car_history/features/fueling/presentation/pages/fueling_form_page.dart';
import 'package:car_history/features/maintenance/presentation/pages/maintenance_form_page.dart';
import 'package:car_history/l10n/app_localizations.dart';
import 'package:car_history/shared/data/db/app_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/in_memory_database.dart';
import '../../support/test_app_overrides.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpHome(
    WidgetTester tester, {
    required AppDatabase db,
    required Widget home,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: testAppOverrides(db),
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: home,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('openFuelingForm pushes FuelingFormPage', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final db = await openInMemoryDatabase();
    addTearDown(db.close);
    final carId = (await db.select(db.cars).getSingle()).id;

    await pumpHome(
      tester,
      db: db,
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => openFuelingForm(
              context,
              carId: carId,
              volumeUnit: FuelVolumeUnit.liters,
              distanceUnit: DistanceUnit.kilometers,
              currencyCode: 'EUR',
            ),
            child: const Text('open-fueling'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open-fueling'));
    await tester.pumpAndSettle();

    expect(find.byType(FuelingFormPage), findsOneWidget);
    expect(find.text('Add fueling'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });

  testWidgets('openMaintenanceForm pushes MaintenanceFormPage', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final db = await openInMemoryDatabase();
    addTearDown(db.close);
    final carId = (await db.select(db.cars).getSingle()).id;

    await pumpHome(
      tester,
      db: db,
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => openMaintenanceForm(
              context,
              carId: carId,
              distanceUnit: DistanceUnit.kilometers,
              currencyCode: 'EUR',
            ),
            child: const Text('open-maintenance'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open-maintenance'));
    await tester.pumpAndSettle();

    expect(find.byType(MaintenanceFormPage), findsOneWidget);
    expect(find.text('Add maintenance'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });
}
