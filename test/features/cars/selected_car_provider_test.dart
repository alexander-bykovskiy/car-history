import 'package:car_history/app/di/app_providers.dart';
import 'package:car_history/shared/data/db/app_database.dart';
import 'package:car_history/shared/data/db/database_seed_texts.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/test_app_overrides.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('single ProviderScope exposes selected car', (tester) async {
    SharedPreferences.setMockInitialValues({});

    final database = AppDatabase(
      executor: NativeDatabase.memory(),
      seeds: DatabaseSeedTexts.english,
    );
    // Force open + seed.
    await database.select(database.cars).get();

    await tester.pumpWidget(
      ProviderScope(
        overrides: testAppOverrides(database),
        child: const MaterialApp(home: _Probe()),
      ),
    );

    await tester.pumpAndSettle();

    final state = tester.state<_ProbeState>(find.byType(_Probe));
    expect(state.error, isNull, reason: '${state.error}');
    expect(state.carId, isNotNull);
    expect(state.carTitle, isNotEmpty);

    await database.close();
  });

  testWidgets('nested ProviderScope without remount fails overrides', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    final database = AppDatabase(
      executor: NativeDatabase.memory(),
      seeds: DatabaseSeedTexts.english,
    );
    await database.select(database.cars).get();

    final overrides = testAppOverrides(database);

    // Reproduces the pre-fix bootstrap bug: outer empty scope + inner overrides.
    await tester.pumpWidget(
      ProviderScope(
        child: ProviderScope(
          overrides: overrides,
          child: const MaterialApp(home: _Probe()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final state = tester.state<_ProbeState>(find.byType(_Probe));
    expect(
      state.error.toString(),
      contains('Provider not overridden'),
      reason: 'Documents why nested empty+override scopes break',
    );

    await database.close();
  });
}

class _Probe extends ConsumerStatefulWidget {
  const _Probe();

  @override
  ConsumerState<_Probe> createState() => _ProbeState();
}

class _ProbeState extends ConsumerState<_Probe> {
  int? carId;
  String? carTitle;
  Object? error;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(selectedCarProvider);
    error = async.hasError ? async.error : null;
    final car = async.value;
    carId = car?.id;
    carTitle = car?.displayTitle;
    return Text('car=$carId title=$carTitle err=$error');
  }
}
