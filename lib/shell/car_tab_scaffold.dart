import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/navigation/car_header_bar.dart';
import '../features/settings/di/preferences_providers.dart';
import '../l10n/app_localizations.dart';
import '../shared/presentation/double_tap_edit_tip.dart';

/// Layout for Data: car header + All / Fuelings / Maintenance tabs.
class CarTabScaffold extends ConsumerStatefulWidget {
  const CarTabScaffold({
    required this.allBody,
    required this.fuelingsBody,
    required this.maintenanceBody,
    required this.tabIndex,
    required this.onTabIndexChanged,
    this.showDoubleTapEditTip = false,
    super.key,
  });

  final Widget allBody;
  final Widget fuelingsBody;
  final Widget maintenanceBody;
  final int tabIndex;
  final ValueChanged<int> onTabIndexChanged;

  /// When true, shows a dismissible tip about double-tap editing (Data tabs).
  final bool showDoubleTapEditTip;

  @override
  ConsumerState<CarTabScaffold> createState() => _CarTabScaffoldState();
}

class _CarTabScaffoldState extends ConsumerState<CarTabScaffold>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.tabIndex,
    );
    _controller.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_controller.indexIsChanging) return;
    if (_controller.index != widget.tabIndex) {
      widget.onTabIndexChanged(_controller.index);
    }
  }

  @override
  void didUpdateWidget(CarTabScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tabIndex == _controller.index) return;
    // IndexedStack disables TickerMode for offstage children, so animateTo
    // would not finish. Jump synchronously when tickers are off.
    if (TickerMode.valuesOf(context).enabled) {
      _controller.animateTo(widget.tabIndex);
    } else {
      _controller.index = widget.tabIndex;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTabChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tipAsync = widget.showDoubleTapEditTip
        ? ref.watch(showDoubleTapEditTipProvider)
        : null;
    final showEditTip =
        widget.showDoubleTapEditTip && (tipAsync?.value ?? false);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CarHeaderBar(),
          Material(
            color: theme.colorScheme.surface.withValues(alpha: 0.5),
            elevation: 0,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            child: TabBar(
              controller: _controller,
              labelColor: theme.colorScheme.onSurface,
              unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
              indicatorColor: theme.colorScheme.primary,
              tabs: [
                Tab(icon: const Icon(Icons.dashboard_outlined), text: l10n.tabAll),
                Tab(
                  icon: const Icon(Icons.local_gas_station_outlined),
                  text: l10n.tabFuelings,
                ),
                Tab(
                  icon: const Icon(Icons.build_outlined),
                  text: l10n.tabMaintenance,
                ),
              ],
            ),
          ),
          if (showEditTip)
            DoubleTapEditTip(
              onDontShowAgain: () =>
                  ref.read(showDoubleTapEditTipProvider.notifier).dismiss(),
            ),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: [
                widget.allBody,
                widget.fuelingsBody,
                widget.maintenanceBody,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
