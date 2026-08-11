import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/di/preferences_providers.dart';

/// Swipe-delete tip wiring shared by catalog list pages.
class CatalogSwipeDeleteTip {
  const CatalogSwipeDeleteTip({
    required this.show,
    required this.onDismiss,
  });

  final bool show;
  final VoidCallback onDismiss;
}

CatalogSwipeDeleteTip watchCatalogSwipeDeleteTip(WidgetRef ref) {
  final tipAsync = ref.watch(showSwipeDeleteTipProvider);
  return CatalogSwipeDeleteTip(
    show: tipAsync.hasValue && (tipAsync.value ?? false),
    onDismiss: () => ref.read(showSwipeDeleteTipProvider.notifier).dismiss(),
  );
}
