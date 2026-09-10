// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'История авто';

  @override
  String get navData => 'Данные';

  @override
  String get navStatistics => 'Статистика';

  @override
  String get navSettings => 'Настройки';

  @override
  String get tabAll => 'Все';

  @override
  String get tabFuelings => 'Заправки';

  @override
  String get tabMaintenance => 'Обслуживание';

  @override
  String get settingsCars => 'Авто';

  @override
  String get settingsFuel => 'Топливо';

  @override
  String get settingsParts => 'Запчасти';

  @override
  String get settingsServices => 'Сервисы';

  @override
  String get settingsServiceCenters => 'Сервисные центры';

  @override
  String get settingsGasStations => 'Сети АЗС';

  @override
  String get settingsReminders => 'Напоминания';

  @override
  String get settingsUnits => 'Единицы измерения';

  @override
  String get settingsPartUnits => 'Единицы измерения запчастей';

  @override
  String get settingsCurrency => 'Валюта';

  @override
  String get settingsSectionVehicle => 'Автомобиль';

  @override
  String get settingsSectionFuel => 'Топливо';

  @override
  String get settingsSectionService => 'Обслуживание';

  @override
  String get settingsSectionSystem => 'Система';

  @override
  String get fuelTypesTitle => 'Типы топлива';

  @override
  String get fuelTypePetrol95 => 'Бензин 95';

  @override
  String get fuelTypePetrol100 => 'Бензин 100';

  @override
  String get fuelTypeDiesel => 'Дизель';

  @override
  String get actionAdd => 'Добавить';

  @override
  String get actionSave => 'Сохранить';

  @override
  String get actionCancel => 'Отмена';

  @override
  String get actionDelete => 'Удалить';

  @override
  String get actionRestore => 'Восстановить';

  @override
  String get actionEdit => 'Редактировать';

  @override
  String get actionDefault => 'По умолчанию';

  @override
  String get actionSetDefault => 'Сделать по умолчанию';

  @override
  String get fuelTypeNameLabel => 'Название';

  @override
  String get fuelTypeAddTitle => 'Добавить тип топлива';

  @override
  String get fuelTypeEditTitle => 'Редактировать тип топлива';

  @override
  String get fuelTypeDeleteConfirm => 'Вы точно хотите удалить?';

  @override
  String get fuelTypeRestoreConfirm =>
      'Это было помечено как удалённое. Восстановить?';

  @override
  String get fuelTypeAlreadyExists => 'Элемент с таким именем уже существует';

  @override
  String get fuelTypeNameRequired => 'Введите название';

  @override
  String get listEmpty => 'Список пустой';

  @override
  String get listLoadError => 'Не удалось загрузить список';

  @override
  String get carsTitle => 'Автомобили';

  @override
  String get carAddTitle => 'Добавить авто';

  @override
  String get carEditTitle => 'Редактировать авто';

  @override
  String get carBrandLabel => 'Марка';

  @override
  String get carDefaultLabel => 'Авто по умолчанию';

  @override
  String get carModelLabel => 'Модель';

  @override
  String get carYearLabel => 'Год';

  @override
  String get carPhotoLabel => 'Фото';

  @override
  String get carPhotoPick => 'Выбрать фото';

  @override
  String get carPhotoPickError =>
      'Не удалось открыть выбор фото. Полностью перезапустите приложение и попробуйте снова.';

  @override
  String get carPhotoRemove => 'Удалить фото';

  @override
  String get carColorLabel => 'Цвет';

  @override
  String get carBrandRequired => 'Марка обязательна';

  @override
  String get carYearInvalid => 'Введите корректный год';

  @override
  String get carDeleteConfirm =>
      'Вы точно хотите удалить авто? Все данные о нем будут удалены.';

  @override
  String get swipeDeleteTip => 'Свайп влево удаляет запись';

  @override
  String get doubleTapEditTip => 'Двойной тап позволяет редактировать запись';

  @override
  String get tipDontShowAgain => 'Не показывать больше';

  @override
  String get seedCarBrand => 'Марка';

  @override
  String get seedCarModel => 'Модель';

  @override
  String carLimitReached(int max) {
    return 'Можно добавить не больше $max автомобилей';
  }

  @override
  String get carDeleteLastBlocked => 'Нужен хотя бы один автомобиль';

  @override
  String get fuelTypeCarsLabel => 'Доступно для автомобилей';

  @override
  String get catalogCarsRequired => 'Выберите хотя бы один автомобиль';

  @override
  String get partsTitle => 'Запчасти';

  @override
  String get partNameLabel => 'Название';

  @override
  String get partAddTitle => 'Добавить запчасть';

  @override
  String get partEditTitle => 'Редактировать запчасть';

  @override
  String get partDeleteConfirm => 'Вы точно хотите удалить?';

  @override
  String get partRestoreConfirm =>
      'Эта запись была помечена как удалённая. Восстановить?';

  @override
  String get partAlreadyExists => 'Запись с таким названием уже существует';

  @override
  String get partNameRequired => 'Введите название';

  @override
  String get servicesTitle => 'Сервисные работы';

  @override
  String get serviceNameLabel => 'Название';

  @override
  String get serviceAddTitle => 'Добавить работу';

  @override
  String get serviceEditTitle => 'Редактировать работу';

  @override
  String get serviceDeleteConfirm => 'Вы точно хотите удалить?';

  @override
  String get serviceRestoreConfirm =>
      'Эта запись была помечена как удалённая. Восстановить?';

  @override
  String get serviceAlreadyExists => 'Запись с таким названием уже существует';

  @override
  String get serviceNameRequired => 'Введите название';

  @override
  String get serviceIconLabel => 'Иконка';

  @override
  String get serviceCentersTitle => 'Сервисные центры';

  @override
  String get serviceCenterAddTitle => 'Добавить сервисный центр';

  @override
  String get serviceCenterEditTitle => 'Редактировать сервисный центр';

  @override
  String get serviceCenterDeleteConfirm => 'Вы точно хотите удалить?';

  @override
  String get gasStationsTitle => 'Сети АЗС';

  @override
  String get gasStationAddTitle => 'Добавить сеть';

  @override
  String get gasStationEditTitle => 'Редактировать сеть';

  @override
  String get gasStationAddAddressTitle => 'Добавить адрес';

  @override
  String get gasStationEditAddressTitle => 'Редактировать адрес';

  @override
  String get gasStationNoAddress => 'Без адреса';

  @override
  String get gasStationAddressesSection => 'Адреса';

  @override
  String get placeAddressRequired => 'Введите адрес';

  @override
  String gasStationLocationsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count адресов',
      many: '$count адресов',
      few: '$count адреса',
      one: '1 адрес',
      zero: 'Нет адресов',
    );
    return '$_temp0';
  }

  @override
  String get gasStationDeleteConfirm => 'Вы точно хотите удалить?';

  @override
  String get placeNameLabel => 'Название';

  @override
  String get placeAddressLabel => 'Адрес';

  @override
  String get placeNameRequired => 'Введите название';

  @override
  String get placeAlreadyExists => 'Запись с таким названием уже существует';

  @override
  String get placeRestoreConfirm =>
      'Эта запись была помечена как удалённая. Восстановить?';

  @override
  String get unitsFuelSection => 'Объём топлива';

  @override
  String get unitsDistanceSection => 'Расстояние';

  @override
  String get unitLiters => 'Литры';

  @override
  String get unitUsGallons => 'Галлоны (США)';

  @override
  String get unitImperialGallons => 'Галлоны (имп.)';

  @override
  String get unitKilometers => 'Километры';

  @override
  String get unitMiles => 'Мили';

  @override
  String get fuelingAddTitle => 'Добавить заправку';

  @override
  String get fuelingEditTitle => 'Редактировать заправку';

  @override
  String get fuelingDeleteConfirm => 'Вы точно хотите удалить эту заправку?';

  @override
  String get fuelingDateLabel => 'Дата';

  @override
  String fuelingPriceLabel(String unit) {
    return 'Цена за $unit';
  }

  @override
  String fuelingQuantityLabel(String unit) {
    return 'Количество ($unit)';
  }

  @override
  String get fuelingTotalLabel => 'Сумма';

  @override
  String get fuelingPriceRequired => 'Введите цену';

  @override
  String get fuelingQuantityRequired => 'Введите количество';

  @override
  String get fuelingQuantityOrTotalRequired => 'Введите количество или сумму';

  @override
  String get fuelingTotalRequired => 'Введите сумму';

  @override
  String fuelingOdometerLabel(String unit) {
    return 'Пробег ($unit)';
  }

  @override
  String get fuelingOdometerInvalid => 'Введите корректный пробег';

  @override
  String get fuelingOdometerSequenceTitle => 'Необычный пробег';

  @override
  String get fuelingOdometerLowerTitle => 'Пробег меньше более раннего';

  @override
  String fuelingOdometerLowerMessage(String value, String unit) {
    return 'Введённый пробег меньше, чем у более ранней заправки ($value $unit).';
  }

  @override
  String get fuelingOdometerHigherTitle => 'Пробег больше более позднего';

  @override
  String fuelingOdometerHigherMessage(String value, String unit) {
    return 'Введённый пробег больше, чем у более поздней заправки ($value $unit).';
  }

  @override
  String get fuelingOdometerWarningFooter =>
      'Это может исказить расход и другую статистику. Всё равно сохранить?';

  @override
  String get actionContinue => 'Продолжить';

  @override
  String fuelingListSubtitle(String quantity, String price, String unit) {
    return '$quantity $unit · $price / $unit';
  }

  @override
  String get unitFuelShortLiter => 'л';

  @override
  String get unitFuelShortUsGallon => 'gal';

  @override
  String get unitFuelShortImperialGallon => 'gal имп.';

  @override
  String get unitDistanceShortKm => 'км';

  @override
  String get unitDistanceShortMile => 'ми';

  @override
  String get currencyCodeLabel => 'Код валюты';

  @override
  String get currencyCodeHint => 'EUR';

  @override
  String get currencyCodeHelp => 'Три латинские буквы, например USD, EUR, RSD';

  @override
  String get currencyCodeInvalid => 'Введите ровно 3 латинские буквы';

  @override
  String get currenciesEditTitle => 'Валюты';

  @override
  String get currencyAddTitle => 'Добавить валюту';

  @override
  String get currencyEditTitle => 'Редактировать валюту';

  @override
  String get currencyDeleteConfirm => 'Вы точно хотите удалить эту валюту?';

  @override
  String get currencyAlreadyExists => 'Эта валюта уже есть в списке';

  @override
  String get currencyCannotDeleteLast => 'Оставьте хотя бы одну валюту';

  @override
  String get fuelingFuelTypeLabel => 'Тип топлива';

  @override
  String get fuelingFuelTypeRequired => 'Выберите или введите тип топлива';

  @override
  String get fuelingGasStationLabel => 'Заправка';

  @override
  String get fuelingGasStationEnsureFailed => 'Не удалось сохранить АЗС';

  @override
  String get maintenanceAddTitle => 'Добавить обслуживание';

  @override
  String get maintenanceEditTitle => 'Редактировать обслуживание';

  @override
  String get maintenanceDeleteConfirm =>
      'Вы точно хотите удалить эту запись обслуживания?';

  @override
  String get maintenanceDateLabel => 'Дата';

  @override
  String get maintenanceServiceLabel => 'Услуга';

  @override
  String get maintenanceServiceRequired => 'Выберите или введите услугу';

  @override
  String get maintenanceTotalLabel => 'Стоимость услуги';

  @override
  String get maintenanceTotalInvalid => 'Введите корректную стоимость услуги';

  @override
  String get maintenanceOdometerWarningFooter =>
      'Это может исказить статистику. Сохранить всё равно?';

  @override
  String get maintenancePartsSection => 'Запчасти';

  @override
  String get maintenancePartAddTitle => 'Добавить запчасть';

  @override
  String get maintenancePartEditTitle => 'Редактировать запчасть';

  @override
  String get maintenancePartNameLabel => 'Запчасть';

  @override
  String get maintenancePartNameRequired => 'Выберите или введите запчасть';

  @override
  String get maintenancePartAmountLabel => 'Цена';

  @override
  String get maintenancePartAmountInvalid => 'Введите корректную цену';

  @override
  String get maintenancePartQuantityLabel => 'Количество';

  @override
  String get maintenancePartQuantityInvalid => 'Введите корректное количество';

  @override
  String get maintenancePartUnitLabel => 'Единица';

  @override
  String get maintenancePartCommentLabel => 'Комментарий';

  @override
  String get maintenancePartDeleteConfirm => 'Удалить эту запчасть из списка?';

  @override
  String get maintenanceGrandTotalLabel => 'Сумма';

  @override
  String get partUnitsTitle => 'Единицы измерения запчастей';

  @override
  String get partUnitNameLabel => 'Название';

  @override
  String get partUnitAddTitle => 'Добавить единицу';

  @override
  String get partUnitEditTitle => 'Редактировать единицу';

  @override
  String get partUnitDeleteConfirm => 'Вы точно хотите удалить этот элемент?';

  @override
  String get partUnitRestoreConfirm =>
      'Элемент был помечен как удалённый. Восстановить?';

  @override
  String get partUnitAlreadyExists => 'Элемент с таким названием уже есть';

  @override
  String get partUnitNameRequired => 'Введите название';

  @override
  String get partUnitLiters => 'Литры';

  @override
  String get partUnitPieces => 'Штуки';

  @override
  String get partUnitPackages => 'Упаковки';

  @override
  String get statsGroupByMonths => 'По месяцам';

  @override
  String get statsGroupByYears => 'По годам';

  @override
  String get statsPeriodYear => 'Год';

  @override
  String get statsLegendFuel => 'Топливо';

  @override
  String get statsLegendMaintenance => 'Обслуживание';

  @override
  String get statsTotal => 'Итого';

  @override
  String get statsFuelDetails => 'Топливо по типам';

  @override
  String get statsMaintenanceDetails => 'Обслуживание по сервисам';

  @override
  String get statsUnknownCategory => 'Не указано';

  @override
  String get statsEmpty => 'Нет расходов за этот период';

  @override
  String get statsSelectedPeriod => 'Выбранный период';

  @override
  String get remindersTitle => 'Напоминания';

  @override
  String get reminderAddTitle => 'Добавить напоминание';

  @override
  String get reminderEditTitle => 'Редактировать напоминание';

  @override
  String get reminderTitleLabel => 'Название';

  @override
  String get reminderTitleRequired => 'Введите название';

  @override
  String get reminderCarLabel => 'Автомобиль';

  @override
  String get reminderCarRequired => 'Выберите автомобиль';

  @override
  String get reminderByDate => 'По дате';

  @override
  String get reminderByOdometer => 'По пробегу';

  @override
  String get reminderOdometerModeAfter => 'Через';

  @override
  String get reminderOdometerModeAbsolute => 'Точный пробег';

  @override
  String reminderOdometerAfterLabel(String unit) {
    return 'Через ($unit)';
  }

  @override
  String reminderOdometerDuePreview(String value, String unit) {
    return 'Срок: $value $unit';
  }

  @override
  String reminderOdometerCurrentReading(String value, String unit) {
    return 'Сейчас: $value $unit';
  }

  @override
  String get reminderOdometerBaselineMissing =>
      'Нет текущего пробега для этой машины';

  @override
  String get reminderDueDateLabel => 'Дата события';

  @override
  String get reminderDateHint => 'Выберите дату';

  @override
  String get reminderDateRequired => 'Укажите дату события';

  @override
  String get reminderOdometerRequired => 'Укажите целевой пробег';

  @override
  String get reminderTriggerRequired => 'Укажите дату, пробег или оба';

  @override
  String get reminderSyncFailed =>
      'Не удалось синхронизировать связанное напоминание';

  @override
  String get reminderRemindBeforeDaysLabel => 'Напомнить за (дней)';

  @override
  String reminderRemindBeforeDistanceLabel(String unit) {
    return 'Напомнить за ($unit)';
  }

  @override
  String get reminderRemindBeforeInvalid => 'Введите неотрицательное значение';

  @override
  String reminderRemindBeforeDays(int days) {
    return 'за $days дн.';
  }

  @override
  String reminderRemindBeforeDistance(String distance) {
    return 'за $distance';
  }

  @override
  String get reminderCompleted => 'Выполнено';

  @override
  String get reminderDeleteConfirm =>
      'Вы точно хотите удалить это напоминание?';

  @override
  String get maintenanceAddReminder => 'Добавить напоминание';

  @override
  String get maintenanceEditReminder => 'Редактировать напоминание';

  @override
  String get settingsBackup => 'Резервная копия';

  @override
  String get backupDescription =>
      'Экспортируйте все настройки и события в JSON-файл, поделитесь копией с другим приложением (например Google Диск) или импортируйте ранее сохранённую копию. Точные дубликаты при импорте пропускаются.';

  @override
  String get backupExport => 'Экспорт в JSON';

  @override
  String get backupShare => 'Поделиться копией';

  @override
  String get backupImport => 'Импорт из JSON';

  @override
  String get backupExportSuccess => 'Резервная копия экспортирована';

  @override
  String get backupShareSuccess => 'Копия отправлена';

  @override
  String get backupExportFailed => 'Не удалось экспортировать копию';

  @override
  String backupImportSuccess(int added, int skipped) {
    return 'Импорт завершён: добавлено $added, пропущено $skipped';
  }

  @override
  String get backupImportFailed => 'Не удалось импортировать копию';

  @override
  String get backupImportPrefsFailed =>
      'Данные импортированы, но настройки применить не удалось';

  @override
  String get backupImportEmpty => 'Файл резервной копии пуст';

  @override
  String get backupImportInvalid =>
      'Файл резервной копии не является корректным JSON';

  @override
  String get backupImportUnsupportedVersion =>
      'Эта версия резервной копии не поддерживается';

  @override
  String get settingsPrivacy => 'Политика конфиденциальности';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get languageSystem => 'Как в системе';

  @override
  String get privacyOpenFailed => 'Не удалось открыть ссылку';

  @override
  String get formActionFailed =>
      'Не удалось выполнить действие. Попробуйте ещё раз.';

  @override
  String get appStartFailed =>
      'Не удалось запустить приложение. Переустановите его или обратитесь в поддержку.';

  @override
  String get photoTooLarge =>
      'Фото слишком большое. Выберите изображение меньшего размера.';
}
