import 'named_place.dart';

/// Gas-station brand / network.
class GasStationChainItem {
  const GasStationChainItem({
    required this.id,
    required this.name,
    required this.isDeleted,
  });

  final int id;
  final String name;
  final bool isDeleted;
}

/// Physical location belonging to a chain.
class GasStationLocationItem {
  const GasStationLocationItem({
    required this.id,
    required this.chainId,
    required this.isDeleted,
    this.address,
  });

  final int id;
  final int chainId;
  final String? address;
  final bool isDeleted;
}

class GasStationChainSaveOutcome {
  const GasStationChainSaveOutcome(this.result, {this.chain});

  final CatalogSaveResult result;
  final GasStationChainItem? chain;
}

class GasStationLocationSaveOutcome {
  const GasStationLocationSaveOutcome(this.result, {this.location});

  final CatalogSaveResult result;
  final GasStationLocationItem? location;
}

/// One autocomplete row: a chain alone, or a chain + address.
class GasStationPickOption {
  const GasStationPickOption({
    required this.chainName,
    this.locationId,
    this.address,
  });

  /// Null when this is a brand-only option that is not persisted yet.
  final int? locationId;
  final String chainName;
  final String? address;

  String get label {
    final trimmed = address?.trim();
    if (trimmed == null || trimmed.isEmpty) return chainName;
    return '$chainName · $trimmed';
  }
}

class GasStationChainWithLocations {
  const GasStationChainWithLocations({
    required this.chain,
    required this.locations,
  });

  final GasStationChainItem chain;
  final List<GasStationLocationItem> locations;
}
