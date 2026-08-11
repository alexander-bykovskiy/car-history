/// Editable part line held while the maintenance form is open.
class DraftPartLine {
  const DraftPartLine({
    required this.localId,
    required this.name,
    required this.quantity,
    this.unitId,
    this.unitName,
    this.amount,
    this.comment,
  });

  final int localId;
  final String name;
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
