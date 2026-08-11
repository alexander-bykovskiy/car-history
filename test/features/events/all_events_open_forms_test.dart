import 'package:car_history/features/events/presentation/pages/all_events_tab.dart';
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

  Future<AppDatabase> pumpAllEventsTab(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final db = await openInMemoryDatabase();

    await tester.pumpWidget(
      ProviderScope(
        overrides: testAppOverrides(db),
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: const AllEventsTab(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return db;
  }

  Future<void> unmountAndClose(WidgetTester tester, AppDatabase db) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await db.close();
  }

  testWidgets('AllEventsTab FAB opens fueling form via navigation helper', (
    tester,
  ) async {
    final db = await pumpAllEventsTab(tester);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add fueling'));
    await tester.pumpAndSettle();

    expect(find.byType(FuelingFormPage), findsOneWidget);
    expect(find.text('Add fueling'), findsWidgets);

    await unmountAndClose(tester, db);
  });

  testWidgets('AllEventsTab FAB opens maintenance form via navigation helper', (
    tester,
  ) async {
    final db = await pumpAllEventsTab(tester);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add maintenance'));
    await tester.pumpAndSettle();

    expect(find.byType(MaintenanceFormPage), findsOneWidget);
    expect(find.text('Add maintenance'), findsWidgets);

    await unmountAndClose(tester, db);
  });
}
