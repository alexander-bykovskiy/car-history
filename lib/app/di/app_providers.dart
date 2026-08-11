/// Composition-root providers.
///
/// Prefs store defaults live in feature di (`preference_store_providers`,
/// `car_selection_store_provider`). DB ports live in [app_repository_providers].
/// App-chrome [selectedCarProvider] lives here so shell / tabs / navigation
/// do not treat `features/cars/di` as a hub.
library;

export 'app_repository_providers.dart';
export 'selected_car_provider.dart';
