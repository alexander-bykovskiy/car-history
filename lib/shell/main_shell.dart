import 'package:flutter/material.dart';

import '../features/settings/presentation/pages/settings_page.dart';
import '../features/statistics/presentation/pages/statistics_page.dart';
import '../l10n/app_localizations.dart';
import 'data_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;
  int _carTabIndex = 0;

  void _onCarTabIndexChanged(int index) {
    if (_carTabIndex == index) return;
    setState(() => _carTabIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          DataPage(
            tabIndex: _carTabIndex,
            onTabIndexChanged: _onCarTabIndexChanged,
          ),
          const StatisticsPage(),
          const SettingsPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: [
          NavigationDestination(
            icon: Semantics(
              label: l10n.navData,
              child: const Icon(Icons.directions_car_outlined),
            ),
            selectedIcon: Semantics(
              label: l10n.navData,
              child: const Icon(Icons.directions_car),
            ),
            label: l10n.navData,
          ),
          NavigationDestination(
            icon: Semantics(
              label: l10n.navStatistics,
              child: const Icon(Icons.pie_chart_outline),
            ),
            selectedIcon: Semantics(
              label: l10n.navStatistics,
              child: const Icon(Icons.pie_chart),
            ),
            label: l10n.navStatistics,
          ),
          NavigationDestination(
            icon: Semantics(
              label: l10n.navSettings,
              child: const Icon(Icons.settings_outlined),
            ),
            selectedIcon: Semantics(
              label: l10n.navSettings,
              child: const Icon(Icons.settings),
            ),
            label: l10n.navSettings,
          ),
        ],
      ),
    );
  }
}
