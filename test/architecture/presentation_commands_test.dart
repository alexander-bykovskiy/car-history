import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards ARCHITECTURE.md: DB commands from presentation go through use cases.
void main() {
  test('feature presentation does not call repository write methods', () {
    final violations = <String>[];
    final presentationDirs = Directory('lib/features')
        .listSync()
        .whereType<Directory>()
        .map((d) => Directory('${d.path}/presentation'))
        .where((d) => d.existsSync());

    // Includes ensureForCar / ensureFromInput — not only bare `ensure`.
    final writeMethod =
        r'(create|update|delete|restore|ensure(?:ForCar|FromInput)?)';
    final chainedWrite = RegExp(
      'RepositoryProvider\\)\\s*\\.\\s*$writeMethod\\b',
    );
    // Locals like `repository`, `brandRepo`, `carRepository`, `fuelingRepository`.
    final localRepoWrite = RegExp(
      '\\b(?:\\w*[Rr]epository|\\w*Repo|repository)\\s*\\.\\s*$writeMethod\\s*\\(',
    );
    final ensurerWrite = RegExp(
      r'\.(ensureForCar|ensureFromInput)\s*\(',
    );

    for (final dir in presentationDirs) {
      for (final file in _dartFiles(dir)) {
        final source = file.readAsStringSync();
        for (final match in chainedWrite.allMatches(source)) {
          violations.add('${file.path}: ${match.group(0)}');
        }
        for (final match in localRepoWrite.allMatches(source)) {
          violations.add('${file.path}: ${match.group(0)}');
        }
        for (final match in ensurerWrite.allMatches(source)) {
          violations.add('${file.path}: ${match.group(0)}');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Presentation must write via *UseCase providers, not repositories:\n'
          '${violations.join('\n')}',
    );
  });
}

Iterable<File> _dartFiles(Directory dir) sync* {
  for (final entity in dir.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) yield entity;
  }
}
