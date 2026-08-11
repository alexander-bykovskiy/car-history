import 'fueling.dart';

enum FuelingSaveResult {
  created,
  updated,
  invalidPrice,
  invalidQuantityOrTotal,
  invalidOdometer,
}

class FuelingSaveOutcome {
  const FuelingSaveOutcome(this.result, {this.item});

  final FuelingSaveResult result;
  final FuelingRecord? item;
}
