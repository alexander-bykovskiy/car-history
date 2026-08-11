import 'package:flutter/material.dart';

import '../features/events/presentation/pages/all_events_tab.dart';
import '../features/fueling/presentation/pages/fuelings_tab.dart';
import '../features/maintenance/presentation/pages/maintenance_tab.dart';
import 'car_tab_scaffold.dart';

class DataPage extends StatelessWidget {
  const DataPage({
    required this.tabIndex,
    required this.onTabIndexChanged,
    super.key,
  });

  final int tabIndex;
  final ValueChanged<int> onTabIndexChanged;

  @override
  Widget build(BuildContext context) {
    return CarTabScaffold(
      tabIndex: tabIndex,
      onTabIndexChanged: onTabIndexChanged,
      showDoubleTapEditTip: true,
      allBody: const AllEventsTab(),
      fuelingsBody: const FuelingsTab(),
      maintenanceBody: const MaintenanceTab(),
    );
  }
}
