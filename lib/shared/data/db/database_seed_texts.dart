/// Localized catalog/placeholder strings used when seeding a fresh database.
///
/// Resolved at app bootstrap (where l10n is available) and injected into
/// [AppDatabase], so the DB layer does not depend on Flutter UI or l10n.
class DatabaseSeedTexts {
  const DatabaseSeedTexts({
    required this.fuelTypePetrol95,
    required this.fuelTypePetrol100,
    required this.fuelTypeDiesel,
    required this.partUnitLiters,
    required this.partUnitPieces,
    required this.partUnitPackages,
    required this.seedCarBrand,
    required this.seedCarModel,
    required this.defaultCarColorArgb,
  });

  /// English defaults matching [AppLocalizations] `en` — used in tests
  /// and as a safe fallback when bootstrap does not inject seeds.
  static const english = DatabaseSeedTexts(
    fuelTypePetrol95: 'Petrol 95',
    fuelTypePetrol100: 'Petrol 100',
    fuelTypeDiesel: 'Diesel',
    partUnitLiters: 'Liters',
    partUnitPieces: 'Pieces',
    partUnitPackages: 'Packages',
    seedCarBrand: 'Brand',
    seedCarModel: 'Model',
    // Matches first entry of kCarColorOptions (black).
    defaultCarColorArgb: 0xFF000000,
  );

  final String fuelTypePetrol95;
  final String fuelTypePetrol100;
  final String fuelTypeDiesel;
  final String partUnitLiters;
  final String partUnitPieces;
  final String partUnitPackages;
  final String seedCarBrand;
  final String seedCarModel;
  final int defaultCarColorArgb;
}
