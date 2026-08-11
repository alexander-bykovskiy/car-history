/// Stable JSON key contract for versioned app backups.
///
/// Keep string values identical to historical exports so old files still import.
abstract final class BackupKeys {
  // Root
  static const version = 'version';
  static const exportedAt = 'exportedAt';
  static const preferences = 'preferences';
  static const carBrands = 'carBrands';
  static const cars = 'cars';
  static const fuelTypes = 'fuelTypes';
  static const fuelTypeCars = 'fuelTypeCars';
  static const parts = 'parts';
  static const partCars = 'partCars';
  static const partUnits = 'partUnits';
  static const services = 'services';
  static const serviceCenters = 'serviceCenters';
  static const gasStationChains = 'gasStationChains';
  static const gasStationLocations = 'gasStationLocations';
  static const reminders = 'reminders';
  static const fuelings = 'fuelings';
  static const maintenances = 'maintenances';
  static const maintenanceParts = 'maintenanceParts';

  /// All root collection/object keys written by the exporter (except metadata).
  static const rootSections = <String>{
    preferences,
    carBrands,
    cars,
    fuelTypes,
    fuelTypeCars,
    parts,
    partCars,
    partUnits,
    services,
    serviceCenters,
    gasStationChains,
    gasStationLocations,
    reminders,
    fuelings,
    maintenances,
    maintenanceParts,
  };

  // Preferences
  static const fuelVolumeUnit = 'fuelVolumeUnit';
  static const distanceUnit = 'distanceUnit';
  static const currencyCode = 'currencyCode';
  static const currencyCodes = 'currencyCodes';

  // Common row fields
  static const id = 'id';
  static const name = 'name';
  static const isDeleted = 'isDeleted';
  static const createdAt = 'createdAt';
  static const updatedAt = 'updatedAt';
  static const carId = 'carId';
  static const brandId = 'brandId';
  static const model = 'model';
  static const year = 'year';
  static const photoBase64 = 'photoBase64';
  static const colorArgb = 'colorArgb';
  static const fuelTypeId = 'fuelTypeId';
  static const partId = 'partId';
  static const iconKey = 'iconKey';
  static const address = 'address';
  static const chainId = 'chainId';
  static const title = 'title';
  static const dueAt = 'dueAt';
  static const dueOdometerKm = 'dueOdometerKm';
  static const remindBeforeDays = 'remindBeforeDays';
  static const remindBeforeKm = 'remindBeforeKm';
  static const isCompleted = 'isCompleted';
  static const gasStationId = 'gasStationId';
  static const fueledAt = 'fueledAt';
  static const pricePerLiter = 'pricePerLiter';
  static const liters = 'liters';
  static const totalAmount = 'totalAmount';
  static const odometerKm = 'odometerKm';
  static const serviceId = 'serviceId';
  static const reminderId = 'reminderId';
  static const servicedAt = 'servicedAt';
  static const maintenanceId = 'maintenanceId';
  static const quantity = 'quantity';
  static const unitId = 'unitId';
  static const amount = 'amount';
  static const comment = 'comment';
}
