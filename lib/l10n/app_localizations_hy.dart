// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Armenian (`hy`).
class AppLocalizationsHy extends AppLocalizations {
  AppLocalizationsHy([String locale = 'hy']) : super(locale);

  @override
  String get appTitle => 'Ավտոպատմություն';

  @override
  String get navData => 'Տվյալներ';

  @override
  String get navStatistics => 'Վիճակագրություն';

  @override
  String get navSettings => 'Կարգավորումներ';

  @override
  String get tabAll => 'Բոլորը';

  @override
  String get tabFuelings => 'Լիցքավորումներ';

  @override
  String get tabMaintenance => 'Սպասարկում';

  @override
  String get settingsCars => 'Ավտոմեքենաներ';

  @override
  String get settingsFuel => 'Վառելիք';

  @override
  String get settingsParts => 'Պահեստամասեր';

  @override
  String get settingsServices => 'Ծառայություններ';

  @override
  String get settingsServiceCenters => 'Սպասարկման կենտրոններ';

  @override
  String get settingsGasStations => 'Գազալցակայանների ցանցեր';

  @override
  String get settingsReminders => 'Հիշեցումներ';

  @override
  String get settingsUnits => 'Չափման միավորներ';

  @override
  String get settingsPartUnits => 'Պահեստամասերի միավորներ';

  @override
  String get settingsCurrency => 'Արժույթ';

  @override
  String get settingsSectionVehicle => 'Ավտոմեքենա';

  @override
  String get settingsSectionFuel => 'Վառելիք';

  @override
  String get settingsSectionService => 'Սպասարկում';

  @override
  String get settingsSectionSystem => 'Համակարգ';

  @override
  String get fuelTypesTitle => 'Վառելիքի տեսակներ';

  @override
  String get fuelTypePetrol95 => 'Բենզին 95';

  @override
  String get fuelTypePetrol100 => 'Բենզին 100';

  @override
  String get fuelTypeDiesel => 'Դիզել';

  @override
  String get actionAdd => 'Ավելացնել';

  @override
  String get actionSave => 'Պահել';

  @override
  String get actionCancel => 'Չեղարկել';

  @override
  String get actionDelete => 'Ջնջել';

  @override
  String get actionRestore => 'Վերականգնել';

  @override
  String get actionEdit => 'Խմբագրել';

  @override
  String get actionDefault => 'Լռելյայն';

  @override
  String get actionSetDefault => 'Դարձնել լռելյայն';

  @override
  String get fuelTypeNameLabel => 'Անուն';

  @override
  String get fuelTypeAddTitle => 'Ավելացնել վառելիքի տեսակ';

  @override
  String get fuelTypeEditTitle => 'Խմբագրել վառելիքի տեսակը';

  @override
  String get fuelTypeDeleteConfirm =>
      'Վստա՞հ եք, որ ցանկանում եք ջնջել այս տարրը։';

  @override
  String get fuelTypeRestoreConfirm =>
      'Այս տարրը նշված էր որպես ջնջված։ Վերականգնե՞լ։';

  @override
  String get fuelTypeAlreadyExists => 'Այս անունով տարր արդեն գոյություն ունի';

  @override
  String get fuelTypeNameRequired => 'Մուտքագրեք անուն';

  @override
  String get listEmpty => 'Ցանկը դատարկ է';

  @override
  String get listLoadError => 'Չհաջողվեց բեռնել ցանկը';

  @override
  String get carsTitle => 'Ավտոմեքենաներ';

  @override
  String get carAddTitle => 'Ավելացնել ավտոմեքենա';

  @override
  String get carEditTitle => 'Խմբագրել ավտոմեքենան';

  @override
  String get carBrandLabel => 'Մակնիշ';

  @override
  String get carDefaultLabel => 'Լռելյայն ավտոմեքենա';

  @override
  String get carModelLabel => 'Մոդել';

  @override
  String get carYearLabel => 'Տարի';

  @override
  String get carPhotoLabel => 'Լուսանկար';

  @override
  String get carPhotoPick => 'Ընտրել լուսանկար';

  @override
  String get carPhotoPickError =>
      'Չհաջողվեց բացել լուսանկարների ընտրիչը։ Ամբողջությամբ վերագործարկեք հավելվածը և փորձեք կրկին։';

  @override
  String get carPhotoRemove => 'Հեռացնել լուսանկարը';

  @override
  String get carColorLabel => 'Գույն';

  @override
  String get carBrandRequired => 'Մակնիշը պարտադիր է';

  @override
  String get carYearInvalid => 'Մուտքագրեք վավեր տարի';

  @override
  String get carDeleteConfirm =>
      'Վստա՞հ եք, որ ցանկանում եք ջնջել այս ավտոմեքենան։ Կապված բոլոր տվյալները կջնջվեն։';

  @override
  String get swipeDeleteTip => 'Ձախ սահեցրեք՝ գրառումը ջնջելու համար';

  @override
  String get doubleTapEditTip => 'Երկու անգամ հպեք գրառմանը՝ խմբագրելու համար';

  @override
  String get tipDontShowAgain => 'Այլևս չցուցադրել';

  @override
  String get seedCarBrand => 'Մակնիշ';

  @override
  String get seedCarModel => 'Մոդել';

  @override
  String carLimitReached(int max) {
    return 'Կարող եք ավելացնել մինչև $max ավտոմեքենա';
  }

  @override
  String get carDeleteLastBlocked => 'Պետք է ունենալ առնվազն մեկ ավտոմեքենա';

  @override
  String get fuelTypeCarsLabel => 'Հասանելի է ավտոմեքենաների համար';

  @override
  String get catalogCarsRequired => 'Ընտրեք առնվազն մեկ ավտոմեքենա';

  @override
  String get partsTitle => 'Պահեստամասեր';

  @override
  String get partNameLabel => 'Անուն';

  @override
  String get partAddTitle => 'Ավելացնել պահեստամաս';

  @override
  String get partEditTitle => 'Խմբագրել պահեստամասը';

  @override
  String get partDeleteConfirm => 'Վստա՞հ եք, որ ցանկանում եք ջնջել այս տարրը։';

  @override
  String get partRestoreConfirm =>
      'Այս տարրը նշված էր որպես ջնջված։ Վերականգնե՞լ։';

  @override
  String get partAlreadyExists => 'Այս անունով տարր արդեն գոյություն ունի';

  @override
  String get partNameRequired => 'Մուտքագրեք անուն';

  @override
  String get servicesTitle => 'Ծառայություններ';

  @override
  String get serviceNameLabel => 'Անուն';

  @override
  String get serviceAddTitle => 'Ավելացնել ծառայություն';

  @override
  String get serviceEditTitle => 'Խմբագրել ծառայությունը';

  @override
  String get serviceDeleteConfirm =>
      'Վստա՞հ եք, որ ցանկանում եք ջնջել այս տարրը։';

  @override
  String get serviceRestoreConfirm =>
      'Այս տարրը նշված էր որպես ջնջված։ Վերականգնե՞լ։';

  @override
  String get serviceAlreadyExists => 'Այս անունով տարր արդեն գոյություն ունի';

  @override
  String get serviceNameRequired => 'Մուտքագրեք անուն';

  @override
  String get serviceIconLabel => 'Պատկերակ';

  @override
  String get serviceCentersTitle => 'Սպասարկման կենտրոններ';

  @override
  String get serviceCenterAddTitle => 'Ավելացնել սպասարկման կենտրոն';

  @override
  String get serviceCenterEditTitle => 'Խմբագրել սպասարկման կենտրոնը';

  @override
  String get serviceCenterDeleteConfirm =>
      'Վստա՞հ եք, որ ցանկանում եք ջնջել այս տարրը։';

  @override
  String get gasStationsTitle => 'Գազալցակայանների ցանցեր';

  @override
  String get gasStationAddTitle => 'Ավելացնել ցանց';

  @override
  String get gasStationEditTitle => 'Խմբագրել ցանցը';

  @override
  String get gasStationAddAddressTitle => 'Ավելացնել հասցե';

  @override
  String get gasStationEditAddressTitle => 'Խմբագրել հասցեն';

  @override
  String get gasStationNoAddress => 'Առանց հասցեի';

  @override
  String get gasStationAddressesSection => 'Հասցեներ';

  @override
  String get placeAddressRequired => 'Մուտքագրեք հասցե';

  @override
  String gasStationLocationsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count հասցե',
      one: '1 հասցե',
      zero: 'Հասցեներ չկան',
    );
    return '$_temp0';
  }

  @override
  String get gasStationDeleteConfirm =>
      'Վստա՞հ եք, որ ցանկանում եք ջնջել այս տարրը։';

  @override
  String get placeNameLabel => 'Անուն';

  @override
  String get placeAddressLabel => 'Հասցե';

  @override
  String get placeNameRequired => 'Մուտքագրեք անուն';

  @override
  String get placeAlreadyExists => 'Այս անունով տարր արդեն գոյություն ունի';

  @override
  String get placeRestoreConfirm =>
      'Այս տարրը նշված էր որպես ջնջված։ Վերականգնե՞լ։';

  @override
  String get unitsFuelSection => 'Վառելիքի ծավալ';

  @override
  String get unitsDistanceSection => 'Հեռավորություն';

  @override
  String get unitLiters => 'Լիտր';

  @override
  String get unitUsGallons => 'ԱՄՆ գալոն';

  @override
  String get unitImperialGallons => 'Իմպերիալ գալոն';

  @override
  String get unitKilometers => 'Կիլոմետր';

  @override
  String get unitMiles => 'Մղոն';

  @override
  String get fuelingAddTitle => 'Ավելացնել լիցքավորում';

  @override
  String get fuelingEditTitle => 'Խմբագրել լիցքավորումը';

  @override
  String get fuelingDeleteConfirm =>
      'Վստա՞հ եք, որ ցանկանում եք ջնջել այս լիցքավորումը։';

  @override
  String get fuelingDateLabel => 'Ամսաթիվ';

  @override
  String fuelingPriceLabel(String unit) {
    return 'Գինը $unit-ի համար';
  }

  @override
  String fuelingQuantityLabel(String unit) {
    return 'Քանակ ($unit)';
  }

  @override
  String get fuelingTotalLabel => 'Ընդամենը';

  @override
  String get fuelingPriceRequired => 'Մուտքագրեք գինը';

  @override
  String get fuelingQuantityRequired => 'Մուտքագրեք քանակը';

  @override
  String get fuelingQuantityOrTotalRequired => 'Մուտքագրեք քանակը կամ գումարը';

  @override
  String get fuelingTotalRequired => 'Մուտքագրեք ընդհանուր գումարը';

  @override
  String fuelingOdometerLabel(String unit) {
    return 'Օդոմետր ($unit)';
  }

  @override
  String get fuelingOdometerInvalid => 'Մուտքագրեք վավեր օդոմետրի ցուցում';

  @override
  String get fuelingOdometerSequenceTitle => 'Անսովոր օդոմետրի արժեք';

  @override
  String get fuelingOdometerLowerTitle => 'Օդոմետրը ավելի ցածր է, քան նախորդը';

  @override
  String fuelingOdometerLowerMessage(String value, String unit) {
    return 'Օդոմետրը ավելի ցածր է, քան նախորդ ցուցումը ($value $unit)։';
  }

  @override
  String get fuelingOdometerHigherTitle =>
      'Օդոմետրը ավելի բարձր է, քան հաջորդը';

  @override
  String fuelingOdometerHigherMessage(String value, String unit) {
    return 'Օդոմետրը ավելի բարձր է, քան հաջորդ ցուցումը ($value $unit)։';
  }

  @override
  String get fuelingOdometerWarningFooter =>
      'Սա կարող է խեղաթյուրել վառելիքի ծախսը և այլ վիճակագրությունը։ Միևնույն է պահե՞լ։';

  @override
  String get actionContinue => 'Շարունակել';

  @override
  String fuelingListSubtitle(String quantity, String price, String unit) {
    return '$quantity $unit · $price / $unit';
  }

  @override
  String get unitFuelShortLiter => 'լ';

  @override
  String get unitFuelShortUsGallon => 'ԱՄՆ գալ';

  @override
  String get unitFuelShortImperialGallon => 'իմպ գալ';

  @override
  String get unitDistanceShortKm => 'կմ';

  @override
  String get unitDistanceShortMile => 'մղ';

  @override
  String get currencyCodeLabel => 'Արժույթի կոդ';

  @override
  String get currencyCodeHint => 'EUR';

  @override
  String get currencyCodeHelp => 'Երեք լատինական տառ, օր. USD, EUR, RSD';

  @override
  String get currencyCodeInvalid => 'Մուտքագրեք ճիշտ 3 լատինական տառ';

  @override
  String get currenciesEditTitle => 'Արժույթներ';

  @override
  String get currencyAddTitle => 'Ավելացնել արժույթ';

  @override
  String get currencyEditTitle => 'Խմբագրել արժույթը';

  @override
  String get currencyDeleteConfirm =>
      'Վստա՞հ եք, որ ցանկանում եք ջնջել այս արժույթը։';

  @override
  String get currencyAlreadyExists => 'Այս արժույթն արդեն ցանկում է';

  @override
  String get currencyCannotDeleteLast => 'Թողեք առնվազն մեկ արժույթ';

  @override
  String get fuelingFuelTypeLabel => 'Վառելիքի տեսակ';

  @override
  String get fuelingFuelTypeRequired => 'Ընտրեք կամ մուտքագրեք վառելիքի տեսակ';

  @override
  String get fuelingGasStationLabel => 'Գազալցակայան';

  @override
  String get fuelingGasStationEnsureFailed => 'Չհաջողվեց պահել գազալցակայանը';

  @override
  String get maintenanceAddTitle => 'Ավելացնել սպասարկում';

  @override
  String get maintenanceEditTitle => 'Խմբագրել սպասարկումը';

  @override
  String get maintenanceDeleteConfirm =>
      'Վստա՞հ եք, որ ցանկանում եք ջնջել այս սպասարկման գրառումը։';

  @override
  String get maintenanceDateLabel => 'Ամսաթիվ';

  @override
  String get maintenanceServiceLabel => 'Ծառայություն';

  @override
  String get maintenanceServiceRequired => 'Ընտրեք կամ մուտքագրեք ծառայություն';

  @override
  String get maintenanceTotalLabel => 'Ծառայության արժեք';

  @override
  String get maintenanceTotalInvalid => 'Մուտքագրեք վավեր ծառայության արժեք';

  @override
  String get maintenanceOdometerWarningFooter =>
      'Սա կարող է խեղաթյուրել վիճակագրությունը։ Միևնույն է պահե՞լ։';

  @override
  String get maintenancePartsSection => 'Պահեստամասեր';

  @override
  String get maintenancePartAddTitle => 'Ավելացնել պահեստամաս';

  @override
  String get maintenancePartEditTitle => 'Խմբագրել պահեստամասը';

  @override
  String get maintenancePartNameLabel => 'Պահեստամաս';

  @override
  String get maintenancePartNameRequired => 'Ընտրեք կամ մուտքագրեք պահեստամաս';

  @override
  String get maintenancePartAmountLabel => 'Գին';

  @override
  String get maintenancePartAmountInvalid => 'Մուտքագրեք վավեր գին';

  @override
  String get maintenancePartQuantityLabel => 'Քանակ';

  @override
  String get maintenancePartQuantityInvalid => 'Մուտքագրեք վավեր քանակ';

  @override
  String get maintenancePartUnitLabel => 'Միավոր';

  @override
  String get maintenancePartCommentLabel => 'Մեկնաբանություն';

  @override
  String get maintenancePartDeleteConfirm =>
      'Հեռացնե՞լ այս պահեստամասը ցանկից։';

  @override
  String get maintenanceGrandTotalLabel => 'Գումար';

  @override
  String get partUnitsTitle => 'Պահեստամասերի միավորներ';

  @override
  String get partUnitNameLabel => 'Անուն';

  @override
  String get partUnitAddTitle => 'Ավելացնել միավոր';

  @override
  String get partUnitEditTitle => 'Խմբագրել միավորը';

  @override
  String get partUnitDeleteConfirm =>
      'Վստա՞հ եք, որ ցանկանում եք ջնջել այս տարրը։';

  @override
  String get partUnitRestoreConfirm =>
      'Այս տարրը նշված էր որպես ջնջված։ Վերականգնե՞լ։';

  @override
  String get partUnitAlreadyExists => 'Այս անունով տարր արդեն գոյություն ունի';

  @override
  String get partUnitNameRequired => 'Մուտքագրեք անուն';

  @override
  String get partUnitLiters => 'Լիտր';

  @override
  String get partUnitPieces => 'Հատ';

  @override
  String get partUnitPackages => 'Փաթեթ';

  @override
  String get statsGroupByMonths => 'Ըստ ամիսների';

  @override
  String get statsGroupByYears => 'Ըստ տարիների';

  @override
  String get statsPeriodYear => 'Տարի';

  @override
  String get statsLegendFuel => 'Վառելիք';

  @override
  String get statsLegendMaintenance => 'Սպասարկում';

  @override
  String get statsTotal => 'Ընդամենը';

  @override
  String get statsFuelDetails => 'Վառելիք ըստ տեսակի';

  @override
  String get statsMaintenanceDetails => 'Սպասարկում ըստ ծառայության';

  @override
  String get statsUnknownCategory => 'Անհայտ';

  @override
  String get statsEmpty => 'Այս ժամանակաշրջանի համար ծախսեր չկան';

  @override
  String get statsSelectedPeriod => 'Ընտրված ժամանակաշրջան';

  @override
  String get remindersTitle => 'Հիշեցումներ';

  @override
  String get reminderAddTitle => 'Ավելացնել հիշեցում';

  @override
  String get reminderEditTitle => 'Խմբագրել հիշեցումը';

  @override
  String get reminderTitleLabel => 'Վերնագիր';

  @override
  String get reminderTitleRequired => 'Մուտքագրեք վերնագիր';

  @override
  String get reminderCarLabel => 'Ավտոմեքենա';

  @override
  String get reminderCarRequired => 'Ընտրեք ավտոմեքենա';

  @override
  String get reminderByDate => 'Ըստ ամսաթվի';

  @override
  String get reminderByOdometer => 'Ըստ օդոմետրի';

  @override
  String get reminderOdometerModeAfter => 'Հետո';

  @override
  String get reminderOdometerModeAbsolute => 'Ճշգրիտ ցուցում';

  @override
  String reminderOdometerAfterLabel(String unit) {
    return 'Հետո ($unit)';
  }

  @override
  String reminderOdometerDuePreview(String value, String unit) {
    return 'Ժամկետ՝ $value $unit';
  }

  @override
  String reminderOdometerCurrentReading(String value, String unit) {
    return 'Ներկա՝ $value $unit';
  }

  @override
  String get reminderOdometerBaselineMissing =>
      'Այս մեքենայի համար ընթացիկ օդոմետրի ցուցում չկա';

  @override
  String get reminderDueDateLabel => 'Վերջնաժամկետ';

  @override
  String get reminderDateHint => 'Ընտրեք ամսաթիվ';

  @override
  String get reminderDateRequired => 'Ընտրեք վերջնաժամկետ';

  @override
  String get reminderOdometerRequired =>
      'Մուտքագրեք նպատակային օդոմետրի ցուցում';

  @override
  String get reminderTriggerRequired =>
      'Սահմանեք ամսաթիվ, օդոմետր կամ երկուսն էլ';

  @override
  String get reminderSyncFailed => 'Չհաջողվեց համաժամեցնել կապված հիշեցումը';

  @override
  String get reminderRemindBeforeDaysLabel => 'Հիշեցնել նախապես (օր)';

  @override
  String reminderRemindBeforeDistanceLabel(String unit) {
    return 'Հիշեցնել նախապես ($unit)';
  }

  @override
  String get reminderRemindBeforeInvalid =>
      'Մուտքագրեք վավեր ոչ բացասական արժեք';

  @override
  String reminderRemindBeforeDays(int days) {
    return '$days օրից';
  }

  @override
  String reminderRemindBeforeDistance(String distance) {
    return '$distance-ից առաջ';
  }

  @override
  String get reminderCompleted => 'Ավարտված';

  @override
  String get reminderDeleteConfirm =>
      'Վստա՞հ եք, որ ցանկանում եք ջնջել այս հիշեցումը։';

  @override
  String get maintenanceAddReminder => 'Ավելացնել հիշեցում';

  @override
  String get maintenanceEditReminder => 'Խմբագրել հիշեցումը';

  @override
  String get settingsBackup => 'Պահուստային պատճեն';

  @override
  String get backupDescription =>
      'Արտահանեք բոլոր կարգավորումներն ու իրադարձությունները JSON ֆայլ, կիսվեք պատճենով այլ հավելվածի հետ (օրինակ Google Drive) կամ ներմուծեք նախկինում արտահանված պատճենը։ Ճշգրիտ կրկնօրինակները ներմուծման ժամանակ բաց են թողնվում։';

  @override
  String get backupExport => 'Արտահանել JSON';

  @override
  String get backupShare => 'Կիսվել պատճենով';

  @override
  String get backupImport => 'Ներմուծել JSON-ից';

  @override
  String get backupExportSuccess => 'Պահուստային պատճենն արտահանված է';

  @override
  String get backupShareSuccess => 'Պատճենը կիսված է';

  @override
  String get backupExportFailed => 'Չհաջողվեց արտահանել պահուստային պատճենը';

  @override
  String backupImportSuccess(int added, int skipped) {
    return 'Ներմուծումն ավարտված է. $added ավելացված, $skipped բաց թողնված';
  }

  @override
  String get backupImportFailed => 'Չհաջողվեց ներմուծել պահուստային պատճենը';

  @override
  String get backupImportPrefsFailed =>
      'Տվյալները ներմուծվեցին, բայց կարգավորումները չհաջողվեց կիրառել';

  @override
  String get backupImportEmpty => 'Պահուստային ֆայլը դատարկ է';

  @override
  String get backupImportInvalid => 'Պահուստային ֆայլը վավեր JSON չէ';

  @override
  String get backupImportUnsupportedVersion =>
      'Պահուստային պատճենի այս տարբերակը չի աջակցվում';

  @override
  String get settingsPrivacy => 'Գաղտնիության քաղաքականություն';

  @override
  String get settingsLanguage => 'Լեզու';

  @override
  String get languageSystem => 'Ինչպես համակարգում';

  @override
  String get privacyOpenFailed => 'Չհաջողվեց բացել հղումը';

  @override
  String get formActionFailed =>
      'Չհաջողվեց կատարել գործողությունը։ Փորձեք կրկին։';

  @override
  String get appStartFailed =>
      'Չհաջողվեց գործարկել հավելվածը։ Վերատեղադրեք կամ կապվեք աջակցման հետ։';

  @override
  String get photoTooLarge =>
      'Լուսանկարը չափազանց մեծ է։ Ընտրեք ավելի փոքր պատկեր։';
}
