import 'package:flutter/material.dart';

/// Fixed catalog of icons available for services.
abstract final class ServiceIcons {
  static const String defaultKey = handyman;

  static const String directionsCar = 'directions_car';
  static const String carRepair = 'car_repair';
  static const String carCrash = 'car_crash';
  static const String carRental = 'car_rental';
  static const String carGear = 'car_gear';
  static const String localCarWash = 'local_car_wash';
  static const String waterDrop = 'water_drop';
  static const String garage = 'garage';
  static const String localParking = 'local_parking';
  static const String searchHandsFree = 'search_hands_free';
  static const String speedCamera = 'speed_camera';
  static const String speed = 'speed';
  static const String traffic = 'traffic';
  static const String transitTicket = 'transit_ticket';
  static const String batteryCharging = 'battery_charging';
  static const String paid = 'paid';
  static const String attachMoney = 'attach_money';
  static const String handyman = 'handyman';
  static const String build = 'build';
  static const String settings = 'settings';
  static const String oilBarrel = 'oil_barrel';
  static const String localGasStation = 'local_gas_station';
  static const String evStation = 'ev_station';
  static const String history = 'history';
  static const String tireRepair = 'tire_repair';
  static const String co2 = 'co2';
  static const String ballot = 'ballot';
  static const String assignment = 'assignment';
  static const String book = 'book';
  static const String idCard = 'id_card';
  static const String localPolice = 'local_police';
  static const String findInPage = 'find_in_page';

  /// Legacy keys kept for existing DB rows.
  static const String carWash = 'car_wash';
  static const String detailing = 'detailing';
  static const String documents = 'documents';
  static const String oil = 'oil';
  static const String tires = 'tires';
  static const String battery = 'battery';
  static const String diagnostics = 'diagnostics';
  static const String body = 'body';
  static const String inspection = 'inspection';
  static const String carTag = 'car_tag';
  static const String noCrash = 'no_crash';
  static const String rainyLight = 'rainy_light';
  static const String autoTransmission = 'auto_transmission';
  static const String parkingSign = 'parking_sign';
  static const String parkingValet = 'parking_valet';
  static const String fragrance = 'fragrance';
  static const String manufacturing = 'manufacturing';
  static const String book2 = 'book2';
  static const String passport = 'passport';

  static const List<String> keys = [
    directionsCar,
    carRepair,
    carCrash,
    carRental,
    carGear,
    localCarWash,
    waterDrop,
    garage,
    localParking,
    searchHandsFree,
    speedCamera,
    speed,
    traffic,
    transitTicket,
    batteryCharging,
    paid,
    attachMoney,
    handyman,
    build,
    settings,
    oilBarrel,
    localGasStation,
    evStation,
    history,
    tireRepair,
    co2,
    ballot,
    assignment,
    book,
    idCard,
    localPolice,
    findInPage,
  ];

  static IconData iconForKey(String? key) {
    return switch (key) {
      directionsCar => Icons.directions_car_outlined,
      carRepair => Icons.car_repair_outlined,
      carCrash || body => Icons.car_crash_outlined,
      carRental => Icons.car_rental_outlined,
      carGear => Icons.settings_suggest_outlined,
      localCarWash || carWash => Icons.local_car_wash_outlined,
      waterDrop => Icons.water_drop_outlined,
      garage => Icons.garage_outlined,
      localParking || parkingSign => Icons.local_parking,
      searchHandsFree => Icons.front_hand_outlined,
      speedCamera => Icons.camera_alt_outlined,
      speed => Icons.speed,
      traffic => Icons.traffic_outlined,
      transitTicket => Icons.confirmation_number_outlined,
      batteryCharging || battery => Icons.battery_charging_full_outlined,
      paid => Icons.paid_outlined,
      attachMoney => Icons.attach_money,
      build => Icons.build_outlined,
      settings => Icons.settings_outlined,
      oilBarrel || oil => Icons.oil_barrel_outlined,
      localGasStation => Icons.local_gas_station_outlined,
      evStation => Icons.ev_station_outlined,
      history => Icons.history,
      tireRepair || tires => Icons.tire_repair,
      co2 => Icons.co2_outlined,
      ballot => Icons.ballot_outlined,
      assignment || documents => Icons.assignment_outlined,
      book => Icons.book_outlined,
      idCard => Icons.badge_outlined,
      localPolice => Icons.local_police_outlined,
      findInPage => Icons.find_in_page_outlined,
      // Removed from picker, but still resolve for existing rows.
      carTag => Icons.local_offer_outlined,
      noCrash => Icons.health_and_safety_outlined,
      rainyLight => Icons.grain,
      autoTransmission => Icons.tune,
      parkingValet => Icons.hail,
      fragrance => Icons.spa_outlined,
      manufacturing => Icons.precision_manufacturing_outlined,
      book2 => Icons.menu_book_outlined,
      passport => Icons.airplane_ticket_outlined,
      detailing => Icons.auto_awesome_outlined,
      diagnostics => Icons.troubleshoot_outlined,
      inspection => Icons.fact_check_outlined,
      handyman || null || _ => Icons.handyman_outlined,
    };
  }

  /// Normalizes a stored/selected key to a known catalog value.
  static String normalize(String? key) {
    if (key == null) return defaultKey;
    if (keys.contains(key)) return key;
    // Map removed/legacy keys onto current catalog entries.
    return switch (key) {
      carWash => localCarWash,
      oil => oilBarrel,
      tires => tireRepair,
      battery => batteryCharging,
      body || carTag || noCrash => carCrash,
      documents => assignment,
      parkingSign => localParking,
      book2 => book,
      rainyLight => waterDrop,
      autoTransmission => carGear,
      parkingValet => localParking,
      fragrance => localCarWash,
      manufacturing => settings,
      passport => idCard,
      detailing || diagnostics || inspection => handyman,
      _ => defaultKey,
    };
  }
}
