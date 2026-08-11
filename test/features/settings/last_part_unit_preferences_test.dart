import 'package:car_history/features/settings/data/last_part_unit_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('PrefsLastPartUnitStore round-trips id', () async {
    SharedPreferences.setMockInitialValues({});
    final store = PrefsLastPartUnitStore();

    expect(await store.lastPartUnitId(), isNull);

    await store.setLastPartUnitId(7);
    expect(await store.lastPartUnitId(), 7);
  });
}
