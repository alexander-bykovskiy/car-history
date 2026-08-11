part of '../app_database.dart';

Future<void> _seedFuelTypes(AppDatabase db) async {
  final now = DateTime.now();

  await db.batch((batch) {
    batch.insertAll(db.fuelTypes, [
      FuelTypesCompanion.insert(
        name: db.seeds.fuelTypePetrol95,
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
      FuelTypesCompanion.insert(
        name: db.seeds.fuelTypePetrol100,
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
      FuelTypesCompanion.insert(
        name: db.seeds.fuelTypeDiesel,
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    ]);
  });
}

Future<void> _seedPartUnits(AppDatabase db) async {
  final now = DateTime.now();

  await db.batch((batch) {
    batch.insertAll(db.partUnits, [
      PartUnitsCompanion.insert(
        name: db.seeds.partUnitLiters,
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
      PartUnitsCompanion.insert(
        name: db.seeds.partUnitPieces,
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
      PartUnitsCompanion.insert(
        name: db.seeds.partUnitPackages,
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    ]);
  });
}

Future<void> _seedCarBrands(AppDatabase db) async {
  final now = DateTime.now();
  await db.batch((batch) {
    batch.insertAll(
      db.carBrands,
      kCarBrandSeeds
          .map(
            (name) => CarBrandsCompanion.insert(
              name: name,
              createdAt: Value(now),
            ),
          )
          .toList(),
      mode: InsertMode.insertOrIgnore,
    );
  });
}

/// Ensures at least one car exists (Brand / Model / current year / first color).
Future<void> _seedPlaceholderCar(AppDatabase db) async {
  final existing = await db.select(db.cars).get();
  if (existing.isNotEmpty) return;

  final now = DateTime.now();

  var brand = await (db.select(db.carBrands)
        ..where((t) => t.name.equals(db.seeds.seedCarBrand)))
      .getSingleOrNull();
  brand ??= await db.into(db.carBrands).insertReturning(
        CarBrandsCompanion.insert(
          name: db.seeds.seedCarBrand,
          createdAt: Value(now),
        ),
      );

  await db.into(db.cars).insert(
        CarsCompanion.insert(
          brandId: brand.id,
          model: Value(db.seeds.seedCarModel),
          year: Value(now.year),
          colorArgb: Value(db.seeds.defaultCarColorArgb),
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );
}
