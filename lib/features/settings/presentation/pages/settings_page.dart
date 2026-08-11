import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../app/navigation/open_settings_routes.dart';
import '../../di/preferences_providers.dart';
import '../../domain/app_locale_option.dart';

enum _SettingsSection {
  reminders,
  cars,
  units,
  fuel,
  gasStations,
  services,
  serviceCenters,
  partUnits,
  parts,
  backup,
  language,
  privacy,
}

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final localeOption =
        ref.watch(appLocalePreferenceProvider).value ?? AppLocaleOption.system;
    final languageSubtitle = localeOption == AppLocaleOption.system
        ? l10n.languageSystem
        : localeOption.nativeLabel;

    final groups = <_SettingsGroup>[
      _SettingsGroup(
        title: l10n.settingsSectionVehicle,
        items: [
          _SettingsItem(
            section: _SettingsSection.reminders,
            icon: Icons.notification_important_outlined,
            title: l10n.settingsReminders,
          ),
          _SettingsItem(
            section: _SettingsSection.cars,
            icon: Icons.directions_car_outlined,
            title: l10n.settingsCars,
          ),
          _SettingsItem(
            section: _SettingsSection.units,
            icon: Icons.straighten,
            title: l10n.settingsUnits,
          ),
        ],
      ),
      _SettingsGroup(
        title: l10n.settingsSectionFuel,
        items: [
          _SettingsItem(
            section: _SettingsSection.fuel,
            icon: Icons.local_gas_station_outlined,
            title: l10n.settingsFuel,
          ),
          _SettingsItem(
            section: _SettingsSection.gasStations,
            icon: Icons.ev_station_outlined,
            title: l10n.settingsGasStations,
          ),
        ],
      ),
      _SettingsGroup(
        title: l10n.settingsSectionService,
        items: [
          _SettingsItem(
            section: _SettingsSection.services,
            icon: Icons.handyman_outlined,
            title: l10n.settingsServices,
          ),
          _SettingsItem(
            section: _SettingsSection.serviceCenters,
            icon: Icons.car_repair_outlined,
            title: l10n.settingsServiceCenters,
          ),
          _SettingsItem(
            section: _SettingsSection.partUnits,
            icon: Icons.square_foot_outlined,
            title: l10n.settingsPartUnits,
          ),
          _SettingsItem(
            section: _SettingsSection.parts,
            icon: Icons.build_outlined,
            title: l10n.settingsParts,
          ),
        ],
      ),
      _SettingsGroup(
        title: l10n.settingsSectionSystem,
        items: [
          _SettingsItem(
            section: _SettingsSection.backup,
            icon: Icons.import_export_outlined,
            title: l10n.settingsBackup,
          ),
          _SettingsItem(
            section: _SettingsSection.language,
            icon: Icons.language_outlined,
            title: l10n.settingsLanguage,
            subtitle: languageSubtitle,
          ),
          _SettingsItem(
            section: _SettingsSection.privacy,
            icon: Icons.privacy_tip_outlined,
            title: l10n.settingsPrivacy,
          ),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navSettings)),
      body: ListView(
        children: [
          for (final group in groups) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                group.title,
                style: theme.textTheme.titleSmall,
              ),
            ),
            for (final item in group.items) ...[
              _SettingsTile(item: item),
              const Divider(height: 1),
            ],
          ],
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.item});

  final _SettingsItem item;

  @override
  Widget build(BuildContext context) {
    final isPrivacy = item.section == _SettingsSection.privacy;
    return ListTile(
      leading: Icon(item.icon),
      title: Text(item.title),
      subtitle: item.subtitle == null ? null : Text(item.subtitle!),
      trailing: Icon(
        isPrivacy ? Icons.open_in_new : Icons.chevron_right,
      ),
      onTap: () {
        switch (item.section) {
          case _SettingsSection.cars:
            openCarsPage(context);
          case _SettingsSection.fuel:
            openFuelTypesPage(context);
          case _SettingsSection.parts:
            openPartsPage(context);
          case _SettingsSection.partUnits:
            openPartUnitsPage(context);
          case _SettingsSection.services:
            openServicesPage(context);
          case _SettingsSection.serviceCenters:
            openServiceCentersPage(context);
          case _SettingsSection.gasStations:
            openGasStationsPage(context);
          case _SettingsSection.reminders:
            openRemindersFromSettings(context);
          case _SettingsSection.units:
            openUnitsPage(context);
          case _SettingsSection.backup:
            openBackupPage(context);
          case _SettingsSection.language:
            openLanguagePage(context);
          case _SettingsSection.privacy:
            openPrivacyPolicy(context);
        }
      },
    );
  }
}

class _SettingsGroup {
  const _SettingsGroup({
    required this.title,
    required this.items,
  });

  final String title;
  final List<_SettingsItem> items;
}

class _SettingsItem {
  const _SettingsItem({
    required this.section,
    required this.icon,
    required this.title,
    this.subtitle,
  });

  final _SettingsSection section;
  final IconData icon;
  final String title;
  final String? subtitle;
}
