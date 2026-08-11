import 'package:drift/drift.dart';

import '../../../../shared/data/db/app_database.dart';
import '../../domain/entities/fueling.dart';

FuelingRecord fuelingRecordFromRow(Fueling row) {
  return FuelingRecord(
    id: row.id,
    carId: row.carId,
    fuelTypeId: row.fuelTypeId,
    gasStationId: row.gasStationId,
    fueledAt: row.fueledAt,
    pricePerLiter: row.pricePerLiter,
    liters: row.liters,
    totalAmount: row.totalAmount,
    currencyCode: row.currencyCode,
    odometerKm: row.odometerKm,
  );
}

FuelingListItem fuelingListItemFromJoin(TypedResult row, AppDatabase db) {
  final fueling = row.readTable(db.fuelings);
  final chain = row.readTableOrNull(db.gasStationChains);
  return FuelingListItem(
    id: fueling.id,
    carId: fueling.carId,
    fuelTypeId: fueling.fuelTypeId,
    gasStationId: fueling.gasStationId,
    fueledAt: fueling.fueledAt,
    pricePerLiter: fueling.pricePerLiter,
    liters: fueling.liters,
    totalAmount: fueling.totalAmount,
    currencyCode: fueling.currencyCode,
    odometerKm: fueling.odometerKm,
    fuelTypeName: row.readTableOrNull(db.fuelTypes)?.name,
    gasStationName: chain?.name,
  );
}
