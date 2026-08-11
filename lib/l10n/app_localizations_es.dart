// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Historial del auto';

  @override
  String get navData => 'Datos';

  @override
  String get navStatistics => 'Estadísticas';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get tabAll => 'Todo';

  @override
  String get tabFuelings => 'Repostajes';

  @override
  String get tabMaintenance => 'Mantenimiento';

  @override
  String get settingsCars => 'Autos';

  @override
  String get settingsFuel => 'Combustible';

  @override
  String get settingsParts => 'Piezas';

  @override
  String get settingsServices => 'Servicios';

  @override
  String get settingsServiceCenters => 'Talleres';

  @override
  String get settingsGasStations => 'Cadenas de gasolineras';

  @override
  String get settingsReminders => 'Recordatorios';

  @override
  String get settingsUnits => 'Unidades de medida';

  @override
  String get settingsPartUnits => 'Unidades de piezas';

  @override
  String get settingsCurrency => 'Moneda';

  @override
  String get settingsSectionVehicle => 'Vehículo';

  @override
  String get settingsSectionFuel => 'Combustible';

  @override
  String get settingsSectionService => 'Mantenimiento';

  @override
  String get settingsSectionSystem => 'Sistema';

  @override
  String get fuelTypesTitle => 'Tipos de combustible';

  @override
  String get fuelTypePetrol95 => 'Gasolina 95';

  @override
  String get fuelTypePetrol100 => 'Gasolina 100';

  @override
  String get fuelTypeDiesel => 'Diésel';

  @override
  String get actionAdd => 'Añadir';

  @override
  String get actionSave => 'Guardar';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionDelete => 'Eliminar';

  @override
  String get actionRestore => 'Restaurar';

  @override
  String get actionEdit => 'Editar';

  @override
  String get actionDefault => 'Predeterminado';

  @override
  String get actionSetDefault => 'Establecer como predeterminado';

  @override
  String get fuelTypeNameLabel => 'Nombre';

  @override
  String get fuelTypeAddTitle => 'Añadir tipo de combustible';

  @override
  String get fuelTypeEditTitle => 'Editar tipo de combustible';

  @override
  String get fuelTypeDeleteConfirm =>
      '¿Seguro que quieres eliminar este elemento?';

  @override
  String get fuelTypeRestoreConfirm =>
      'Este elemento estaba marcado como eliminado. ¿Restaurar?';

  @override
  String get fuelTypeAlreadyExists => 'Ya existe un elemento con este nombre';

  @override
  String get fuelTypeNameRequired => 'Introduce un nombre';

  @override
  String get listEmpty => 'La lista está vacía';

  @override
  String get listLoadError => 'No se pudo cargar la lista';

  @override
  String get carsTitle => 'Autos';

  @override
  String get carAddTitle => 'Añadir auto';

  @override
  String get carEditTitle => 'Editar auto';

  @override
  String get carBrandLabel => 'Marca';

  @override
  String get carDefaultLabel => 'Auto predeterminado';

  @override
  String get carModelLabel => 'Modelo';

  @override
  String get carYearLabel => 'Año';

  @override
  String get carPhotoLabel => 'Foto';

  @override
  String get carPhotoPick => 'Elegir foto';

  @override
  String get carPhotoPickError =>
      'No se pudo abrir el selector de fotos. Reinicia la app por completo e inténtalo de nuevo.';

  @override
  String get carPhotoRemove => 'Quitar foto';

  @override
  String get carColorLabel => 'Color';

  @override
  String get carBrandRequired => 'La marca es obligatoria';

  @override
  String get carYearInvalid => 'Introduce un año válido';

  @override
  String get carDeleteConfirm =>
      '¿Seguro que quieres eliminar este auto? Se eliminarán todos los datos relacionados.';

  @override
  String get swipeDeleteTip =>
      'Desliza a la izquierda para eliminar un registro';

  @override
  String get doubleTapEditTip => 'Toca dos veces un registro para editarlo';

  @override
  String get tipDontShowAgain => 'No mostrar de nuevo';

  @override
  String get seedCarBrand => 'Marca';

  @override
  String get seedCarModel => 'Modelo';

  @override
  String carLimitReached(int max) {
    return 'Puedes añadir hasta $max autos';
  }

  @override
  String get carDeleteLastBlocked => 'Necesitas al menos un auto';

  @override
  String get fuelTypeCarsLabel => 'Disponible para autos';

  @override
  String get catalogCarsRequired => 'Selecciona al menos un auto';

  @override
  String get partsTitle => 'Piezas';

  @override
  String get partNameLabel => 'Nombre';

  @override
  String get partAddTitle => 'Añadir pieza';

  @override
  String get partEditTitle => 'Editar pieza';

  @override
  String get partDeleteConfirm => '¿Seguro que quieres eliminar este elemento?';

  @override
  String get partRestoreConfirm =>
      'Este elemento estaba marcado como eliminado. ¿Restaurar?';

  @override
  String get partAlreadyExists => 'Ya existe un elemento con este nombre';

  @override
  String get partNameRequired => 'Introduce un nombre';

  @override
  String get servicesTitle => 'Servicios';

  @override
  String get serviceNameLabel => 'Nombre';

  @override
  String get serviceAddTitle => 'Añadir servicio';

  @override
  String get serviceEditTitle => 'Editar servicio';

  @override
  String get serviceDeleteConfirm =>
      '¿Seguro que quieres eliminar este elemento?';

  @override
  String get serviceRestoreConfirm =>
      'Este elemento estaba marcado como eliminado. ¿Restaurar?';

  @override
  String get serviceAlreadyExists => 'Ya existe un elemento con este nombre';

  @override
  String get serviceNameRequired => 'Introduce un nombre';

  @override
  String get serviceIconLabel => 'Icono';

  @override
  String get serviceCentersTitle => 'Talleres';

  @override
  String get serviceCenterAddTitle => 'Añadir taller';

  @override
  String get serviceCenterEditTitle => 'Editar taller';

  @override
  String get serviceCenterDeleteConfirm =>
      '¿Seguro que quieres eliminar este elemento?';

  @override
  String get gasStationsTitle => 'Cadenas de gasolineras';

  @override
  String get gasStationAddTitle => 'Añadir cadena';

  @override
  String get gasStationEditTitle => 'Editar cadena';

  @override
  String get gasStationAddAddressTitle => 'Añadir dirección';

  @override
  String get gasStationEditAddressTitle => 'Editar dirección';

  @override
  String get gasStationNoAddress => 'Sin dirección';

  @override
  String get gasStationAddressesSection => 'Direcciones';

  @override
  String get placeAddressRequired => 'Introduce una dirección';

  @override
  String gasStationLocationsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count direcciones',
      one: '1 dirección',
      zero: 'Sin direcciones',
    );
    return '$_temp0';
  }

  @override
  String get gasStationDeleteConfirm =>
      '¿Seguro que quieres eliminar este elemento?';

  @override
  String get placeNameLabel => 'Nombre';

  @override
  String get placeAddressLabel => 'Dirección';

  @override
  String get placeNameRequired => 'Introduce un nombre';

  @override
  String get placeAlreadyExists => 'Ya existe un elemento con este nombre';

  @override
  String get placeRestoreConfirm =>
      'Este elemento estaba marcado como eliminado. ¿Restaurar?';

  @override
  String get unitsFuelSection => 'Volumen de combustible';

  @override
  String get unitsDistanceSection => 'Distancia';

  @override
  String get unitLiters => 'Litros';

  @override
  String get unitUsGallons => 'Galones EE. UU.';

  @override
  String get unitImperialGallons => 'Galones imperiales';

  @override
  String get unitKilometers => 'Kilómetros';

  @override
  String get unitMiles => 'Millas';

  @override
  String get fuelingAddTitle => 'Añadir repostaje';

  @override
  String get fuelingEditTitle => 'Editar repostaje';

  @override
  String get fuelingDeleteConfirm =>
      '¿Seguro que quieres eliminar este repostaje?';

  @override
  String get fuelingDateLabel => 'Fecha';

  @override
  String fuelingPriceLabel(String unit) {
    return 'Precio por $unit';
  }

  @override
  String fuelingQuantityLabel(String unit) {
    return 'Cantidad ($unit)';
  }

  @override
  String get fuelingTotalLabel => 'Total';

  @override
  String get fuelingPriceRequired => 'Introduce el precio';

  @override
  String get fuelingQuantityRequired => 'Introduce la cantidad';

  @override
  String get fuelingQuantityOrTotalRequired =>
      'Introduce la cantidad o el total';

  @override
  String get fuelingTotalRequired => 'Introduce el importe total';

  @override
  String fuelingOdometerLabel(String unit) {
    return 'Odómetro ($unit)';
  }

  @override
  String get fuelingOdometerInvalid =>
      'Introduce una lectura de odómetro válida';

  @override
  String get fuelingOdometerSequenceTitle => 'Valor de odómetro inusual';

  @override
  String get fuelingOdometerLowerTitle =>
      'Odómetro menor que una lectura anterior';

  @override
  String fuelingOdometerLowerMessage(String value, String unit) {
    return 'El odómetro es menor que una lectura anterior ($value $unit).';
  }

  @override
  String get fuelingOdometerHigherTitle =>
      'Odómetro mayor que una lectura posterior';

  @override
  String fuelingOdometerHigherMessage(String value, String unit) {
    return 'El odómetro es mayor que una lectura posterior ($value $unit).';
  }

  @override
  String get fuelingOdometerWarningFooter =>
      'Esto puede distorsionar el consumo y otras estadísticas. ¿Guardar de todos modos?';

  @override
  String get actionContinue => 'Continuar';

  @override
  String fuelingListSubtitle(String quantity, String price, String unit) {
    return '$quantity $unit · $price / $unit';
  }

  @override
  String get unitFuelShortLiter => 'L';

  @override
  String get unitFuelShortUsGallon => 'gal EE.UU.';

  @override
  String get unitFuelShortImperialGallon => 'gal imp.';

  @override
  String get unitDistanceShortKm => 'km';

  @override
  String get unitDistanceShortMile => 'mi';

  @override
  String get currencyCodeLabel => 'Código de moneda';

  @override
  String get currencyCodeHint => 'EUR';

  @override
  String get currencyCodeHelp => 'Tres letras latinas, p. ej. USD, EUR, RSD';

  @override
  String get currencyCodeInvalid => 'Introduce exactamente 3 letras latinas';

  @override
  String get currenciesEditTitle => 'Monedas';

  @override
  String get currencyAddTitle => 'Añadir moneda';

  @override
  String get currencyEditTitle => 'Editar moneda';

  @override
  String get currencyDeleteConfirm =>
      '¿Seguro que quieres eliminar esta moneda?';

  @override
  String get currencyAlreadyExists => 'Esta moneda ya está en la lista';

  @override
  String get currencyCannotDeleteLast => 'Conserva al menos una moneda';

  @override
  String get fuelingFuelTypeLabel => 'Tipo de combustible';

  @override
  String get fuelingFuelTypeRequired =>
      'Selecciona o introduce un tipo de combustible';

  @override
  String get fuelingGasStationLabel => 'Gasolinera';

  @override
  String get fuelingGasStationEnsureFailed =>
      'No se pudo guardar la gasolinera';

  @override
  String get maintenanceAddTitle => 'Añadir mantenimiento';

  @override
  String get maintenanceEditTitle => 'Editar mantenimiento';

  @override
  String get maintenanceDeleteConfirm =>
      '¿Seguro que quieres eliminar este registro de mantenimiento?';

  @override
  String get maintenanceDateLabel => 'Fecha';

  @override
  String get maintenanceServiceLabel => 'Servicio';

  @override
  String get maintenanceServiceRequired => 'Selecciona o introduce un servicio';

  @override
  String get maintenanceTotalLabel => 'Coste del servicio';

  @override
  String get maintenanceTotalInvalid => 'Introduce un coste de servicio válido';

  @override
  String get maintenanceOdometerWarningFooter =>
      'Esto puede distorsionar las estadísticas. ¿Guardar de todos modos?';

  @override
  String get maintenancePartsSection => 'Piezas';

  @override
  String get maintenancePartAddTitle => 'Añadir pieza';

  @override
  String get maintenancePartEditTitle => 'Editar pieza';

  @override
  String get maintenancePartNameLabel => 'Pieza';

  @override
  String get maintenancePartNameRequired => 'Selecciona o introduce una pieza';

  @override
  String get maintenancePartAmountLabel => 'Precio';

  @override
  String get maintenancePartAmountInvalid => 'Introduce un precio válido';

  @override
  String get maintenancePartQuantityLabel => 'Cantidad';

  @override
  String get maintenancePartQuantityInvalid => 'Introduce una cantidad válida';

  @override
  String get maintenancePartUnitLabel => 'Unidad';

  @override
  String get maintenancePartCommentLabel => 'Comentario';

  @override
  String get maintenancePartDeleteConfirm => '¿Quitar esta pieza de la lista?';

  @override
  String get maintenanceGrandTotalLabel => 'Importe';

  @override
  String get partUnitsTitle => 'Unidades de piezas';

  @override
  String get partUnitNameLabel => 'Nombre';

  @override
  String get partUnitAddTitle => 'Añadir unidad';

  @override
  String get partUnitEditTitle => 'Editar unidad';

  @override
  String get partUnitDeleteConfirm =>
      '¿Seguro que quieres eliminar este elemento?';

  @override
  String get partUnitRestoreConfirm =>
      'Este elemento estaba marcado como eliminado. ¿Restaurar?';

  @override
  String get partUnitAlreadyExists => 'Ya existe un elemento con este nombre';

  @override
  String get partUnitNameRequired => 'Introduce un nombre';

  @override
  String get partUnitLiters => 'Litros';

  @override
  String get partUnitPieces => 'Unidades';

  @override
  String get partUnitPackages => 'Paquetes';

  @override
  String get statsGroupByMonths => 'Por meses';

  @override
  String get statsGroupByYears => 'Por años';

  @override
  String get statsPeriodYear => 'Año';

  @override
  String get statsLegendFuel => 'Combustible';

  @override
  String get statsLegendMaintenance => 'Mantenimiento';

  @override
  String get statsTotal => 'Total';

  @override
  String get statsFuelDetails => 'Combustible por tipo';

  @override
  String get statsMaintenanceDetails => 'Mantenimiento por servicio';

  @override
  String get statsUnknownCategory => 'Desconocido';

  @override
  String get statsEmpty => 'No hay gastos en este periodo';

  @override
  String get statsSelectedPeriod => 'Periodo seleccionado';

  @override
  String get remindersTitle => 'Recordatorios';

  @override
  String get reminderAddTitle => 'Añadir recordatorio';

  @override
  String get reminderEditTitle => 'Editar recordatorio';

  @override
  String get reminderTitleLabel => 'Título';

  @override
  String get reminderTitleRequired => 'Introduce un título';

  @override
  String get reminderCarLabel => 'Auto';

  @override
  String get reminderCarRequired => 'Selecciona un auto';

  @override
  String get reminderByDate => 'Por fecha';

  @override
  String get reminderByOdometer => 'Por odómetro';

  @override
  String get reminderDueDateLabel => 'Fecha límite';

  @override
  String get reminderDateHint => 'Selecciona una fecha';

  @override
  String get reminderDateRequired => 'Selecciona una fecha límite';

  @override
  String get reminderOdometerRequired =>
      'Introduce una lectura de odómetro objetivo';

  @override
  String get reminderTriggerRequired => 'Define una fecha, un odómetro o ambos';

  @override
  String get reminderSyncFailed =>
      'No se pudo sincronizar el recordatorio vinculado';

  @override
  String get reminderRemindBeforeDaysLabel => 'Recordar con antelación (días)';

  @override
  String reminderRemindBeforeDistanceLabel(String unit) {
    return 'Recordar con antelación ($unit)';
  }

  @override
  String get reminderRemindBeforeInvalid =>
      'Introduce un valor no negativo válido';

  @override
  String reminderRemindBeforeDays(int days) {
    return 'en $days días';
  }

  @override
  String reminderRemindBeforeDistance(String distance) {
    return 'antes de $distance';
  }

  @override
  String get reminderCompleted => 'Completado';

  @override
  String get reminderDeleteConfirm =>
      '¿Seguro que quieres eliminar este recordatorio?';

  @override
  String get maintenanceAddReminder => 'Añadir recordatorio';

  @override
  String get maintenanceEditReminder => 'Editar recordatorio';

  @override
  String get settingsBackup => 'Copia de seguridad';

  @override
  String get backupDescription =>
      'Exporta todos los ajustes y eventos a un archivo JSON, comparte la copia con otra app (por ejemplo Google Drive) o importa una copia exportada anteriormente. Los duplicados exactos se omiten al importar.';

  @override
  String get backupExport => 'Exportar a JSON';

  @override
  String get backupShare => 'Compartir copia';

  @override
  String get backupImport => 'Importar desde JSON';

  @override
  String get backupExportSuccess => 'Copia de seguridad exportada';

  @override
  String get backupShareSuccess => 'Copia compartida';

  @override
  String get backupExportFailed => 'No se pudo exportar la copia de seguridad';

  @override
  String backupImportSuccess(int added, int skipped) {
    return 'Importación finalizada: $added añadidos, $skipped omitidos';
  }

  @override
  String get backupImportFailed => 'No se pudo importar la copia de seguridad';

  @override
  String get backupImportPrefsFailed =>
      'Datos importados, pero no se pudieron aplicar las preferencias';

  @override
  String get backupImportEmpty => 'El archivo de copia está vacío';

  @override
  String get backupImportInvalid => 'El archivo de copia no es un JSON válido';

  @override
  String get backupImportUnsupportedVersion =>
      'Esta versión de copia de seguridad no es compatible';

  @override
  String get settingsPrivacy => 'Política de privacidad';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get languageSystem => 'Predeterminado del sistema';

  @override
  String get privacyOpenFailed => 'No se pudo abrir el enlace';

  @override
  String get formActionFailed =>
      'No se pudo completar la acción. Inténtalo de nuevo.';

  @override
  String get appStartFailed =>
      'No se pudo iniciar la app. Reinstálala o contacta con el soporte.';

  @override
  String get photoTooLarge =>
      'La foto es demasiado grande. Elige una imagen más pequeña.';
}
