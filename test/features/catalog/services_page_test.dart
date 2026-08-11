import 'package:car_history/features/catalog/data/service_repository_impl.dart';
import 'package:car_history/features/catalog/presentation/pages/services_page.dart';
import 'package:car_history/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/in_memory_database.dart';
import '../../support/test_app_overrides.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('ServicesPage lists seeded service name', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final db = await openInMemoryDatabase();
    final services = ServiceRepositoryImpl(db);
    final created = await services.create('Oil change', iconKey: 'build');
    expect(created.item?.name, 'Oil change');

    await tester.pumpWidget(
      ProviderScope(
        overrides: testAppOverrides(db),
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: const ServicesPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Services'), findsOneWidget);
    expect(find.text('Oil change'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
    await db.close();
  });
}
