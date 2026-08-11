import 'package:car_history/core/units.dart';
import 'package:car_history/l10n/app_localizations.dart';
import 'package:car_history/shared/presentation/unit_labels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('unit short labels resolve via l10n', (tester) async {
    late AppLocalizations l10n;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context);
            return Text(
              '${volumeUnitShort(l10n, FuelVolumeUnit.liters)} '
              '${distanceUnitShort(l10n, DistanceUnit.kilometers)}',
            );
          },
        ),
      ),
    );

    expect(find.textContaining(l10n.unitFuelShortLiter), findsOneWidget);
    expect(find.textContaining(l10n.unitDistanceShortKm), findsOneWidget);
  });
}
