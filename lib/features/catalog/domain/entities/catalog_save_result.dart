/// Shared soft-delete catalog create/update / ensure outcome codes.
///
/// [restored] — ensure (or similar) already undeleted a soft-deleted match.
/// [needsRestoreConfirm] — create/update found a soft-deleted name conflict;
/// the UI should ask before calling restore.
enum CatalogSaveResult {
  created,
  updated,
  restored,
  needsRestoreConfirm,
  alreadyExists,
  emptyName,
}

/// Soft-delete uniqueness match for create vs ensure branching.
///
/// Create/update and ensure share find/match; they differ only on
/// [SoftDeleteMatchKind.softDeleted] (confirm vs auto-restore).
enum SoftDeleteMatchKind {
  missing,
  active,
  softDeleted,
}

SoftDeleteMatchKind softDeleteMatchKind(bool? isDeleted) {
  if (isDeleted == null) return SoftDeleteMatchKind.missing;
  return isDeleted
      ? SoftDeleteMatchKind.softDeleted
      : SoftDeleteMatchKind.active;
}

/// Create/update conflict code; null when there is no match ([missing]).
CatalogSaveResult? catalogCreateConflictResult(SoftDeleteMatchKind kind) {
  return switch (kind) {
    SoftDeleteMatchKind.missing => null,
    SoftDeleteMatchKind.softDeleted => CatalogSaveResult.needsRestoreConfirm,
    SoftDeleteMatchKind.active => CatalogSaveResult.alreadyExists,
  };
}
