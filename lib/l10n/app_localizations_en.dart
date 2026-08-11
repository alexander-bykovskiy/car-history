// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Car History';

  @override
  String get navData => 'Data';

  @override
  String get navStatistics => 'Statistics';

  @override
  String get navSettings => 'Settings';

  @override
  String get tabAll => 'All';

  @override
  String get tabFuelings => 'Fuelings';

  @override
  String get tabMaintenance => 'Maintenance';

  @override
  String get settingsCars => 'Cars';

  @override
  String get settingsFuel => 'Fuel';

  @override
  String get settingsParts => 'Parts';

  @override
  String get settingsServices => 'Services';

  @override
  String get settingsServiceCenters => 'Service centers';

  @override
  String get settingsGasStations => 'Gas station chains';

  @override
  String get settingsReminders => 'Reminders';

  @override
  String get settingsUnits => 'Units of measurement';

  @override
  String get settingsPartUnits => 'Part units';

  @override
  String get settingsCurrency => 'Currency';

  @override
  String get settingsSectionVehicle => 'Vehicle';

  @override
  String get settingsSectionFuel => 'Fuel';

  @override
  String get settingsSectionService => 'Service';

  @override
  String get settingsSectionSystem => 'System';

  @override
  String get fuelTypesTitle => 'Fuel types';

  @override
  String get fuelTypePetrol95 => 'Petrol 95';

  @override
  String get fuelTypePetrol100 => 'Petrol 100';

  @override
  String get fuelTypeDiesel => 'Diesel';

  @override
  String get actionAdd => 'Add';

  @override
  String get actionSave => 'Save';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionRestore => 'Restore';

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionDefault => 'Default';

  @override
  String get actionSetDefault => 'Set as default';

  @override
  String get fuelTypeNameLabel => 'Name';

  @override
  String get fuelTypeAddTitle => 'Add fuel type';

  @override
  String get fuelTypeEditTitle => 'Edit fuel type';

  @override
  String get fuelTypeDeleteConfirm =>
      'Are you sure you want to delete this item?';

  @override
  String get fuelTypeRestoreConfirm =>
      'This item was marked as deleted. Restore it?';

  @override
  String get fuelTypeAlreadyExists => 'An item with this name already exists';

  @override
  String get fuelTypeNameRequired => 'Enter a name';

  @override
  String get listEmpty => 'The list is empty';

  @override
  String get listLoadError => 'Could not load the list';

  @override
  String get carsTitle => 'Cars';

  @override
  String get carAddTitle => 'Add car';

  @override
  String get carEditTitle => 'Edit car';

  @override
  String get carBrandLabel => 'Brand';

  @override
  String get carDefaultLabel => 'Default auto';

  @override
  String get carModelLabel => 'Model';

  @override
  String get carYearLabel => 'Year';

  @override
  String get carPhotoLabel => 'Photo';

  @override
  String get carPhotoPick => 'Choose photo';

  @override
  String get carPhotoPickError =>
      'Could not open the photo picker. Fully restart the app and try again.';

  @override
  String get carPhotoRemove => 'Remove photo';

  @override
  String get carColorLabel => 'Color';

  @override
  String get carBrandRequired => 'Brand is required';

  @override
  String get carYearInvalid => 'Enter a valid year';

  @override
  String get carDeleteConfirm =>
      'Are you sure you want to delete this car? All related data will be deleted.';

  @override
  String get swipeDeleteTip => 'Swipe left to delete a record';

  @override
  String get doubleTapEditTip => 'Double-tap a record to edit it';

  @override
  String get tipDontShowAgain => 'Don\'t show again';

  @override
  String get seedCarBrand => 'Brand';

  @override
  String get seedCarModel => 'Model';

  @override
  String carLimitReached(int max) {
    return 'You can add up to $max cars';
  }

  @override
  String get carDeleteLastBlocked => 'You need at least one car';

  @override
  String get fuelTypeCarsLabel => 'Available for cars';

  @override
  String get catalogCarsRequired => 'Select at least one car';

  @override
  String get partsTitle => 'Parts';

  @override
  String get partNameLabel => 'Name';

  @override
  String get partAddTitle => 'Add part';

  @override
  String get partEditTitle => 'Edit part';

  @override
  String get partDeleteConfirm => 'Are you sure you want to delete this item?';

  @override
  String get partRestoreConfirm =>
      'This item was marked as deleted. Restore it?';

  @override
  String get partAlreadyExists => 'An item with this name already exists';

  @override
  String get partNameRequired => 'Enter a name';

  @override
  String get servicesTitle => 'Services';

  @override
  String get serviceNameLabel => 'Name';

  @override
  String get serviceAddTitle => 'Add service';

  @override
  String get serviceEditTitle => 'Edit service';

  @override
  String get serviceDeleteConfirm =>
      'Are you sure you want to delete this item?';

  @override
  String get serviceRestoreConfirm =>
      'This item was marked as deleted. Restore it?';

  @override
  String get serviceAlreadyExists => 'An item with this name already exists';

  @override
  String get serviceNameRequired => 'Enter a name';

  @override
  String get serviceIconLabel => 'Icon';

  @override
  String get serviceCentersTitle => 'Service centers';

  @override
  String get serviceCenterAddTitle => 'Add service center';

  @override
  String get serviceCenterEditTitle => 'Edit service center';

  @override
  String get serviceCenterDeleteConfirm =>
      'Are you sure you want to delete this item?';

  @override
  String get gasStationsTitle => 'Gas station chains';

  @override
  String get gasStationAddTitle => 'Add chain';

  @override
  String get gasStationEditTitle => 'Edit chain';

  @override
  String get gasStationAddAddressTitle => 'Add address';

  @override
  String get gasStationEditAddressTitle => 'Edit address';

  @override
  String get gasStationNoAddress => 'Without address';

  @override
  String get gasStationAddressesSection => 'Addresses';

  @override
  String get placeAddressRequired => 'Enter an address';

  @override
  String gasStationLocationsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count addresses',
      one: '1 address',
      zero: 'No addresses',
    );
    return '$_temp0';
  }

  @override
  String get gasStationDeleteConfirm =>
      'Are you sure you want to delete this item?';

  @override
  String get placeNameLabel => 'Name';

  @override
  String get placeAddressLabel => 'Address';

  @override
  String get placeNameRequired => 'Enter a name';

  @override
  String get placeAlreadyExists => 'An item with this name already exists';

  @override
  String get placeRestoreConfirm =>
      'This item was marked as deleted. Restore it?';

  @override
  String get unitsFuelSection => 'Fuel volume';

  @override
  String get unitsDistanceSection => 'Distance';

  @override
  String get unitLiters => 'Liters';

  @override
  String get unitUsGallons => 'US gallons';

  @override
  String get unitImperialGallons => 'Imperial gallons';

  @override
  String get unitKilometers => 'Kilometers';

  @override
  String get unitMiles => 'Miles';

  @override
  String get fuelingAddTitle => 'Add fueling';

  @override
  String get fuelingEditTitle => 'Edit fueling';

  @override
  String get fuelingDeleteConfirm =>
      'Are you sure you want to delete this fueling?';

  @override
  String get fuelingDateLabel => 'Date';

  @override
  String fuelingPriceLabel(String unit) {
    return 'Price per $unit';
  }

  @override
  String fuelingQuantityLabel(String unit) {
    return 'Quantity ($unit)';
  }

  @override
  String get fuelingTotalLabel => 'Total';

  @override
  String get fuelingPriceRequired => 'Enter price';

  @override
  String get fuelingQuantityRequired => 'Enter quantity';

  @override
  String get fuelingQuantityOrTotalRequired => 'Enter quantity or total';

  @override
  String get fuelingTotalRequired => 'Enter total amount';

  @override
  String fuelingOdometerLabel(String unit) {
    return 'Odometer ($unit)';
  }

  @override
  String get fuelingOdometerInvalid => 'Enter a valid odometer reading';

  @override
  String get fuelingOdometerSequenceTitle => 'Unusual odometer value';

  @override
  String get fuelingOdometerLowerTitle => 'Odometer lower than earlier';

  @override
  String fuelingOdometerLowerMessage(String value, String unit) {
    return 'The odometer is lower than an earlier reading ($value $unit).';
  }

  @override
  String get fuelingOdometerHigherTitle => 'Odometer higher than later';

  @override
  String fuelingOdometerHigherMessage(String value, String unit) {
    return 'The odometer is higher than a later reading ($value $unit).';
  }

  @override
  String get fuelingOdometerWarningFooter =>
      'This may distort fuel economy and other statistics. Save anyway?';

  @override
  String get actionContinue => 'Continue';

  @override
  String fuelingListSubtitle(String quantity, String price, String unit) {
    return '$quantity $unit · $price / $unit';
  }

  @override
  String get unitFuelShortLiter => 'L';

  @override
  String get unitFuelShortUsGallon => 'US gal';

  @override
  String get unitFuelShortImperialGallon => 'Imp gal';

  @override
  String get unitDistanceShortKm => 'km';

  @override
  String get unitDistanceShortMile => 'mi';

  @override
  String get currencyCodeLabel => 'Currency code';

  @override
  String get currencyCodeHint => 'EUR';

  @override
  String get currencyCodeHelp => 'Three Latin letters, e.g. USD, EUR, RSD';

  @override
  String get currencyCodeInvalid => 'Enter exactly 3 Latin letters';

  @override
  String get currenciesEditTitle => 'Currencies';

  @override
  String get currencyAddTitle => 'Add currency';

  @override
  String get currencyEditTitle => 'Edit currency';

  @override
  String get currencyDeleteConfirm =>
      'Are you sure you want to delete this currency?';

  @override
  String get currencyAlreadyExists => 'This currency is already in the list';

  @override
  String get currencyCannotDeleteLast => 'Keep at least one currency';

  @override
  String get fuelingFuelTypeLabel => 'Fuel type';

  @override
  String get fuelingFuelTypeRequired => 'Select or enter a fuel type';

  @override
  String get fuelingGasStationLabel => 'Gas station';

  @override
  String get fuelingGasStationEnsureFailed => 'Could not save the gas station';

  @override
  String get maintenanceAddTitle => 'Add maintenance';

  @override
  String get maintenanceEditTitle => 'Edit maintenance';

  @override
  String get maintenanceDeleteConfirm =>
      'Are you sure you want to delete this maintenance record?';

  @override
  String get maintenanceDateLabel => 'Date';

  @override
  String get maintenanceServiceLabel => 'Service';

  @override
  String get maintenanceServiceRequired => 'Select or enter a service';

  @override
  String get maintenanceTotalLabel => 'Service cost';

  @override
  String get maintenanceTotalInvalid => 'Enter a valid service cost';

  @override
  String get maintenanceOdometerWarningFooter =>
      'This may distort statistics. Save anyway?';

  @override
  String get maintenancePartsSection => 'Parts';

  @override
  String get maintenancePartAddTitle => 'Add part';

  @override
  String get maintenancePartEditTitle => 'Edit part';

  @override
  String get maintenancePartNameLabel => 'Part';

  @override
  String get maintenancePartNameRequired => 'Select or enter a part';

  @override
  String get maintenancePartAmountLabel => 'Price';

  @override
  String get maintenancePartAmountInvalid => 'Enter a valid price';

  @override
  String get maintenancePartQuantityLabel => 'Quantity';

  @override
  String get maintenancePartQuantityInvalid => 'Enter a valid quantity';

  @override
  String get maintenancePartUnitLabel => 'Unit';

  @override
  String get maintenancePartCommentLabel => 'Comment';

  @override
  String get maintenancePartDeleteConfirm => 'Remove this part from the list?';

  @override
  String get maintenanceGrandTotalLabel => 'Amount';

  @override
  String get partUnitsTitle => 'Part units';

  @override
  String get partUnitNameLabel => 'Name';

  @override
  String get partUnitAddTitle => 'Add unit';

  @override
  String get partUnitEditTitle => 'Edit unit';

  @override
  String get partUnitDeleteConfirm =>
      'Are you sure you want to delete this item?';

  @override
  String get partUnitRestoreConfirm =>
      'This item was marked as deleted. Restore it?';

  @override
  String get partUnitAlreadyExists => 'An item with this name already exists';

  @override
  String get partUnitNameRequired => 'Enter a name';

  @override
  String get partUnitLiters => 'Liters';

  @override
  String get partUnitPieces => 'Pieces';

  @override
  String get partUnitPackages => 'Packages';

  @override
  String get statsGroupByMonths => 'By months';

  @override
  String get statsGroupByYears => 'By years';

  @override
  String get statsPeriodYear => 'Year';

  @override
  String get statsLegendFuel => 'Fuel';

  @override
  String get statsLegendMaintenance => 'Maintenance';

  @override
  String get statsTotal => 'Total';

  @override
  String get statsFuelDetails => 'Fuel by type';

  @override
  String get statsMaintenanceDetails => 'Maintenance by service';

  @override
  String get statsUnknownCategory => 'Unknown';

  @override
  String get statsEmpty => 'No expenses for this period';

  @override
  String get statsSelectedPeriod => 'Selected period';

  @override
  String get remindersTitle => 'Reminders';

  @override
  String get reminderAddTitle => 'Add reminder';

  @override
  String get reminderEditTitle => 'Edit reminder';

  @override
  String get reminderTitleLabel => 'Title';

  @override
  String get reminderTitleRequired => 'Enter a title';

  @override
  String get reminderCarLabel => 'Car';

  @override
  String get reminderCarRequired => 'Select a car';

  @override
  String get reminderByDate => 'By date';

  @override
  String get reminderByOdometer => 'By odometer';

  @override
  String get reminderDueDateLabel => 'Due date';

  @override
  String get reminderDateHint => 'Select a date';

  @override
  String get reminderDateRequired => 'Select a due date';

  @override
  String get reminderOdometerRequired => 'Enter a target odometer reading';

  @override
  String get reminderTriggerRequired => 'Set a date, odometer, or both';

  @override
  String get reminderSyncFailed => 'Could not sync the linked reminder';

  @override
  String get reminderRemindBeforeDaysLabel => 'Remind before (days)';

  @override
  String reminderRemindBeforeDistanceLabel(String unit) {
    return 'Remind before ($unit)';
  }

  @override
  String get reminderRemindBeforeInvalid => 'Enter a valid non-negative value';

  @override
  String reminderRemindBeforeDays(int days) {
    return 'in $days days';
  }

  @override
  String reminderRemindBeforeDistance(String distance) {
    return 'before $distance';
  }

  @override
  String get reminderCompleted => 'Completed';

  @override
  String get reminderDeleteConfirm =>
      'Are you sure you want to delete this reminder?';

  @override
  String get maintenanceAddReminder => 'Add reminder';

  @override
  String get maintenanceEditReminder => 'Edit reminder';

  @override
  String get settingsBackup => 'Backup';

  @override
  String get backupDescription =>
      'Export all settings and events to a JSON file, share the backup with another app (for example Google Drive), or import a previously exported backup. Exact duplicates are skipped on import.';

  @override
  String get backupExport => 'Export to JSON';

  @override
  String get backupShare => 'Share backup';

  @override
  String get backupImport => 'Import from JSON';

  @override
  String get backupExportSuccess => 'Backup exported';

  @override
  String get backupShareSuccess => 'Backup shared';

  @override
  String get backupExportFailed => 'Could not export backup';

  @override
  String backupImportSuccess(int added, int skipped) {
    return 'Import finished: $added added, $skipped skipped';
  }

  @override
  String get backupImportFailed => 'Could not import backup';

  @override
  String get backupImportPrefsFailed =>
      'Data imported, but preferences could not be applied';

  @override
  String get backupImportEmpty => 'Backup file is empty';

  @override
  String get backupImportInvalid => 'Backup file is not valid JSON';

  @override
  String get backupImportUnsupportedVersion =>
      'This backup version is not supported';

  @override
  String get settingsPrivacy => 'Privacy policy';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageSystem => 'System default';

  @override
  String get privacyOpenFailed => 'Could not open the link';

  @override
  String get formActionFailed =>
      'Could not complete the action. Please try again.';

  @override
  String get appStartFailed =>
      'Could not start the app. Please reinstall or contact support.';

  @override
  String get photoTooLarge => 'Photo is too large. Choose a smaller image.';
}
