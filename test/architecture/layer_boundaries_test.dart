import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards ARCHITECTURE.md layer boundaries without a custom_lint package.
///
/// Forbidden:
/// - `features/*/presentation/**` → any `features/*/data/`
/// - `features/*/presentation/**` → sibling feature `presentation/pages/`
/// - `features/*/presentation/**` → sibling `presentation/**` outside allowlist
/// - `features/*/presentation/**` → `shell/`
/// - `features/*/domain/**`, `shared/domain/**`, `core/**` → Flutter / Riverpod
/// - `shared/**` → `features/**`
/// - `*_form_notifier.dart` → `package:flutter_riverpod` (no [WidgetRef])
///
/// Sibling presentation allowlist (ARCHITECTURE cross-feature navigation):
/// - `catalog/presentation/widgets/*_autocomplete_field.dart`
/// - from `events` only: `*/presentation/widgets/*_timeline_tile.dart`
void main() {
  final libFiles = _dartFiles(Directory('lib'));

  test('presentation does not import feature data or sibling pages', () {
    final violations = <String>[];

    for (final file in libFiles) {
      final feature = _featurePresentationOwner(file.path);
      if (feature == null) continue;

      for (final hit in _importsOf(file)) {
        final resolved = _resolveImport(filePath: file.path, uri: hit.uri);
        if (_isFeatureData(resolved)) {
          violations.add('${file.path}:${hit.line}: ${hit.raw}');
        }
        final siblingPage = RegExp(
          r'(?:^|/)features/([^/]+)/presentation/pages/',
        ).firstMatch(resolved);
        if (siblingPage != null && siblingPage.group(1) != feature) {
          violations.add('${file.path}:${hit.line}: ${hit.raw}');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason: 'Architecture boundary violations:\n${violations.join('\n')}',
    );
  });

  test('sibling presentation imports stay on documented allowlist', () {
    final violations = <String>[];

    for (final file in libFiles) {
      final feature = _featurePresentationOwner(file.path);
      if (feature == null) continue;

      for (final hit in _importsOf(file)) {
        final resolved = _resolveImport(filePath: file.path, uri: hit.uri);
        final sibling = RegExp(
          r'(?:^|/)features/([^/]+)/presentation/(.+)$',
        ).firstMatch(resolved);
        if (sibling == null) continue;

        final targetFeature = sibling.group(1)!;
        if (targetFeature == feature) continue;

        final relative = sibling.group(2)!;
        if (_allowedSiblingPresentationImport(
          fromFeature: feature,
          toFeature: targetFeature,
          presentationRelativePath: relative,
        )) {
          continue;
        }

        violations.add('${file.path}:${hit.line}: ${hit.raw}');
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Sibling presentation imports outside allowlist:\n'
          '${violations.join('\n')}',
    );
  });

  test('feature presentation does not import shell', () {
    final violations = <String>[];

    for (final file in libFiles) {
      if (_featurePresentationOwner(file.path) == null) continue;

      for (final hit in _importsOf(file)) {
        final resolved = _resolveImport(filePath: file.path, uri: hit.uri);
        if (RegExp(r'(?:^|/)shell/').hasMatch(resolved) ||
            hit.uri.contains('package:car_history/shell/')) {
          violations.add('${file.path}:${hit.line}: ${hit.raw}');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason: 'shell/ imports from feature presentation:\n'
          '${violations.join('\n')}',
    );
  });

  test('domain and core stay Flutter-free', () {
    final violations = <String>[];
    final flutterImport = RegExp(
      r'''package:flutter(_localizations|_riverpod|_test)?/''',
    );

    for (final file in libFiles) {
      final path = file.path.replaceAll('\\', '/');
      final isDomain = RegExp(
        r'lib/(features/[^/]+/domain|shared/domain)/',
      ).hasMatch(path);
      final isCore = path.contains('lib/core/');
      if (!isDomain && !isCore) continue;

      for (final hit in _importsOf(file)) {
        if (flutterImport.hasMatch(hit.uri)) {
          violations.add('${file.path}:${hit.line}: ${hit.raw}');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason: 'Flutter imports in domain/core:\n${violations.join('\n')}',
    );
  });

  test('shared does not import features', () {
    final violations = <String>[];

    for (final file in libFiles) {
      final path = file.path.replaceAll('\\', '/');
      if (!path.contains('lib/shared/')) continue;

      for (final hit in _importsOf(file)) {
        final resolved = _resolveImport(filePath: file.path, uri: hit.uri);
        if (RegExp(r'(?:^|/)features/').hasMatch(resolved) ||
            hit.uri.contains('package:car_history/features/')) {
          violations.add('${file.path}:${hit.line}: ${hit.raw}');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason: 'shared → features imports:\n${violations.join('\n')}',
    );
  });

  test('form notifiers do not import flutter_riverpod', () {
    final violations = <String>[];

    for (final file in libFiles) {
      final path = file.path.replaceAll('\\', '/');
      if (!path.contains('/presentation/') ||
          !path.endsWith('_form_notifier.dart')) {
        continue;
      }

      for (final hit in _importsOf(file)) {
        if (hit.uri.contains('package:flutter_riverpod')) {
          violations.add('${file.path}:${hit.line}: ${hit.raw}');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          '*_form_notifier.dart must not take WidgetRef via Riverpod:\n'
          '${violations.join('\n')}',
    );
  });

  test('feature domain does not import feature data', () {
    final violations = <String>[];

    for (final file in libFiles) {
      final path = file.path.replaceAll('\\', '/');
      if (!RegExp(r'lib/features/[^/]+/domain/').hasMatch(path)) continue;

      for (final hit in _importsOf(file)) {
        final resolved = _resolveImport(filePath: file.path, uri: hit.uri);
        if (_isFeatureData(resolved)) {
          violations.add('${file.path}:${hit.line}: ${hit.raw}');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason: 'domain → data imports:\n${violations.join('\n')}',
    );
  });

  test('feature data does not import feature presentation', () {
    final violations = <String>[];

    for (final file in libFiles) {
      final path = file.path.replaceAll('\\', '/');
      if (!RegExp(r'lib/features/[^/]+/data/').hasMatch(path)) continue;

      for (final hit in _importsOf(file)) {
        final resolved = _resolveImport(filePath: file.path, uri: hit.uri);
        if (RegExp(r'(?:^|/)features/[^/]+/presentation/').hasMatch(resolved) ||
            RegExp(
              r'package:car_history/features/[^/]+/presentation/',
            ).hasMatch(hit.uri)) {
          violations.add('${file.path}:${hit.line}: ${hit.raw}');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason: 'data → presentation imports:\n${violations.join('\n')}',
    );
  });
}

class _ImportHit {
  const _ImportHit({
    required this.line,
    required this.uri,
    required this.raw,
  });

  final int line;
  final String uri;
  final String raw;
}

List<File> _dartFiles(Directory root) {
  if (!root.existsSync()) return const [];
  return root
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();
}

String? _featurePresentationOwner(String filePath) {
  final normalized = filePath.replaceAll('\\', '/');
  return RegExp(
    r'lib/features/([^/]+)/presentation/',
  ).firstMatch(normalized)?.group(1);
}

Iterable<_ImportHit> _importsOf(File file) sync* {
  final lines = file.readAsLinesSync();
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i].trimLeft();
    if (!line.startsWith('import ')) continue;
    final uriMatch = RegExp(r'''['"]([^'"]+)['"]''').firstMatch(line);
    if (uriMatch == null) continue;
    yield _ImportHit(line: i + 1, uri: uriMatch.group(1)!, raw: line);
  }
}

/// Resolves to a path-like string with forward slashes (may start with `lib/`).
String _resolveImport({required String filePath, required String uri}) {
  if (uri.startsWith('package:car_history/')) {
    return 'lib/${uri.substring('package:car_history/'.length)}';
  }
  if (uri.startsWith('package:')) {
    return uri;
  }
  if (uri.startsWith('dart:')) {
    return uri;
  }

  final segments = filePath.replaceAll('\\', '/').split('/');
  segments.removeLast();
  for (final part in uri.split('/')) {
    if (part == '..') {
      if (segments.isNotEmpty) segments.removeLast();
    } else if (part != '.' && part.isNotEmpty) {
      segments.add(part);
    }
  }
  return segments.join('/');
}

bool _isFeatureData(String resolved) {
  return RegExp(r'(?:^|/)features/[^/]+/data/').hasMatch(resolved) ||
      RegExp(r'package:car_history/features/[^/]+/data/').hasMatch(resolved);
}

bool _allowedSiblingPresentationImport({
  required String fromFeature,
  required String toFeature,
  required String presentationRelativePath,
}) {
  // Catalog autocomplete widgets may be imported from any feature forms.
  if (toFeature == 'catalog' &&
      RegExp(
        r'^widgets/[^/]+_autocomplete_field\.dart$',
      ).hasMatch(presentationRelativePath)) {
    return true;
  }

  // Timeline tile builders only for the composition-only events feature.
  if (fromFeature == 'events' &&
      (toFeature == 'fueling' || toFeature == 'maintenance') &&
      RegExp(
        r'^widgets/[^/]+_timeline_tile\.dart$',
      ).hasMatch(presentationRelativePath)) {
    return true;
  }

  return false;
}
