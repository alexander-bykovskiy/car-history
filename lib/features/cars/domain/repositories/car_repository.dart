import 'dart:typed_data';

import '../entities/car.dart';

abstract class CarRepository {
  Stream<List<CarListItem>> watchAll();

  Future<int> count();

  Future<List<CarListItem>> listAll();

  Future<CarCreateOutcome> create({
    required int brandId,
    String? model,
    int? year,
    Uint8List? photo,
    int? colorArgb,
  });

  Future<CarUpdateResult> update({
    required int id,
    required int brandId,
    String? model,
    int? year,
    Uint8List? photo,
    int? colorArgb,
  });

  Future<CarDeleteResult> delete(int id);
}
