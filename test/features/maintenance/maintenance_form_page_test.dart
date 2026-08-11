import 'package:car_history/core/units.dart';
import 'package:car_history/features/maintenance/presentation/pages/maintenance_form_page.dart';
import 'package:car_history/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/in_memory_database.dart';
import '../../support/test_app_overrides.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      'MaintenanceFormPage save with empty service shows required error',
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
          home: MaintenanceFormPage(
            carId: carId,
            distanceUnit: DistanceUnit.kilometers,
            currencyCode: 'EUR',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Bootstrap may prefill the last service; clear for empty-field path.
    final serviceField = find.byType(TextField).first;
    await tester.enterText(serviceField, '');
    await tester.pump();

    // FormActionsBar sits below parts/reminder sections; ListView is lazy.
    final save = find.widgetWithText(FilledButton, 'Save');
    await tester.dragUntilVisible(
      save,
      find.byType(ListView),
      const Offset(0, -200),
    );
    await tester.pumpAndSettle();
    await tester.tap(save);
    await tester.pumpAndSettle();

    expect(find.text('Select or enter a service'), findsOneWidget);
  });
}
