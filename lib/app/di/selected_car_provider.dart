import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/cars/domain/entities/car.dart';
import 'app_repository_providers.dart';

/// App-chrome selected car stream. Lives in composition root so tabs / shell /
/// navigation do not import `features/cars/di` only for chrome state.
final selectedCarProvider = StreamProvider<CarListItem?>((ref) {
  return ref.watch(selectedCarServiceProvider).watchSelected();
});
