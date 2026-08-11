import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards ARCHITECTURE.md catalog car-scoped data style:
/// one [NamedCatalogCarScopedStore], no retired ops/factory/drift_bundle stack.
void main() {
  final catalogData = Directory('lib/features/catalog/data');

  test('retired named-catalog car-scoped stack files stay deleted', () {
    const retired = [
      'named_catalog_car_scoped_ops.dart',
      'named_catalog_car_scoped_factory.dart',
      'named_catalog_car_scoped_drift_bundle.dart',
      'named_catalog_match.dart',
    ];

    final present = <String>[];
    for (final name in retired) {
      final file = File('${catalogData.path}/$name');
      if (file.existsSync()) {
        present.add(file.path);
      }
    }

    expect(
      present,
      isEmpty,
      reason:
          'Retired car-scoped catalog files must stay deleted '
          '(use NamedCatalogCarScopedStore + core/named_match.dart):\n'
          '${present.join('\n')}',
    );
  });

  test('fuel type and part repositories use NamedCatalogCarScopedStore', () {
    final storePath = '${catalogData.path}/named_catalog_car_scoped_store.dart';
    final driftPath = '${catalogData.path}/named_catalog_car_scoped_drift.dart';
    expect(File(storePath).existsSync(), isTrue);
    expect(File(driftPath).existsSync(), isTrue);

    final driftSource = File(driftPath).readAsStringSync();
    expect(driftSource.contains('buildFuelTypeCarScopedStore'), isTrue);
    expect(driftSource.contains('buildPartCarScopedStore'), isTrue);
    expect(driftSource.contains('buildNamedCatalogCarScopedStore'), isTrue);

    final violations = <String>[];
    for (final name in [
      'fuel_type_repository_impl.dart',
      'part_repository_impl.dart',
    ]) {
      final file = File('${catalogData.path}/$name');
      final source = file.readAsStringSync();
      if (!source.contains('named_catalog_car_scoped_drift.dart') &&
          !source.contains('named_catalog_car_scoped_store.dart')) {
        violations.add('${file.path}: missing car-scoped store/drift import');
      }
      if (!source.contains('buildFuelTypeCarScopedStore') &&
          !source.contains('buildPartCarScopedStore') &&
          !source.contains('buildNamedCatalogCarScopedStore') &&
          !source.contains('NamedCatalogCarScopedStore')) {
        violations.add('${file.path}: does not use NamedCatalogCarScopedStore');
      }
      if (source.contains('NamedCatalogCarScopedDriftBundle') ||
          source.contains('buildNamedCatalogCarScopedOps') ||
          source.contains('NamedCatalogCarScopedOps')) {
        violations.add('${file.path}: references retired car-scoped stack');
      }
    }

    expect(
      violations,
      isEmpty,
      reason: 'Catalog car-scoped store violations:\n${violations.join('\n')}',
    );
  });

  test('NamedCatalogCarScopedWrites declares ensureForCar', () {
    final file = File(
      'lib/features/catalog/domain/repositories/'
      'named_catalog_car_scoped_writes.dart',
    );
    final source = file.readAsStringSync();
    expect(
      source.contains('ensureForCar'),
      isTrue,
      reason: 'Car-scoped write port must expose ensureForCar',
    );
  });
}
