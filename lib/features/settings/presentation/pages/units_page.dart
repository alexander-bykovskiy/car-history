import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/units.dart';
import '../../../../l10n/app_localizations.dart';
import '../../di/preferences_providers.dart';
import 'currencies_page.dart';

class UnitsPage extends ConsumerWidget {
  const UnitsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final fuelAsync = ref.watch(fuelVolumeUnitProvider);
    final distanceAsync = ref.watch(distanceUnitProvider);
    final currencyAsync = ref.watch(currencyCodeProvider);
    final codesAsync = ref.watch(currencyCodesProvider);

    final fuel = fuelAsync.value;
    final distance = distanceAsync.value;
    final currency = currencyAsync.value;
    final codes = codesAsync.value;
    final loading =
        fuel == null || distance == null || currency == null || codes == null;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsUnits)),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    l10n.unitsFuelSection,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                RadioGroup<FuelVolumeUnit>(
                  groupValue: fuel,
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(fuelVolumeUnitProvider.notifier).set(value);
                    }
                  },
                  child: Column(
                    children: [
                      RadioListTile<FuelVolumeUnit>(
                        value: FuelVolumeUnit.liters,
                        title: Text(l10n.unitLiters),
                      ),
                      RadioListTile<FuelVolumeUnit>(
                        value: FuelVolumeUnit.usGallons,
                        title: Text(l10n.unitUsGallons),
                      ),
                      RadioListTile<FuelVolumeUnit>(
                        value: FuelVolumeUnit.imperialGallons,
                        title: Text(l10n.unitImperialGallons),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    l10n.unitsDistanceSection,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                RadioGroup<DistanceUnit>(
                  groupValue: distance,
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(distanceUnitProvider.notifier).set(value);
                    }
                  },
                  child: Column(
                    children: [
                      RadioListTile<DistanceUnit>(
                        value: DistanceUnit.kilometers,
                        title: Text(l10n.unitKilometers),
                      ),
                      RadioListTile<DistanceUnit>(
                        value: DistanceUnit.miles,
                        title: Text(l10n.unitMiles),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.settingsCurrency,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const CurrenciesPage(),
                            ),
                          );
                        },
                        child: Text(l10n.actionEdit),
                      ),
                    ],
                  ),
                ),
                RadioGroup<String>(
                  groupValue: currency,
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(currencyCodeProvider.notifier).set(value);
                    }
                  },
                  child: Column(
                    children: [
                      for (final code in codes)
                        RadioListTile<String>(
                          value: code,
                          title: Text(code),
                        ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
