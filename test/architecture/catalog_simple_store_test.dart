import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards ARCHITECTURE.md catalog simple-named data style:
/// one [NamedCatalogSimpleStore], thin repos via simple_drift factories.
void main() {
  final catalogData = Directory('lib/features/catalog/data');

  test('simple named catalogs use NamedCatalogSimpleStore', () {
    final storePath = '${catalogData.path}/named_catalog_simple_store.dart';
    final driftPath = '${catalogData.path}/named_catalog_simple_drift.dart';
    expect(File(storePath).existsSync(), isTrue);
    expect(File(driftPath).existsSync(), isTrue);

    final storeSource = File(storePath).readAsStringSync();
    expect(storeSource.contains('requireWriteOverrides'), isTrue);

    final driftSource = File(driftPath).readAsStringSync();
    expect(driftSource.contains('buildPartUnitSimpleStore'), isTrue);
    expect(driftSource.contains('buildServiceSimpleStore'), isTrue);
    expect(driftSource.contains('buildServiceCenterSimpleStore'), isTrue);
    expect(driftSource.contains('buildNamedCatalogSimpleStore'), isTrue);
    expect(
      driftSource.contains('requireWriteOverrides: true'),
      isTrue,
      reason: 'service centers must require address write overrides',
    );

    final violations = <String>[];
    for (final name in [
      'part_unit_repository_impl.dart',
      'service_repository_impl.dart',
      'service_center_repository_impl.dart',
    ]) {
      final file = File('${catalogData.path}/$name');
      final source = file.readAsStringSync();
      if (!source.contains('named_catalog_simple_drift.dart') &&
          !source.contains('named_catalog_simple_store.dart')) {
        violations.add('${file.path}: missing simple store/drift import');
      }
      if (!source.contains('buildPartUnitSimpleStore') &&
          !source.contains('buildServiceSimpleStore') &&
          !source.contains('buildServiceCenterSimpleStore') &&
          !source.contains('NamedCatalogSimpleStore')) {
        violations.add('${file.path}: does not use NamedCatalogSimpleStore');
      }
      if (!source.contains('_store.restore')) {
        violations.add('${file.path}: restore bypasses NamedCatalogSimpleStore');
      }
    }

    final centerSource = File(
      '${catalogData.path}/service_center_repository_impl.dart',
    ).readAsStringSync();
    if (!centerSource.contains('insertNamed:')) {
      violations.add(
        'service_center_repository_impl.dart: create must pass insertNamed',
      );
    }
    if (!centerSource.contains('writeName:')) {
      violations.add(
        'service_center_repository_impl.dart: update must pass writeName',
      );
    }
    if (!centerSource.contains('markRestored:')) {
      violations.add(
        'service_center_repository_impl.dart: restore must pass markRestored',
      );
    }

    expect(
      violations,
      isEmpty,
      reason: 'Catalog simple store violations:\n${violations.join('\n')}',
    );
  });
}
