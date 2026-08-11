import 'dart:typed_data';

/// Domain view of a car with brand label (no Drift types).
class CarListItem {
  const CarListItem({
    required this.id,
    required this.brandId,
    required this.brandName,
    this.model,
    this.year,
    this.photo,
    this.colorArgb,
  });

  final int id;
  final int brandId;
  final String brandName;
  final String? model;
  final int? year;
  final Uint8List? photo;
  final int? colorArgb;

  String get displayTitle {
    final parts = <String>[
      brandName,
      if (model != null && model!.isNotEmpty) model!,
    ];
    return parts.join(' ');
  }
}

enum CarDeleteResult { deleted, lastCar }

enum CarCreateResult { created, limitReached, photoTooLarge }

enum CarUpdateResult { updated, photoTooLarge }

class CarCreateOutcome {
  const CarCreateOutcome(this.result, {this.id});

  final CarCreateResult result;
  final int? id;
}
