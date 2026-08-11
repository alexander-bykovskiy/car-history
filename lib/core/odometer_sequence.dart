/// Chronological odometer neighbors around an event slot.
class OdometerNeighbors {
  const OdometerNeighbors({this.previousKm, this.nextKm});

  /// Latest reading strictly before this slot.
  final double? previousKm;

  /// Earliest reading strictly after this slot.
  final double? nextKm;
}

/// Result of comparing a reading against chronological neighbors.
class OdometerSequenceWarning {
  const OdometerSequenceWarning({
    required this.lowerThanEarlier,
    required this.higherThanLater,
  });

  final bool lowerThanEarlier;
  final bool higherThanLater;

  bool get hasWarning => lowerThanEarlier || higherThanLater;
}

/// Returns whether [odometerKm] breaks non-decreasing order vs [neighbors].
OdometerSequenceWarning checkOdometerSequence({
  required double odometerKm,
  required OdometerNeighbors neighbors,
}) {
  return OdometerSequenceWarning(
    lowerThanEarlier:
        neighbors.previousKm != null && odometerKm < neighbors.previousKm!,
    higherThanLater:
        neighbors.nextKm != null && odometerKm > neighbors.nextKm!,
  );
}
