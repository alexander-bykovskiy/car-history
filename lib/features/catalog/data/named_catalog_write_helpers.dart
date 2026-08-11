import '../domain/entities/named_catalog_item.dart';

/// Shared ensure-for-car flow for car-scoped named catalogs (fuel type, part).
///
/// Soft-deleted matches are restored in one [restore] call. Active matches that
/// are car-scoped get [carId] appended to links when missing.
Future<NamedCatalogSaveOutcome> ensureNamedCatalogForCar({
  required String rawName,
  required int carId,
  required Future<NamedCatalogItem?> Function(String rawName) findMatching,
  required Future<NamedCatalogItem?> Function(int id) getById,
  required Future<List<int>> Function(int id) carIdsFor,
  required Future<void> Function(
    int id, {
    required List<int> carIds,
    required bool appliesToAll,
  }) setCars,
  required Future<void> Function(
    NamedCatalogItem item, {
    List<int>? carIds,
    bool appliesToAll,
  }) restore,
  required Future<NamedCatalogSaveOutcome> Function(
    String name, {
    required List<int> carIds,
    required bool appliesToAll,
  }) create,
}) async {
  final name = rawName.trim();
  if (name.isEmpty) {
    return const NamedCatalogSaveOutcome(CatalogSaveResult.emptyName);
  }

  final existing = await findMatching(name);
  if (existing != null) {
    if (existing.isDeleted) {
      await restore(
        existing,
        carIds: [carId],
        appliesToAll: false,
      );
      final restored = await getById(existing.id);
      return NamedCatalogSaveOutcome(
        CatalogSaveResult.restored,
        item: restored,
      );
    }

    final links = await carIdsFor(existing.id);
    if (links.isNotEmpty && !links.contains(carId)) {
      await setCars(
        existing.id,
        carIds: [...links, carId],
        appliesToAll: false,
      );
    }
    return NamedCatalogSaveOutcome(
      CatalogSaveResult.alreadyExists,
      item: existing,
    );
  }

  return create(
    name,
    carIds: [carId],
    appliesToAll: false,
  );
}

/// Name-conflict check for create/update before writing a row.
NamedCatalogSaveOutcome? namedCatalogNameConflict(
  NamedCatalogItem? existing, {
  int? excludeId,
}) {
  if (existing == null) return null;
  if (excludeId != null && existing.id == excludeId) return null;
  final result = catalogCreateConflictResult(
    softDeleteMatchKind(existing.isDeleted),
  );
  if (result == null) return null;
  return NamedCatalogSaveOutcome(result, item: existing);
}

Future<NamedCatalogSaveOutcome> createNamedCatalogCarScoped({
  required String rawName,
  required List<int> carIds,
  required bool appliesToAll,
  required Future<NamedCatalogItem?> Function(String name) findMatching,
  required Future<int> Function(String name) insertNamed,
  required Future<void> Function(
    int id, {
    required List<int> carIds,
    required bool appliesToAll,
  }) setCars,
  required Future<NamedCatalogItem?> Function(int id) getById,
}) async {
  final name = rawName.trim();
  if (name.isEmpty) {
    return const NamedCatalogSaveOutcome(CatalogSaveResult.emptyName);
  }

  final existing = await findMatching(name);
  final conflict = namedCatalogNameConflict(existing);
  if (conflict != null) return conflict;

  final id = await insertNamed(name);
  await setCars(id, carIds: carIds, appliesToAll: appliesToAll);
  final created = await getById(id);
  return NamedCatalogSaveOutcome(
    CatalogSaveResult.created,
    item: created,
  );
}

Future<NamedCatalogSaveOutcome> updateNamedCatalogCarScoped({
  required NamedCatalogItem current,
  required String rawName,
  required List<int> carIds,
  required bool appliesToAll,
  required Future<NamedCatalogItem?> Function(String name) findMatching,
  required Future<void> Function(String name) writeName,
  required Future<void> Function(
    int id, {
    required List<int> carIds,
    required bool appliesToAll,
  }) setCars,
  required Future<NamedCatalogItem?> Function(int id) getById,
}) async {
  final name = rawName.trim();
  if (name.isEmpty) {
    return const NamedCatalogSaveOutcome(CatalogSaveResult.emptyName);
  }

  final existing = await findMatching(name);
  final conflict = namedCatalogNameConflict(existing, excludeId: current.id);
  if (conflict != null) return conflict;

  await writeName(name);
  await setCars(current.id, carIds: carIds, appliesToAll: appliesToAll);
  final updated = await getById(current.id);
  return NamedCatalogSaveOutcome(
    CatalogSaveResult.updated,
    item: updated,
  );
}

Future<NamedCatalogSaveOutcome> createNamedCatalogSimple({
  required String rawName,
  required Future<NamedCatalogItem?> Function(String name) findMatching,
  required Future<int> Function(String name) insertNamed,
  required Future<NamedCatalogItem?> Function(int id) getById,
}) async {
  final name = rawName.trim();
  if (name.isEmpty) {
    return const NamedCatalogSaveOutcome(CatalogSaveResult.emptyName);
  }

  final conflict = namedCatalogNameConflict(await findMatching(name));
  if (conflict != null) return conflict;

  final id = await insertNamed(name);
  final created = await getById(id);
  return NamedCatalogSaveOutcome(
    CatalogSaveResult.created,
    item: created,
  );
}

Future<NamedCatalogSaveOutcome> updateNamedCatalogSimple({
  required NamedCatalogItem current,
  required String rawName,
  required Future<NamedCatalogItem?> Function(String name) findMatching,
  required Future<void> Function(String name) writeName,
  required Future<NamedCatalogItem?> Function(int id) getById,
}) async {
  final name = rawName.trim();
  if (name.isEmpty) {
    return const NamedCatalogSaveOutcome(CatalogSaveResult.emptyName);
  }

  final conflict =
      namedCatalogNameConflict(await findMatching(name), excludeId: current.id);
  if (conflict != null) return conflict;

  await writeName(name);
  final updated = await getById(current.id);
  return NamedCatalogSaveOutcome(
    CatalogSaveResult.updated,
    item: updated,
  );
}

/// Ensure (find / restore soft-deleted / create) for non-car-scoped named catalogs.
Future<NamedCatalogSaveOutcome> ensureNamedCatalogSimple({
  required String rawName,
  required Future<NamedCatalogItem?> Function(String rawName) findMatching,
  required Future<NamedCatalogItem?> Function(int id) getById,
  required Future<void> Function(NamedCatalogItem item) restore,
  required Future<NamedCatalogSaveOutcome> Function(String name) create,
}) async {
  final name = rawName.trim();
  if (name.isEmpty) {
    return const NamedCatalogSaveOutcome(CatalogSaveResult.emptyName);
  }

  final existing = await findMatching(name);
  if (existing != null) {
    if (existing.isDeleted) {
      await restore(existing);
      final restored = await getById(existing.id);
      return NamedCatalogSaveOutcome(
        CatalogSaveResult.restored,
        item: restored,
      );
    }
    return NamedCatalogSaveOutcome(
      CatalogSaveResult.alreadyExists,
      item: existing,
    );
  }

  return create(name);
}

Future<void> softOrHardDeleteNamedCatalog({
  required Future<bool> Function() hasReferences,
  required Future<void> Function() softDelete,
  required Future<void> Function() hardDelete,
}) async {
  if (await hasReferences()) {
    await softDelete();
  } else {
    await hardDelete();
  }
}
