import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_hy.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('hy'),
    Locale('ru'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Car History'**
  String get appTitle;

  /// Navigation bar label for the data tab
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get navData;

  /// Navigation bar label for the statistics tab
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get navStatistics;

  /// Navigation bar label for the settings tab
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// Tab label for the combined all-records section on Data and Statistics
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get tabAll;

  /// Tab label for fuelings section on Data and Statistics
  ///
  /// In en, this message translates to:
  /// **'Fuelings'**
  String get tabFuelings;

  /// Tab label for maintenance section on Data and Statistics
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get tabMaintenance;

  /// Settings list item for cars
  ///
  /// In en, this message translates to:
  /// **'Cars'**
  String get settingsCars;

  /// Settings list item for fuel
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get settingsFuel;

  /// Settings list item for parts
  ///
  /// In en, this message translates to:
  /// **'Parts'**
  String get settingsParts;

  /// Settings list item for services
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get settingsServices;

  /// Settings list item for service centers
  ///
  /// In en, this message translates to:
  /// **'Service centers'**
  String get settingsServiceCenters;

  /// Settings list item for gas station chains
  ///
  /// In en, this message translates to:
  /// **'Gas station chains'**
  String get settingsGasStations;

  /// Settings list item for reminders
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get settingsReminders;

  /// Settings list item for units of measurement
  ///
  /// In en, this message translates to:
  /// **'Units of measurement'**
  String get settingsUnits;

  /// Settings list item for part units of measure
  ///
  /// In en, this message translates to:
  /// **'Part units'**
  String get settingsPartUnits;

  /// Settings list item for currency
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get settingsCurrency;

  /// Settings section header for vehicle-related items
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get settingsSectionVehicle;

  /// Settings section header for fuel-related items
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get settingsSectionFuel;

  /// Settings section header for service and parts items
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get settingsSectionService;

  /// Settings section header for system items
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsSectionSystem;

  /// Title of the fuel types settings screen
  ///
  /// In en, this message translates to:
  /// **'Fuel types'**
  String get fuelTypesTitle;

  /// Seed label for petrol 95
  ///
  /// In en, this message translates to:
  /// **'Petrol 95'**
  String get fuelTypePetrol95;

  /// Seed label for petrol 100
  ///
  /// In en, this message translates to:
  /// **'Petrol 100'**
  String get fuelTypePetrol100;

  /// Seed label for diesel
  ///
  /// In en, this message translates to:
  /// **'Diesel'**
  String get fuelTypeDiesel;

  /// Generic add action
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get actionAdd;

  /// Generic save action
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// Generic cancel action
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// Generic delete action
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// Restore a soft-deleted item
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get actionRestore;

  /// Generic edit action
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// Tooltip for the current default item
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get actionDefault;

  /// Action to mark an item as default
  ///
  /// In en, this message translates to:
  /// **'Set as default'**
  String get actionSetDefault;

  /// Label for fuel type name field
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fuelTypeNameLabel;

  /// Dialog title when adding a fuel type
  ///
  /// In en, this message translates to:
  /// **'Add fuel type'**
  String get fuelTypeAddTitle;

  /// Dialog title when editing a fuel type
  ///
  /// In en, this message translates to:
  /// **'Edit fuel type'**
  String get fuelTypeEditTitle;

  /// Confirmation message before deleting a fuel type
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get fuelTypeDeleteConfirm;

  /// Confirmation when adding a name that matches a soft-deleted fuel type
  ///
  /// In en, this message translates to:
  /// **'This item was marked as deleted. Restore it?'**
  String get fuelTypeRestoreConfirm;

  /// Error when fuel type name is not unique
  ///
  /// In en, this message translates to:
  /// **'An item with this name already exists'**
  String get fuelTypeAlreadyExists;

  /// Validation error when fuel type name is empty
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get fuelTypeNameRequired;

  /// Shown when a settings list has no items
  ///
  /// In en, this message translates to:
  /// **'The list is empty'**
  String get listEmpty;

  /// Shown when a list stream or page load fails
  ///
  /// In en, this message translates to:
  /// **'Could not load the list'**
  String get listLoadError;

  /// Title of the cars settings screen
  ///
  /// In en, this message translates to:
  /// **'Cars'**
  String get carsTitle;

  /// Title when creating a car
  ///
  /// In en, this message translates to:
  /// **'Add car'**
  String get carAddTitle;

  /// Title when editing a car
  ///
  /// In en, this message translates to:
  /// **'Edit car'**
  String get carEditTitle;

  /// Car brand field label
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get carBrandLabel;

  /// Label for default car switch on car form
  ///
  /// In en, this message translates to:
  /// **'Default auto'**
  String get carDefaultLabel;

  /// Car model field label
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get carModelLabel;

  /// Car year field label
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get carYearLabel;

  /// Car photo field label
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get carPhotoLabel;

  /// Button to pick a car photo
  ///
  /// In en, this message translates to:
  /// **'Choose photo'**
  String get carPhotoPick;

  /// Shown when image picker fails
  ///
  /// In en, this message translates to:
  /// **'Could not open the photo picker. Fully restart the app and try again.'**
  String get carPhotoPickError;

  /// Button to remove a car photo
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get carPhotoRemove;

  /// Car color field label
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get carColorLabel;

  /// Validation error when brand is empty
  ///
  /// In en, this message translates to:
  /// **'Brand is required'**
  String get carBrandRequired;

  /// Validation error when year is not a number
  ///
  /// In en, this message translates to:
  /// **'Enter a valid year'**
  String get carYearInvalid;

  /// Confirmation before deleting a car
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this car? All related data will be deleted.'**
  String get carDeleteConfirm;

  /// Shared hint about swipe-to-delete on list screens
  ///
  /// In en, this message translates to:
  /// **'Swipe left to delete a record'**
  String get swipeDeleteTip;

  /// Shared hint about double-tap to edit history records
  ///
  /// In en, this message translates to:
  /// **'Double-tap a record to edit it'**
  String get doubleTapEditTip;

  /// Dismisses a one-time UI tip permanently
  ///
  /// In en, this message translates to:
  /// **'Don\'t show again'**
  String get tipDontShowAgain;

  /// Placeholder brand name for the seeded car
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get seedCarBrand;

  /// Placeholder model name for the seeded car
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get seedCarModel;

  /// Shown when the car limit is reached
  ///
  /// In en, this message translates to:
  /// **'You can add up to {max} cars'**
  String carLimitReached(int max);

  /// Shown when trying to delete the last remaining car
  ///
  /// In en, this message translates to:
  /// **'You need at least one car'**
  String get carDeleteLastBlocked;

  /// Label above car checkboxes on fuel type form
  ///
  /// In en, this message translates to:
  /// **'Available for cars'**
  String get fuelTypeCarsLabel;

  /// Validation when no cars are selected for a car-scoped catalog item
  ///
  /// In en, this message translates to:
  /// **'Select at least one car'**
  String get catalogCarsRequired;

  /// Title of the parts settings screen
  ///
  /// In en, this message translates to:
  /// **'Parts'**
  String get partsTitle;

  /// Label for part name field
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get partNameLabel;

  /// Dialog title when adding a part
  ///
  /// In en, this message translates to:
  /// **'Add part'**
  String get partAddTitle;

  /// Dialog title when editing a part
  ///
  /// In en, this message translates to:
  /// **'Edit part'**
  String get partEditTitle;

  /// Confirmation before deleting a part
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get partDeleteConfirm;

  /// Confirmation when adding a name that matches a soft-deleted part
  ///
  /// In en, this message translates to:
  /// **'This item was marked as deleted. Restore it?'**
  String get partRestoreConfirm;

  /// Error when part name is not unique
  ///
  /// In en, this message translates to:
  /// **'An item with this name already exists'**
  String get partAlreadyExists;

  /// Validation error when part name is empty
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get partNameRequired;

  /// Title of the service works settings screen
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get servicesTitle;

  /// Label for service work name field
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get serviceNameLabel;

  /// Dialog title when adding a service work
  ///
  /// In en, this message translates to:
  /// **'Add service'**
  String get serviceAddTitle;

  /// Dialog title when editing a service work
  ///
  /// In en, this message translates to:
  /// **'Edit service'**
  String get serviceEditTitle;

  /// Confirmation before deleting a service work
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get serviceDeleteConfirm;

  /// Confirmation when adding a name that matches a soft-deleted service
  ///
  /// In en, this message translates to:
  /// **'This item was marked as deleted. Restore it?'**
  String get serviceRestoreConfirm;

  /// Error when service name is not unique
  ///
  /// In en, this message translates to:
  /// **'An item with this name already exists'**
  String get serviceAlreadyExists;

  /// Validation error when service name is empty
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get serviceNameRequired;

  /// Label for optional service icon picker
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get serviceIconLabel;

  /// Title of the service centers settings screen
  ///
  /// In en, this message translates to:
  /// **'Service centers'**
  String get serviceCentersTitle;

  /// Dialog title when adding a service center
  ///
  /// In en, this message translates to:
  /// **'Add service center'**
  String get serviceCenterAddTitle;

  /// Dialog title when editing a service center
  ///
  /// In en, this message translates to:
  /// **'Edit service center'**
  String get serviceCenterEditTitle;

  /// Confirmation before deleting a service center
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get serviceCenterDeleteConfirm;

  /// Title of the gas station chains settings screen
  ///
  /// In en, this message translates to:
  /// **'Gas station chains'**
  String get gasStationsTitle;

  /// Dialog title when adding a gas station chain
  ///
  /// In en, this message translates to:
  /// **'Add chain'**
  String get gasStationAddTitle;

  /// Dialog title when editing a gas station chain
  ///
  /// In en, this message translates to:
  /// **'Edit chain'**
  String get gasStationEditTitle;

  /// Dialog title when adding a gas station address
  ///
  /// In en, this message translates to:
  /// **'Add address'**
  String get gasStationAddAddressTitle;

  /// Dialog title when editing a gas station address
  ///
  /// In en, this message translates to:
  /// **'Edit address'**
  String get gasStationEditAddressTitle;

  /// Label for a chain location that has no address
  ///
  /// In en, this message translates to:
  /// **'Without address'**
  String get gasStationNoAddress;

  /// Section header for addresses on the gas station detail screen
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get gasStationAddressesSection;

  /// Validation error when gas station address is empty
  ///
  /// In en, this message translates to:
  /// **'Enter an address'**
  String get placeAddressRequired;

  /// Subtitle showing how many addresses a chain has
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No addresses} =1{1 address} other{{count} addresses}}'**
  String gasStationLocationsCount(int count);

  /// Confirmation before deleting a gas station chain or address
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get gasStationDeleteConfirm;

  /// Label for place name field
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get placeNameLabel;

  /// Label for optional place address field
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get placeAddressLabel;

  /// Validation error when place name is empty
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get placeNameRequired;

  /// Error when place name is not unique
  ///
  /// In en, this message translates to:
  /// **'An item with this name already exists'**
  String get placeAlreadyExists;

  /// Confirmation when adding a name that matches a soft-deleted place
  ///
  /// In en, this message translates to:
  /// **'This item was marked as deleted. Restore it?'**
  String get placeRestoreConfirm;

  /// Section title for fuel volume units
  ///
  /// In en, this message translates to:
  /// **'Fuel volume'**
  String get unitsFuelSection;

  /// Section title for distance units
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get unitsDistanceSection;

  /// Fuel volume unit: liters
  ///
  /// In en, this message translates to:
  /// **'Liters'**
  String get unitLiters;

  /// Fuel volume unit: US gallons
  ///
  /// In en, this message translates to:
  /// **'US gallons'**
  String get unitUsGallons;

  /// Fuel volume unit: imperial gallons
  ///
  /// In en, this message translates to:
  /// **'Imperial gallons'**
  String get unitImperialGallons;

  /// Distance unit: kilometers
  ///
  /// In en, this message translates to:
  /// **'Kilometers'**
  String get unitKilometers;

  /// Distance unit: miles
  ///
  /// In en, this message translates to:
  /// **'Miles'**
  String get unitMiles;

  /// Dialog title when adding a fueling
  ///
  /// In en, this message translates to:
  /// **'Add fueling'**
  String get fuelingAddTitle;

  /// Dialog title when editing a fueling
  ///
  /// In en, this message translates to:
  /// **'Edit fueling'**
  String get fuelingEditTitle;

  /// Confirmation when deleting a fueling record
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this fueling?'**
  String get fuelingDeleteConfirm;

  /// Label for fueling date field
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get fuelingDateLabel;

  /// Label for price per volume unit field
  ///
  /// In en, this message translates to:
  /// **'Price per {unit}'**
  String fuelingPriceLabel(String unit);

  /// Label for fuel quantity field
  ///
  /// In en, this message translates to:
  /// **'Quantity ({unit})'**
  String fuelingQuantityLabel(String unit);

  /// Label for total amount field
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get fuelingTotalLabel;

  /// Validation when price is missing or invalid
  ///
  /// In en, this message translates to:
  /// **'Enter price'**
  String get fuelingPriceRequired;

  /// Validation when quantity is missing or invalid
  ///
  /// In en, this message translates to:
  /// **'Enter quantity'**
  String get fuelingQuantityRequired;

  /// Validation when neither quantity nor total is provided
  ///
  /// In en, this message translates to:
  /// **'Enter quantity or total'**
  String get fuelingQuantityOrTotalRequired;

  /// Validation when total amount is missing or invalid
  ///
  /// In en, this message translates to:
  /// **'Enter total amount'**
  String get fuelingTotalRequired;

  /// Optional odometer field label
  ///
  /// In en, this message translates to:
  /// **'Odometer ({unit})'**
  String fuelingOdometerLabel(String unit);

  /// Validation when odometer value is invalid
  ///
  /// In en, this message translates to:
  /// **'Enter a valid odometer reading'**
  String get fuelingOdometerInvalid;

  /// Title when odometer breaks chronological order vs neighbors
  ///
  /// In en, this message translates to:
  /// **'Unusual odometer value'**
  String get fuelingOdometerSequenceTitle;

  /// Title when odometer is lower than an earlier fueling
  ///
  /// In en, this message translates to:
  /// **'Odometer lower than earlier'**
  String get fuelingOdometerLowerTitle;

  /// Warning when odometer is lower than an earlier fueling
  ///
  /// In en, this message translates to:
  /// **'The odometer is lower than an earlier reading ({value} {unit}).'**
  String fuelingOdometerLowerMessage(String value, String unit);

  /// Title when odometer is higher than a later fueling
  ///
  /// In en, this message translates to:
  /// **'Odometer higher than later'**
  String get fuelingOdometerHigherTitle;

  /// Warning when odometer is higher than a later fueling
  ///
  /// In en, this message translates to:
  /// **'The odometer is higher than a later reading ({value} {unit}).'**
  String fuelingOdometerHigherMessage(String value, String unit);

  /// Shared footer asking to confirm saving despite odometer warning
  ///
  /// In en, this message translates to:
  /// **'This may distort fuel economy and other statistics. Save anyway?'**
  String get fuelingOdometerWarningFooter;

  /// Confirm action to continue despite a warning
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get actionContinue;

  /// Subtitle for a fueling list item
  ///
  /// In en, this message translates to:
  /// **'{quantity} {unit} · {price} / {unit}'**
  String fuelingListSubtitle(String quantity, String price, String unit);

  /// Short label for liters
  ///
  /// In en, this message translates to:
  /// **'L'**
  String get unitFuelShortLiter;

  /// Short label for US gallons
  ///
  /// In en, this message translates to:
  /// **'US gal'**
  String get unitFuelShortUsGallon;

  /// Short label for imperial gallons
  ///
  /// In en, this message translates to:
  /// **'Imp gal'**
  String get unitFuelShortImperialGallon;

  /// Short label for kilometers
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get unitDistanceShortKm;

  /// Short label for miles
  ///
  /// In en, this message translates to:
  /// **'mi'**
  String get unitDistanceShortMile;

  /// Label for currency code text field
  ///
  /// In en, this message translates to:
  /// **'Currency code'**
  String get currencyCodeLabel;

  /// Hint example for currency code
  ///
  /// In en, this message translates to:
  /// **'EUR'**
  String get currencyCodeHint;

  /// Help text under currency code field
  ///
  /// In en, this message translates to:
  /// **'Three Latin letters, e.g. USD, EUR, RSD'**
  String get currencyCodeHelp;

  /// Validation when currency code is invalid
  ///
  /// In en, this message translates to:
  /// **'Enter exactly 3 Latin letters'**
  String get currencyCodeInvalid;

  /// App bar title for currencies list editor
  ///
  /// In en, this message translates to:
  /// **'Currencies'**
  String get currenciesEditTitle;

  /// Dialog title when adding a currency code
  ///
  /// In en, this message translates to:
  /// **'Add currency'**
  String get currencyAddTitle;

  /// Dialog title when editing a currency code
  ///
  /// In en, this message translates to:
  /// **'Edit currency'**
  String get currencyEditTitle;

  /// Confirm dialog when deleting a currency from the list
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this currency?'**
  String get currencyDeleteConfirm;

  /// Validation when adding a duplicate currency code
  ///
  /// In en, this message translates to:
  /// **'This currency is already in the list'**
  String get currencyAlreadyExists;

  /// Shown when trying to remove the last currency
  ///
  /// In en, this message translates to:
  /// **'Keep at least one currency'**
  String get currencyCannotDeleteLast;

  /// Label for fuel type field on fueling form
  ///
  /// In en, this message translates to:
  /// **'Fuel type'**
  String get fuelingFuelTypeLabel;

  /// Validation when fuel type is empty on fueling form
  ///
  /// In en, this message translates to:
  /// **'Select or enter a fuel type'**
  String get fuelingFuelTypeRequired;

  /// Optional gas station field on fueling form
  ///
  /// In en, this message translates to:
  /// **'Gas station'**
  String get fuelingGasStationLabel;

  /// Error when gas station ensure fails while saving a fueling
  ///
  /// In en, this message translates to:
  /// **'Could not save the gas station'**
  String get fuelingGasStationEnsureFailed;

  /// Dialog title when adding a maintenance record
  ///
  /// In en, this message translates to:
  /// **'Add maintenance'**
  String get maintenanceAddTitle;

  /// Dialog title when editing a maintenance record
  ///
  /// In en, this message translates to:
  /// **'Edit maintenance'**
  String get maintenanceEditTitle;

  /// Confirmation when deleting a maintenance record
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this maintenance record?'**
  String get maintenanceDeleteConfirm;

  /// Label for maintenance date field
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get maintenanceDateLabel;

  /// Label for service field on maintenance form
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get maintenanceServiceLabel;

  /// Validation when service is empty on maintenance form
  ///
  /// In en, this message translates to:
  /// **'Select or enter a service'**
  String get maintenanceServiceRequired;

  /// Label for optional service cost field on maintenance form
  ///
  /// In en, this message translates to:
  /// **'Service cost'**
  String get maintenanceTotalLabel;

  /// Validation when service cost is non-empty but invalid
  ///
  /// In en, this message translates to:
  /// **'Enter a valid service cost'**
  String get maintenanceTotalInvalid;

  /// Footer asking to confirm saving despite odometer warning on maintenance
  ///
  /// In en, this message translates to:
  /// **'This may distort statistics. Save anyway?'**
  String get maintenanceOdometerWarningFooter;

  /// Section title for parts list on maintenance form
  ///
  /// In en, this message translates to:
  /// **'Parts'**
  String get maintenancePartsSection;

  /// Dialog title when adding a part line on maintenance form
  ///
  /// In en, this message translates to:
  /// **'Add part'**
  String get maintenancePartAddTitle;

  /// Dialog title when editing a part line on maintenance form
  ///
  /// In en, this message translates to:
  /// **'Edit part'**
  String get maintenancePartEditTitle;

  /// Label for part name field on maintenance part dialog
  ///
  /// In en, this message translates to:
  /// **'Part'**
  String get maintenancePartNameLabel;

  /// Validation when part name is empty on maintenance part dialog
  ///
  /// In en, this message translates to:
  /// **'Select or enter a part'**
  String get maintenancePartNameRequired;

  /// Label for optional unit price on maintenance part dialog
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get maintenancePartAmountLabel;

  /// Validation when part price is non-empty but invalid
  ///
  /// In en, this message translates to:
  /// **'Enter a valid price'**
  String get maintenancePartAmountInvalid;

  /// Label for quantity on maintenance part dialog
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get maintenancePartQuantityLabel;

  /// Validation when quantity is empty or invalid
  ///
  /// In en, this message translates to:
  /// **'Enter a valid quantity'**
  String get maintenancePartQuantityInvalid;

  /// Label for unit of measure on maintenance part dialog
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get maintenancePartUnitLabel;

  /// Optional comment for a maintenance part line
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get maintenancePartCommentLabel;

  /// Confirmation when swiping to remove a part line on maintenance form
  ///
  /// In en, this message translates to:
  /// **'Remove this part from the list?'**
  String get maintenancePartDeleteConfirm;

  /// Label before grand total on maintenance form
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get maintenanceGrandTotalLabel;

  /// Title of the part units settings screen
  ///
  /// In en, this message translates to:
  /// **'Part units'**
  String get partUnitsTitle;

  /// Label for part unit name field
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get partUnitNameLabel;

  /// Dialog title when adding a part unit
  ///
  /// In en, this message translates to:
  /// **'Add unit'**
  String get partUnitAddTitle;

  /// Dialog title when editing a part unit
  ///
  /// In en, this message translates to:
  /// **'Edit unit'**
  String get partUnitEditTitle;

  /// Confirmation before deleting a part unit
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get partUnitDeleteConfirm;

  /// Confirmation when adding a name that matches a soft-deleted part unit
  ///
  /// In en, this message translates to:
  /// **'This item was marked as deleted. Restore it?'**
  String get partUnitRestoreConfirm;

  /// Error when part unit name is not unique
  ///
  /// In en, this message translates to:
  /// **'An item with this name already exists'**
  String get partUnitAlreadyExists;

  /// Validation error when part unit name is empty
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get partUnitNameRequired;

  /// Seed name for liters part unit
  ///
  /// In en, this message translates to:
  /// **'Liters'**
  String get partUnitLiters;

  /// Seed name for pieces part unit
  ///
  /// In en, this message translates to:
  /// **'Pieces'**
  String get partUnitPieces;

  /// Seed name for packages part unit
  ///
  /// In en, this message translates to:
  /// **'Packages'**
  String get partUnitPackages;

  /// Statistics chart grouping: one bar per month
  ///
  /// In en, this message translates to:
  /// **'By months'**
  String get statsGroupByMonths;

  /// Statistics chart grouping: one bar per year
  ///
  /// In en, this message translates to:
  /// **'By years'**
  String get statsGroupByYears;

  /// Label for year period selector on statistics
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get statsPeriodYear;

  /// Chart legend label for fuel expenses
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get statsLegendFuel;

  /// Chart legend label for maintenance expenses
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get statsLegendMaintenance;

  /// Label for total expenses in the selected period
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get statsTotal;

  /// Section title for fuel expense breakdown
  ///
  /// In en, this message translates to:
  /// **'Fuel by type'**
  String get statsFuelDetails;

  /// Section title for maintenance expense breakdown
  ///
  /// In en, this message translates to:
  /// **'Maintenance by service'**
  String get statsMaintenanceDetails;

  /// Fallback name when fuel type or service is missing
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get statsUnknownCategory;

  /// Empty state when statistics have no data for the period
  ///
  /// In en, this message translates to:
  /// **'No expenses for this period'**
  String get statsEmpty;

  /// Label above details for the tapped chart bar
  ///
  /// In en, this message translates to:
  /// **'Selected period'**
  String get statsSelectedPeriod;

  /// Title of the reminders settings screen
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get remindersTitle;

  /// Title when creating a reminder
  ///
  /// In en, this message translates to:
  /// **'Add reminder'**
  String get reminderAddTitle;

  /// Title when editing a reminder
  ///
  /// In en, this message translates to:
  /// **'Edit reminder'**
  String get reminderEditTitle;

  /// Label for reminder title field
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get reminderTitleLabel;

  /// Validation when reminder title is empty
  ///
  /// In en, this message translates to:
  /// **'Enter a title'**
  String get reminderTitleRequired;

  /// Label for car selector on reminder form
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get reminderCarLabel;

  /// Validation when no car is selected for a reminder
  ///
  /// In en, this message translates to:
  /// **'Select a car'**
  String get reminderCarRequired;

  /// Toggle to enable date-based reminder
  ///
  /// In en, this message translates to:
  /// **'By date'**
  String get reminderByDate;

  /// Toggle to enable odometer-based reminder
  ///
  /// In en, this message translates to:
  /// **'By odometer'**
  String get reminderByOdometer;

  /// Label for reminder due date field
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get reminderDueDateLabel;

  /// Placeholder when reminder due date is not set
  ///
  /// In en, this message translates to:
  /// **'Select a date'**
  String get reminderDateHint;

  /// Validation when date trigger is enabled but empty
  ///
  /// In en, this message translates to:
  /// **'Select a due date'**
  String get reminderDateRequired;

  /// Validation when odometer trigger is enabled but empty
  ///
  /// In en, this message translates to:
  /// **'Enter a target odometer reading'**
  String get reminderOdometerRequired;

  /// Validation when reminder has neither date nor odometer
  ///
  /// In en, this message translates to:
  /// **'Set a date, odometer, or both'**
  String get reminderTriggerRequired;

  /// Shown when maintenance save fails while syncing its reminder
  ///
  /// In en, this message translates to:
  /// **'Could not sync the linked reminder'**
  String get reminderSyncFailed;

  /// Label for days-before reminder window
  ///
  /// In en, this message translates to:
  /// **'Remind before (days)'**
  String get reminderRemindBeforeDaysLabel;

  /// Label for distance-before reminder window
  ///
  /// In en, this message translates to:
  /// **'Remind before ({unit})'**
  String reminderRemindBeforeDistanceLabel(String unit);

  /// Validation when remind-before value is invalid
  ///
  /// In en, this message translates to:
  /// **'Enter a valid non-negative value'**
  String get reminderRemindBeforeInvalid;

  /// Subtitle fragment for remind-before days
  ///
  /// In en, this message translates to:
  /// **'in {days} days'**
  String reminderRemindBeforeDays(int days);

  /// Subtitle fragment for remind-before distance
  ///
  /// In en, this message translates to:
  /// **'before {distance}'**
  String reminderRemindBeforeDistance(String distance);

  /// Toggle / label for marking a reminder as done
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get reminderCompleted;

  /// Confirmation before deleting a reminder
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this reminder?'**
  String get reminderDeleteConfirm;

  /// Button to attach a reminder while creating/editing maintenance
  ///
  /// In en, this message translates to:
  /// **'Add reminder'**
  String get maintenanceAddReminder;

  /// Title/button when a reminder is already attached to maintenance
  ///
  /// In en, this message translates to:
  /// **'Edit reminder'**
  String get maintenanceEditReminder;

  /// Settings list item for export/import backup
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get settingsBackup;

  /// Explanation on the backup settings screen
  ///
  /// In en, this message translates to:
  /// **'Export all settings and events to a JSON file, share the backup with another app (for example Google Drive), or import a previously exported backup. Exact duplicates are skipped on import.'**
  String get backupDescription;

  /// Button to export data to a JSON file
  ///
  /// In en, this message translates to:
  /// **'Export to JSON'**
  String get backupExport;

  /// Button to share backup JSON via the system share sheet
  ///
  /// In en, this message translates to:
  /// **'Share backup'**
  String get backupShare;

  /// Button to import data from a JSON file
  ///
  /// In en, this message translates to:
  /// **'Import from JSON'**
  String get backupImport;

  /// SnackBar after successful export
  ///
  /// In en, this message translates to:
  /// **'Backup exported'**
  String get backupExportSuccess;

  /// SnackBar after the share sheet completed successfully
  ///
  /// In en, this message translates to:
  /// **'Backup shared'**
  String get backupShareSuccess;

  /// SnackBar after failed export
  ///
  /// In en, this message translates to:
  /// **'Could not export backup'**
  String get backupExportFailed;

  /// SnackBar after successful import with counts
  ///
  /// In en, this message translates to:
  /// **'Import finished: {added} added, {skipped} skipped'**
  String backupImportSuccess(int added, int skipped);

  /// SnackBar when backup import fails for an unknown/IO reason
  ///
  /// In en, this message translates to:
  /// **'Could not import backup'**
  String get backupImportFailed;

  /// SnackBar when DB import succeeded but SharedPreferences apply failed
  ///
  /// In en, this message translates to:
  /// **'Data imported, but preferences could not be applied'**
  String get backupImportPrefsFailed;

  /// SnackBar when the selected backup file has no content
  ///
  /// In en, this message translates to:
  /// **'Backup file is empty'**
  String get backupImportEmpty;

  /// SnackBar when the backup file cannot be parsed as a JSON object
  ///
  /// In en, this message translates to:
  /// **'Backup file is not valid JSON'**
  String get backupImportInvalid;

  /// SnackBar when backup JSON version is missing or too new
  ///
  /// In en, this message translates to:
  /// **'This backup version is not supported'**
  String get backupImportUnsupportedVersion;

  /// Settings list item for privacy policy
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get settingsPrivacy;

  /// Settings list item for app language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// Language option that follows the device locale
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// SnackBar when url_launcher fails for privacy URL
  ///
  /// In en, this message translates to:
  /// **'Could not open the link'**
  String get privacyOpenFailed;

  /// SnackBar when fueling/maintenance save or delete throws unexpectedly
  ///
  /// In en, this message translates to:
  /// **'Could not complete the action. Please try again.'**
  String get formActionFailed;

  /// Bootstrap failure message shown instead of raw exceptions
  ///
  /// In en, this message translates to:
  /// **'Could not start the app. Please reinstall or contact support.'**
  String get appStartFailed;

  /// SnackBar when car photo exceeds the size limit
  ///
  /// In en, this message translates to:
  /// **'Photo is too large. Choose a smaller image.'**
  String get photoTooLarge;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'hy', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'hy':
      return AppLocalizationsHy();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
