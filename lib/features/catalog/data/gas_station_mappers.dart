import '../../../shared/data/db/app_database.dart';
import '../domain/entities/gas_station.dart';

GasStationChainItem mapGasStationChain(GasStationChain row) {
  return GasStationChainItem(
    id: row.id,
    name: row.name,
    isDeleted: row.isDeleted,
  );
}

GasStationLocationItem mapGasStationLocation(GasStationLocation row) {
  return GasStationLocationItem(
    id: row.id,
    chainId: row.chainId,
    address: row.address,
    isDeleted: row.isDeleted,
  );
}
