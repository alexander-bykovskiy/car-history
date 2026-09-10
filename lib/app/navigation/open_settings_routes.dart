import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/report_caught_error.dart';
import '../../features/cars/presentation/pages/cars_page.dart';
import '../../features/catalog/presentation/pages/fuel_types_page.dart';
import '../../features/catalog/presentation/pages/gas_stations_page.dart';
import '../../features/catalog/presentation/pages/part_units_page.dart';
import '../../features/catalog/presentation/pages/parts_page.dart';
import '../../features/catalog/presentation/pages/service_centers_page.dart';
import '../../features/catalog/presentation/pages/services_page.dart';
import '../../features/settings/domain/privacy_policy.dart';
import '../../features/settings/presentation/pages/backup_page.dart';
import '../../features/settings/presentation/pages/language_page.dart';
import '../../features/settings/presentation/pages/units_page.dart';
import '../../l10n/app_localizations.dart';
import 'open_reminders_page.dart';

/// Composition-root navigation for Settings hub destinations.
///
/// Settings UI must not import sibling feature pages directly.

Future<void> openCarsPage(BuildContext context) =>
    _push(context, const CarsPage());

Future<void> openFuelTypesPage(BuildContext context) =>
    _push(context, const FuelTypesPage());

Future<void> openPartsPage(BuildContext context) =>
    _push(context, const PartsPage());

Future<void> openPartUnitsPage(BuildContext context) =>
    _push(context, const PartUnitsPage());

Future<void> openServicesPage(BuildContext context) =>
    _push(context, const ServicesPage());

Future<void> openServiceCentersPage(BuildContext context) =>
    _push(context, const ServiceCentersPage());

Future<void> openGasStationsPage(BuildContext context) =>
    _push(context, const GasStationsPage());

Future<void> openUnitsPage(BuildContext context) =>
    _push(context, const UnitsPage());

Future<void> openBackupPage(BuildContext context) =>
    _push(context, const BackupPage());

Future<void> openLanguagePage(BuildContext context) =>
    _push(context, const LanguagePage());

/// Opens the public privacy policy URL in the device browser (no in-app page).
Future<void> openPrivacyPolicy(BuildContext context) async {
  final uri = Uri.parse(kPrivacyPolicyUrl);
  var opened = false;
  try {
    // Prefer external browser; fall back to platform default if none resolves.
    opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened) {
      opened = await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  } catch (e, st) {
    reportCaughtError(e, st, context: 'openPrivacyPolicy');
    opened = false;
  }
  if (!opened && context.mounted) {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.privacyOpenFailed)),
    );
  }
}

/// Same entry as header / statistics; re-exported for settings hub.
Future<void> openRemindersFromSettings(BuildContext context) =>
    openRemindersPage(context);

Future<void> _push(BuildContext context, Widget page) {
  return Navigator.of(context).push<void>(
    MaterialPageRoute<void>(builder: (context) => page),
  );
}
