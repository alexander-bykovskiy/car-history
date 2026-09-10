import 'package:drift/drift.dart';

import '../../../shared/data/db/app_database.dart';
import '../../../core/name_normalizer.dart';
import '../../../core/named_match.dart';
import '../../../core/report_caught_error.dart';
import '../domain/entities/car_brand.dart';
import '../domain/repositories/car_brand_repository.dart';

CarBrandItem _mapBrand(CarBrand row) {
  return CarBrandItem(id: row.id, name: row.name);
}

class CarBrandRepositoryImpl implements CarBrandRepository {
  CarBrandRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<CarBrandItem>> watchAll() {
    return (_db.select(_db.carBrands)
          ..orderBy([(t) => OrderingTerm(expression: t.name)]))
        .watch()
        .map((rows) => rows.map(_mapBrand).toList());
  }

  @override
  Future<List<CarBrandItem>> search(String query) async {
    final normalized = NameNormalizer.normalize(query);
    final rows = await (_db.select(_db.carBrands)
          ..orderBy([(t) => OrderingTerm(expression: t.name)]))
        .get();

    final mapped = rows.map(_mapBrand);
    if (normalized.isEmpty) return mapped.toList();

    return mapped
        .where((row) => NameNormalizer.normalize(row.name).contains(normalized))
        .toList();
  }

  @override
  Future<CarBrandItem?> findByName(String rawName) async {
    final row = await findNamedCatalogMatch(
      loadAll: () => _db.select(_db.carBrands).get(),
      nameOf: (row) => row.name,
      isDeletedOf: (_) => false,
      rawName: rawName,
    );
    return row == null ? null : _mapBrand(row);
  }

  @override
  Future<CarBrandItem> findOrCreate(String rawName) async {
    final name = rawName.trim();
    final existing = await findByName(name);
    if (existing != null) return existing;

    try {
      final id = await _db.into(_db.carBrands).insert(
            CarBrandsCompanion.insert(
              name: name,
              createdAt: Value(DateTime.now()),
            ),
          );
      final created = await (_db.select(_db.carBrands)
            ..where((t) => t.id.equals(id)))
          .getSingle();
      return _mapBrand(created);
    } catch (e, st) {
      reportCaughtError(e, st, context: 'CarBrandRepositoryImpl.findOrCreate');
      final created = await findByName(name);
      if (created != null) return created;
      rethrow;
    }
  }
}
