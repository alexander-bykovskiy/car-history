import 'package:drift/drift.dart';

import '../../../../core/car_limits.dart';
import '../../../../core/name_normalizer.dart';
import '../../../../shared/data/db/app_database.dart';
import '../../../cars/domain/car_write_validation.dart';
import 'backup_import_models.dart';
import 'backup_json_codec.dart';
import 'backup_keys.dart';

/// Imports car brands and cars from a backup root map.
class BackupImportBrandsCars {
  BackupImportBrandsCars(this._db);

  final AppDatabase _db;

  Future<Map<int, int>> import(
    Map<String, dynamic> root,
    BackupImportCounters counters,
  ) async {
    final brandIdMap = <int, int>{};
    final existingBrands = await _db.select(_db.carBrands).get();
    final brandsByName = <String, CarBrand>{
      for (final row in existingBrands)
        NameNormalizer.normalize(row.name): row,
    };
    for (final item in BackupJsonCodec.list(root[BackupKeys.carBrands])) {
      final oldId = BackupJsonCodec.asInt(item[BackupKeys.id]);
      final name = BackupJsonCodec.asString(item[BackupKeys.name])?.trim();
      if (oldId == null || name == null || name.isEmpty) continue;

      final existing = brandsByName[NameNormalizer.normalize(name)];
      if (existing != null) {
        brandIdMap[oldId] = existing.id;
        counters.skipped++;
        continue;
      }
      final createdAt = BackupJsonCodec.parseDt(item[BackupKeys.createdAt]) ?? DateTime.now();
      final newId = await _db.into(_db.carBrands).insert(
            CarBrandsCompanion.insert(
              name: name,
              createdAt: Value(createdAt),
            ),
          );
      brandIdMap[oldId] = newId;
      brandsByName[NameNormalizer.normalize(name)] = CarBrand(
        id: newId,
        name: name,
        createdAt: createdAt,
      );
      counters.added++;
    }

    final carIdMap = <int, int>{};
    final existingCars = await _db.select(_db.cars).get();
    var carCount = existingCars.length;

    for (final item in BackupJsonCodec.list(root[BackupKeys.cars])) {
      final oldId = BackupJsonCodec.asInt(item[BackupKeys.id]);
      final oldBrandId = BackupJsonCodec.asInt(item[BackupKeys.brandId]);
      if (oldId == null || oldBrandId == null) continue;
      final brandId = brandIdMap[oldBrandId];
      if (brandId == null) continue;

      final model = BackupJsonCodec.asString(item[BackupKeys.model]);
      final year = BackupJsonCodec.asInt(item[BackupKeys.year]);
      final colorArgb = BackupJsonCodec.asInt(item[BackupKeys.colorArgb]);
      var photo = BackupJsonCodec.decodePhoto(item[BackupKeys.photoBase64]);
      if (isCarPhotoTooLarge(photo)) {
        photo = null;
      }

      Car? match;
      for (final car in existingCars) {
        if (car.brandId == brandId &&
            BackupJsonCodec.sameStr(car.model, model) &&
            car.year == year &&
            car.colorArgb == colorArgb &&
            BackupJsonCodec.sameBytes(car.photo, photo)) {
          match = car;
          break;
        }
      }
      if (match != null) {
        carIdMap[oldId] = match.id;
        counters.skipped++;
        continue;
      }

      if (carCount >= kMaxCars) {
        counters.skipped++;
        continue;
      }

      final now = DateTime.now();
      final newId = await _db.into(_db.cars).insert(
            CarsCompanion.insert(
              brandId: brandId,
              model: Value(model),
              year: Value(year),
              photo: Value(photo),
              colorArgb: Value(colorArgb),
              createdAt: Value(BackupJsonCodec.parseDt(item[BackupKeys.createdAt]) ?? now),
              updatedAt: Value(BackupJsonCodec.parseDt(item[BackupKeys.updatedAt]) ?? now),
            ),
          );
      carIdMap[oldId] = newId;
      existingCars.add(
        Car(
          id: newId,
          brandId: brandId,
          model: model,
          year: year,
          photo: photo,
          colorArgb: colorArgb,
          createdAt: BackupJsonCodec.parseDt(item[BackupKeys.createdAt]) ?? now,
          updatedAt: BackupJsonCodec.parseDt(item[BackupKeys.updatedAt]) ?? now,
        ),
      );
      carCount++;
      counters.added++;
    }

    return carIdMap;
  }
}
