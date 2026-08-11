/// List/timeline row for a maintenance event.
class MaintenanceListItem {
  const MaintenanceListItem({
    required this.id,
    required this.carId,
    required this.servicedAt,
    required this.partsTotal,
    required this.currencyCode,
    this.serviceId,
    this.reminderId,
    this.totalAmount,
    this.odometerKm,
    this.serviceName,
    this.serviceIconKey,
  });

  final int id;
  final int carId;
  final int? serviceId;
  final int? reminderId;
  final DateTime servicedAt;
  final double? totalAmount;
  final String currencyCode;
  final double? odometerKm;
  final String? serviceName;
  final String? serviceIconKey;
  final double partsTotal;

  double? get displayTotal {
    final labor = totalAmount ?? 0;
    final total = labor + partsTotal;
    if (total <= 0) return null;
    return total;
  }
}

/// Persisted maintenance fields after create/update or for prefill.
class MaintenanceRecord {
  const MaintenanceRecord({
    required this.id,
    required this.carId,
    required this.servicedAt,
    required this.currencyCode,
    this.serviceId,
    this.reminderId,
    this.totalAmount,
    this.odometerKm,
  });

  final int id;
  final int carId;
  final int? serviceId;
  final int? reminderId;
  final DateTime servicedAt;
  final double? totalAmount;
  final String currencyCode;
  final double? odometerKm;
}

class MaintenancePartLine {
  const MaintenancePartLine({
    required this.partId,
    required this.partName,
    required this.quantity,
    this.amount,
    this.unitId,
    this.unitName,
    this.comment,
    this.id,
  });

  final int? id;
  final int partId;
  final String partName;
  final double quantity;
  final int? unitId;
  final String? unitName;
  final double? amount;
  final String? comment;

  double? get lineTotal {
    if (amount == null) return null;
    return quantity * amount!;
  }
}

class MaintenancePartInput {
  const MaintenancePartInput({
    required this.partId,
    required this.quantity,
    this.unitId,
    this.amount,
    this.comment,
  });

  final int partId;
  final double quantity;
  final int? unitId;
  final double? amount;
  final String? comment;
}
