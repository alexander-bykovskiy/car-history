/// Editable maintenance fields for the form UI (no Drift types).
class MaintenanceFormData {
  const MaintenanceFormData({
    this.id,
    this.serviceId,
    this.reminderId,
    required this.servicedAt,
    required this.currencyCode,
    this.totalAmount,
    this.odometerKm,
    this.serviceName,
    this.serviceIconKey,
  });

  final int? id;
  final int? serviceId;
  final int? reminderId;
  final DateTime servicedAt;
  final String currencyCode;
  final double? totalAmount;
  final double? odometerKm;
  final String? serviceName;
  final String? serviceIconKey;

  bool get isEditing => id != null;
}
