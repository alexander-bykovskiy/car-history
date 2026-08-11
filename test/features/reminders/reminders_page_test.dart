import 'package:car_history/features/reminders/data/reminder_repository_impl.dart';
import 'package:car_history/features/reminders/domain/entities/reminder.dart';
import 'package:car_history/features/reminders/presentation/pages/reminders_page.dart';
import 'package:car_history/l10n/app_localizations.dart';
import 'package:car_history/shared/data/odometer_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/in_memory_database.dart';
import '../../support/test_app_overrides.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('RemindersPage lists seeded reminder title', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final db = await openInMemoryDatabase();
    final carId = (await db.select(db.cars).getSingle()).id;

    final repo = ReminderRepositoryImpl(
      db,
      odometerRepository: OdometerRepositoryImpl(db),
    );
    final outcome = await repo.create(
      ReminderInput(
        carId: carId,
        title: 'Oil change soon',
        dueAt: DateTime.now().add(const Duration(days: 3)),
      ),
    );
    expect(outcome.result, ReminderSaveResult.created);

    await tester.pumpWidget(
      ProviderScope(
        overrides: testAppOverrides(db),
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: const RemindersPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Reminders'), findsOneWidget);
    expect(find.text('Oil change soon'), findsOneWidget);

    // Unmount StreamBuilder before closing DB so Drift cancel timers flush.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await db.close();
  });
}
