import 'package:drift/drift.dart';

import '../../../shared/data/db/app_database.dart';
import '../../../core/car_limits.dart';
import '../domain/car_write_validation.dart';
import '../domain/entities/car.dart';
import '../domain/repositories/car_repository.dart';

class CarRepositoryImpl implements CarRepository {
  CarRepositoryImpl(this._db);

  final AppDatabase _db;

  CarListItem _mapJoined(TypedResult row) {
    final car = row.readTable(_db.cars);
    return CarListItem(
      id: car.id,
      brandId: car.brandId,
      brandName: row.readTable(_db.carBrands).name,
      model: car.model,
      year: car.year,
      photo: car.photo,
      colorArgb: car.colorArgb,
    );
  }

  List<CarListItem> _mapJoinedCars(List<TypedResult> rows) {
    return rows.map(_mapJoined).toList();
  }

  @override
  Stream<List<CarListItem>> watchAll() {
    final query = _db.select(_db.cars).join([
      innerJoin(
        _db.carBrands,
        _db.carBrands.id.equalsExp(_db.cars.brandId),
      ),
    ])
      ..orderBy([
        OrderingTerm.asc(_db.carBrands.name),
        OrderingTerm.asc(_db.cars.model),
      ]);

    return query.watch().map(_mapJoinedCars);
  }

  @override
  Future<int> count() async {
    final rows = await _db.select(_db.cars).get();
    return rows.length;
  }

  @override
  Future<List<CarListItem>> listAll() async {
    final query = _db.select(_db.cars).join([
      innerJoin(
        _db.carBrands,
        _db.carBrands.id.equalsExp(_db.cars.brandId),
      ),
    ])
      ..orderBy([
        OrderingTerm.asc(_db.carBrands.name),
        OrderingTerm.asc(_db.cars.model),
      ]);
    return _mapJoinedCars(await query.get());
  }

  @override
  Future<CarCreateOutcome> create({
    required int brandId,
    String? model,
    int? year,
    Uint8List? photo,
    int? colorArgb,
  }) async {
    if (isCarPhotoTooLarge(photo)) {
      return const CarCreateOutcome(CarCreateResult.photoTooLarge);
    }
    final existingCount = await count();
    if (existingCount >= kMaxCars) {
      return const CarCreateOutcome(CarCreateResult.limitReached);
    }

    final now = DateTime.now();
    final id = await _db.into(_db.cars).insert(
          CarsCompanion.insert(
            brandId: brandId,
            model: Value(model),
            year: Value(year),
            photo: Value(photo),
            colorArgb: Value(colorArgb),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );

    return CarCreateOutcome(CarCreateResult.created, id: id);
  }

  @override
  Future<CarUpdateResult> update({
    required int id,
    required int brandId,
    String? model,
    int? year,
    Uint8List? photo,
    int? colorArgb,
  }) async {
    if (isCarPhotoTooLarge(photo)) {
      return CarUpdateResult.photoTooLarge;
    }
    await (_db.update(_db.cars)..where((t) => t.id.equals(id))).write(
      CarsCompanion(
        brandId: Value(brandId),
        model: Value(model),
        year: Value(year),
        photo: Value(photo),
        colorArgb: Value(colorArgb),
        updatedAt: Value(DateTime.now()),
      ),
    );
    return CarUpdateResult.updated;
  }

  @override
  Future<CarDeleteResult> delete(int id) async {
    if (await count() <= 1) {
      return CarDeleteResult.lastCar;
    }

    await (_db.delete(_db.cars)..where((t) => t.id.equals(id))).go();
    return CarDeleteResult.deleted;
  }
}
