import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/di/app_providers.dart';
import '../../features/cars/presentation/widgets/selected_car_header.dart';
import 'open_reminders_page.dart';

/// Composition-root chrome: status bar + [SelectedCarHeader].
///
/// Used by Data tabs and Statistics so feature pages do not import cars UI.
/// Wires reminder alert stream here to keep cars presentation free of reminders.
class CarHeaderBar extends ConsumerWidget {
  const CarHeaderBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carId = ref.watch(selectedCarProvider).value?.id;
    final alertStream = carId == null
        ? null
        : ref.watch(reminderRepositoryProvider).watchAlertLevel(carId);
    final theme = Theme.of(context);
    final chrome = theme.colorScheme.surface;
    final isDark = theme.brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: chrome,
        statusBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
      child: ColoredBox(
        color: chrome,
        child: SafeArea(
          bottom: false,
          child: SelectedCarHeader(
            alertLevelStream: alertStream,
            onRemindersTap: () => openRemindersPage(context),
          ),
        ),
      ),
    );
  }
}
