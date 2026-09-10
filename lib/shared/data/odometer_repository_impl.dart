import 'package:drift/drift.dart';

import '../../core/odometer_sequence.dart';
import '../domain/odometer_repository.dart';
import 'db/app_database.dart';

export '../../core/odometer_sequence.dart' show OdometerNeighbors;
export '../domain/odometer_repository.dart'
    show OdometerEventSource, OdometerRepository;

/// Drift implementation of [OdometerRepository].
class OdometerRepositoryImpl implements OdometerRepository {
  OdometerRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<double?> maxOdometerKm(
    int carId, {
    int? excludingFuelingId,
    int? excludingMaintenanceId,
  }) async {
    final fuelMax = await _maxInTable(
      table: 'fuelings',
      carId: carId,
      excludingId: excludingFuelingId,
      readsFrom: {_db.fuelings},
    );
    final maintMax = await _maxInTable(
      table: 'maintenances',
      carId: carId,
      excludingId: excludingMaintenanceId,
      readsFrom: {_db.maintenances},
    );
    if (fuelMax == null) return maintMax;
    if (maintMax == null) return fuelMax;
    return fuelMax > maintMax ? fuelMax : maintMax;
  }

  @override
  Future<OdometerNeighbors> odometerNeighbors({
    required int carId,
    required DateTime at,
    OdometerEventSource? editingSource,
    int? excludingId,
  }) async {
    final isCreate = editingSource == null || excludingId == null;
    final previousKm = await _neighborKm(
      carId: carId,
      at: at,
      editingSource: editingSource,
      excludingId: excludingId,
      isCreate: isCreate,
      previous: true,
    );
    final nextKm = await _neighborKm(
      carId: carId,
      at: at,
      editingSource: editingSource,
      excludingId: excludingId,
      isCreate: isCreate,
      previous: false,
    );
    return OdometerNeighbors(previousKm: previousKm, nextKm: nextKm);
  }

  Future<double?> _maxInTable({
    required String table,
    required int carId,
    required int? excludingId,
    required Set<TableInfo<Table, Object?>> readsFrom,
  }) async {
    final sql = excludingId == null
        ? 'SELECT MAX(odometer_km) AS m FROM $table '
            'WHERE car_id = ? AND odometer_km IS NOT NULL'
        : 'SELECT MAX(odometer_km) AS m FROM $table '
            'WHERE car_id = ? AND odometer_km IS NOT NULL AND id != ?';
    final variables = <Variable<Object>>[
      Variable.withInt(carId),
      if (excludingId != null) Variable.withInt(excludingId),
    ];
    final row = await _db
        .customSelect(sql, variables: variables, readsFrom: readsFrom)
        .getSingle();
    return row.read<double?>('m');
  }

  Future<double?> _neighborKm({
    required int carId,
    required DateTime at,
    required OdometerEventSource? editingSource,
    required int? excludingId,
    required bool isCreate,
    required bool previous,
  }) async {
    final excludeFueling = editingSource == OdometerEventSource.fueling
        ? excludingId
        : null;
    final excludeMaintenance =
        editingSource == OdometerEventSource.maintenance ? excludingId : null;

    final order = previous
        ? 'ORDER BY event_at DESC, source DESC, id DESC'
        : 'ORDER BY event_at ASC, source ASC, id ASC';

    final String predicate;
    final predicateVars = <Variable<Object>>[];

    if (isCreate) {
      // New event: every same-timestamp reading is treated as earlier.
      predicate = previous ? 'WHERE event_at <= ?' : 'WHERE event_at > ?';
      predicateVars.add(Variable.withDateTime(at));
    } else {
      final slotSource = editingSource!.index;
      final slotId = excludingId!;
      if (previous) {
        predicate = '''
          WHERE event_at < ?
             OR (event_at = ? AND source < ?)
             OR (event_at = ? AND source = ? AND id < ?)
        ''';
      } else {
        predicate = '''
          WHERE event_at > ?
             OR (event_at = ? AND source > ?)
             OR (event_at = ? AND source = ? AND id > ?)
        ''';
      }
      predicateVars.addAll([
        Variable.withDateTime(at),
        Variable.withDateTime(at),
        Variable.withInt(slotSource),
        Variable.withDateTime(at),
        Variable.withInt(slotSource),
        Variable.withInt(slotId),
      ]);
    }

    final fuelExclude = excludeFueling == null ? '' : ' AND id != ?';
    final maintExclude = excludeMaintenance == null ? '' : ' AND id != ?';

    // Placeholders: fueling car_id [+ exclude], maintenance car_id [+ exclude], then predicate.
    final variables = <Variable<Object>>[
      Variable.withInt(carId),
      if (excludeFueling != null) Variable.withInt(excludeFueling),
      Variable.withInt(carId),
      if (excludeMaintenance != null) Variable.withInt(excludeMaintenance),
      ...predicateVars,
    ];

    // source: 0 = fueling, 1 = maintenance (matches OdometerEventSource.index).
    final sql = '''
      SELECT km FROM (
        SELECT fueled_at AS event_at, 0 AS source, id, odometer_km AS km
        FROM fuelings
        WHERE car_id = ? AND odometer_km IS NOT NULL$fuelExclude
        UNION ALL
        SELECT serviced_at AS event_at, 1 AS source, id, odometer_km AS km
        FROM maintenances
        WHERE car_id = ? AND odometer_km IS NOT NULL$maintExclude
      )
      $predicate
      $order
      LIMIT 1
    ''';

    final row = await _db
        .customSelect(
          sql,
          variables: variables,
          readsFrom: {_db.fuelings, _db.maintenances},
        )
        .getSingleOrNull();
    return row?.read<double>('km');
  }
}
