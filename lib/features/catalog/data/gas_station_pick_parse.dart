/// Parses free-text gas-station pick input into chain name + optional address.
///
/// Accepts separators: ` · `, ` • `, ` - `, ` – `, `|`.
({String chainName, String? address}) parseGasStationPickInput(String raw) {
  final text = raw.trim();
  if (text.isEmpty) return (chainName: '', address: null);

  const separators = [' · ', ' • ', ' - ', ' – ', '|'];
  for (final separator in separators) {
    final index = text.indexOf(separator);
    if (index <= 0) continue;
    final chainName = text.substring(0, index).trim();
    final address = text.substring(index + separator.length).trim();
    return (
      chainName: chainName,
      address: address.isEmpty ? null : address,
    );
  }
  return (chainName: text, address: null);
}
