/// Events composition DI: re-exports fueling/maintenance read ports.
///
/// Events has no data layer; presentation aggregates sibling repositories.
/// Ports come from the composition root (not sibling feature di).
library;

export '../../../app/di/app_providers.dart'
    show fuelingRepositoryProvider, maintenanceRepositoryProvider;
