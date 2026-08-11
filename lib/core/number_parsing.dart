/// Shared decimal parsing for form fields (price, quantity, odometer, …).
double? parseFlexibleDouble(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return null;
  final normalized = trimmed.replaceAll(',', '.');
  return double.tryParse(normalized);
}
