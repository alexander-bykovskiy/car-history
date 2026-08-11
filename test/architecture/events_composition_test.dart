import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards events composition: Data tabs and All Events open editors through
/// `app/navigation/open_event_forms.dart`, not sibling form pages.
void main() {
  test('AllEventsTab opens editors via app/navigation helpers', () {
    _expectOpensViaNavigation(
      'lib/features/events/presentation/pages/all_events_tab.dart',
      helpers: const [
        'openFuelingFormUsingPrefs',
        'openMaintenanceFormUsingPrefs',
        'openFuelingFormForEntry',
        'openMaintenanceFormForEntry',
      ],
    );
  });

  test('FuelingsTab opens editors via app/navigation helpers', () {
    _expectOpensViaNavigation(
      'lib/features/fueling/presentation/pages/fuelings_tab.dart',
      helpers: const [
        'openFuelingForm',
        'openFuelingFormForEntry',
      ],
    );
  });

  test('MaintenanceTab opens editors via app/navigation helpers', () {
    _expectOpensViaNavigation(
      'lib/features/maintenance/presentation/pages/maintenance_tab.dart',
      helpers: const [
        'openMaintenanceForm',
        'openMaintenanceFormForEntry',
      ],
    );
  });
}

void _expectOpensViaNavigation(
  String path, {
  required List<String> helpers,
}) {
  final source = File(path).readAsStringSync();

  expect(source, contains('open_event_forms.dart'));
  for (final helper in helpers) {
    expect(source, contains(helper), reason: '$path should call $helper');
  }
  expect(source, isNot(contains('fueling_form_page.dart')));
  expect(source, isNot(contains('maintenance_form_page.dart')));
}
