/// Formats decimals for form fields (trims trailing zeros).
String formatFlexibleDouble(double value) {
  final rounded = (value * 1000).roundToDouble() / 1000;
  if (rounded == rounded.roundToDouble()) {
    return rounded.toStringAsFixed(0);
  }
  var text = rounded.toStringAsFixed(3);
  while (text.contains('.') && text.endsWith('0')) {
    text = text.substring(0, text.length - 1);
  }
  if (text.endsWith('.')) {
    text = text.substring(0, text.length - 1);
  }
  return text;
}
